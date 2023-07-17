extends PlayerState


func on_enter() -> void:
    player.camera.is_fpv = false


func physics_process(delta: float) -> void:
    if player.is_on_floor():
        state_change.emit(self.name, "idle")

    _rotate_camera(delta)

    player.velocity.y -= Player.GRAVITY * delta
    player.move_and_slide()
