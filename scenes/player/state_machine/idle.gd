extends PlayerState


func on_enter() -> void:
    player.velocity = Vector3.ZERO
    player.camera.is_fpv = false


func physics_process(delta: float) -> void:
    if !player.is_on_floor():
        state_change.emit(self.name, "fall")

    _rotate_camera(delta)

    try_start_movement("left")
    try_start_movement("right")
    try_start_movement("forward")
    try_start_movement("backwards")

    player.move_and_slide()


func unhandled_input(event: InputEvent) -> void:
    super.unhandled_input(event)
    if event.is_action_pressed("fpv"):
        state_change.emit(self.name, "fpv_idle")


func try_start_movement(action: String) -> void:
    if Input.is_action_pressed(action):
        state_change.emit(self.name, "move")
