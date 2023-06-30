extends PlayerState


func physics_process(delta: float) -> void:
    if player.is_on_floor():
        state_change.emit(self.name, "idle")

    player.velocity.y -= Player.GRAVITY * delta
    player.move_and_slide()
