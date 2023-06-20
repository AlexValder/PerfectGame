extends Node


func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_released("pause"):
        get_tree().quit()
