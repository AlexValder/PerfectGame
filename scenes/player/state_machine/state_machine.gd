extends Node3D
class_name StateMachine

@onready var initial_state := $idle as PlayerState
@onready var current_state := initial_state
@onready var _label := $label as Label


func _ready() -> void:
    self.top_level = true

    var states := get_children()
    for state in states:
        if state is PlayerState:
            state.state_change.connect(_on_state_change)

    initial_state.on_enter()
    _label.text = "STATE: %s" % initial_state.name


func _physics_process(delta: float) -> void:
    current_state.physics_process(delta)


func _on_state_change(prev: String, next: String) -> void:
    assert(has_node(prev))
    assert(has_node(next))

    var prev_state := get_node(prev) as PlayerState
    var next_state := get_node(next) as PlayerState

    if !prev_state.can_leave() || !next_state.can_enter():
        return

    prev_state.on_leave()
    current_state = next_state
    current_state.on_enter()

    _label.text = "STATE: %s" % current_state.name
