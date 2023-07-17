extends Node
class_name PlayerState

signal state_change(current_state, new_state)

@onready var player := self.owner as Player


func on_enter() -> void:
    pass


func can_enter() -> bool:
    return true


func on_leave() -> void:
    pass


func can_leave() -> bool:
    return true


func physics_process(_delta: float) -> void:
    pass


func process(_delta: float) -> void:
    pass


func unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        var e := event as InputEventMouseMotion
        player.camera.rotate_camera_mouse(e.relative)


func _rotate_camera(delta: float) -> void:
    var input := Input.get_vector(
        "camera_right", "camera_left", "camera_down", "camera_up")

    player.camera.rotate_camera_joy(input, delta)

