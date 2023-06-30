extends PlayerState


func on_enter() -> void:
    player.velocity = Vector3.ZERO


func physics_process(_delta: float) -> void:
    if !player.is_on_floor():
        state_change.emit(self.name, "fall")

    try_start_movement("left")
    try_start_movement("right")
    try_start_movement("forward")
    try_start_movement("backwards")

    player.move_and_slide()


func try_start_movement(action: String) -> void:
    if Input.is_action_pressed(action):
        state_change.emit(self.name, "move")
