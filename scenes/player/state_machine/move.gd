extends PlayerState


func on_enter() -> void:
    player.camera.is_fpv = false


func physics_process(delta: float) -> void:
    if !player.is_on_floor():
        state_change.emit(self.name, "fall")

    _rotate_camera(delta)

    var velocity := player.velocity

    var vel :=\
        Input.get_vector("right", "left", "backwards", "forward")
    var norm_vel := vel.normalized()
    velocity = Vector3(-norm_vel.x, 0, -norm_vel.y) * delta * _get_speed(vel)
    velocity = velocity.rotated(Vector3.UP, player.camera.get_angle())

    if velocity.length() > 0:
        var look_dir := -Vector2(velocity.z, velocity.x)
        player.rotate_player_at_angle(look_dir.angle(), delta)
    else:
        state_change.emit(self.name, "idle")

    player.velocity = velocity
    player.move_and_slide()


func unhandled_input(event: InputEvent) -> void:
    super.unhandled_input(event)
    if event.is_action_pressed("fpv"):
        state_change.emit(self.name, "fpv_idle")


func _get_speed(vel: Vector2) -> float:
    if Input.is_action_pressed("crouch") ||\
        (vel.length() < Player.RUN_WALK_THRESHOLD):
        return Player.WALK_SPEED
    return Player.SPEED
