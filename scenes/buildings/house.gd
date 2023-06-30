extends Node3D
class_name House

var _inside := false


func is_player_inside() -> bool:
    return _inside


func _on_player_entered(player: Player) -> void:
    if player == null:
        return

    _inside = true


func _on_player_exited(player: Player) -> void:
    if player == null:
        return

    _inside = false
