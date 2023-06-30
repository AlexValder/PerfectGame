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
