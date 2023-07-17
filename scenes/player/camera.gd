extends Node3D
class_name PlayerCamera

const MIN_Y := -PI / 2.0
const MAX_Y := 0.0
const FPV_MIN := -5 * PI / 12.0
const FPV_MAX := 5 * PI / 12.0

@export var mouse_sensitivity := 0.01
@export var joy_sensitivity := 2.0
@export var player_model: Node3D
@onready var hand := $fpv_camera/hand as RayCast3D
@onready var _arm := $arm as SpringArm3D
@onready var _3rd_camera := $arm/camera as Camera3D
@onready var _1st_camera := $fpv_camera as Camera3D
@onready var _crosshair := $fpv_camera/crosshair as TextureRect
var is_fpv := false:
    set(value):
        if value == is_fpv:
            return

        is_fpv = value
        _crosshair.visible = is_fpv

        _arm.rotation.y = player_model.rotation.y
        _1st_camera.rotation.x = 0
        _1st_camera.rotation.y = player_model.rotation.y

        if is_fpv:
            _1st_camera.current = true
        else:
            _3rd_camera.current = true


func get_angle() -> float:
    return _arm.rotation.y if !is_fpv else _1st_camera.rotation.y


func rotate_fpv(angle: float, delta: float) -> void:
    _1st_camera.rotation.y = lerp_angle(
            _1st_camera.rotation.y, angle, delta)


func rotate_camera_joy(input: Vector2, delta: float) -> void:
    if is_fpv:
        _1st_camera.rotation.x = clampf(_1st_camera.rotation.x +\
            input.x * joy_sensitivity * delta, FPV_MIN, FPV_MAX)
        _1st_camera.rotation.y = lerp_angle(_1st_camera.rotation.y,
            _1st_camera.rotation.y - input.y * joy_sensitivity * delta, 0.4)
    else:
        _arm.rotation.y += input.x * joy_sensitivity * delta
        _arm.rotation.x = clampf(
            _arm.rotation.x - input.y * joy_sensitivity * delta, MIN_Y, MAX_Y)


func rotate_camera_mouse(input: Vector2) -> void:
    if is_fpv:
        _1st_camera.rotation.x = clampf(_1st_camera.rotation.x -\
                input.y * mouse_sensitivity, FPV_MIN, FPV_MAX)
        _1st_camera.rotation.y = lerp_angle(_1st_camera.rotation.y,
            _1st_camera.rotation.y - input.x * mouse_sensitivity, 0.4)
    else:
        _arm.rotation.y -= input.x * mouse_sensitivity
        _arm.rotation.x = clampf(
            _arm.rotation.x - input.y * mouse_sensitivity, MIN_Y, MAX_Y)
