extends Node

@onready var _light := $env/omni_light_3d as OmniLight3D
@onready var _timer := _light.get_node("timer") as Timer


func _ready() -> void:
    $%play.grab_focus()


func _on_play_button_up() -> void:
    GameManager.load_test_level()


func _on_options_button_up() -> void:
    pass # Replace with function body.


func _on_quit_button_up() -> void:
    get_tree().quit()


func _on_light_timer_timeout() -> void:
    if is_zero_approx(_light.light_energy):
        _light.light_energy = 1
    else:
        _light.light_energy = 0
    _timer.start(randf_range(0.1, 1.0))
