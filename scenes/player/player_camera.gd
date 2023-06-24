extends Node3D
class_name PlayerCamera

@export var mouse_sensitivity := 0.01
@export var joy_sensitivity := 2.0
@onready var _arm := $arm as SpringArm3D

const MIN_Y := -PI/2.0
const MAX_Y := 0.0


func get_angle() -> float:
    return _arm.rotation.y


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        var e := event as InputEventMouseMotion
        _arm.rotation.y -= e.relative.x * mouse_sensitivity
        _arm.rotation.x = clampf(
            _arm.rotation.x - e.relative.y * mouse_sensitivity, MIN_Y, MAX_Y)


func _physics_process(delta: float) -> void:
    var input := Input.get_vector(
        "camera_right", "camera_left", "camera_down", "camera_up")

    _arm.rotation.y += input.x * joy_sensitivity * delta
    _arm.rotation.x = clampf(
            _arm.rotation.x + input.y * joy_sensitivity * delta, MIN_Y, MAX_Y)
