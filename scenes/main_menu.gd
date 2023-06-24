extends Node


func _ready() -> void:
    $%play.grab_focus()


func _on_play_button_up() -> void:
    GameManager.load_test_level()


func _on_options_button_up() -> void:
    pass # Replace with function body.


func _on_quit_button_up() -> void:
    get_tree().quit()
