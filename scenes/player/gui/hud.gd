extends CanvasLayer

@onready var _panel := $bg as PanelContainer
@onready var _resume := $%resume as Button
@onready var _controls := $controls_bg as AcceptDialog


func _ready() -> void:
    _panel.visible = false


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_released("pause"):
        _panel.visible = !_panel.visible

        get_tree().paused = _panel.visible

        if _panel.visible:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
            _resume.grab_focus()
        else:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_resume_button_up() -> void:
    _panel.visible = false
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    get_tree().paused = false


func _on_restart_button_up() -> void:
    _panel.visible = false
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    get_tree().reload_current_scene()
    get_tree().paused = false


func _on_controls_button_up() -> void:
    _controls.popup_centered()


func _on_quit_button_up() -> void:
    GameManager.quit_to_menu()
