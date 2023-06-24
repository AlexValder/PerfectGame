extends Node

const LEVELS := {
    "main_menu": "res://scenes/main_menu.tscn",
    "test_scene": "res://scenes/levels/test_scene.tscn",
}


func change_scene(level: String) -> void:
    if level in LEVELS.keys():
        if level == "main_menu":
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        else:
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

        get_tree().paused = false
        get_tree().change_scene_to_file(LEVELS[level])
    else:
        push_error("Unknown level: %s" % level)


func load_test_level() -> void:
    change_scene("test_scene")


func quit_to_menu() -> void:
    change_scene("main_menu")
