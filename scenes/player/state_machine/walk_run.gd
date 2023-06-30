extends PlayerState


func physics_process(delta: float) -> void:
    if !player.is_on_floor():
        state_change.emit(self.name, "fall")

    var velocity := player.velocity

    var vel :=\
        Input.get_vector("right", "left", "backwards", "forward")
    var norm_vel := vel.normalized()
    velocity = Vector3(-norm_vel.x, 0, -norm_vel.y) * delta * _get_speed(vel)
    velocity = velocity.rotated(Vector3.UP, player.camera.get_angle())

    if velocity.length() > 0:
        var look_dir := -Vector2(velocity.z, velocity.x)
        player.mesh.rotation.y = lerp_angle(
            player.mesh.rotation.y, look_dir.angle(), delta * Player.ANGLE_ACC)
    else:
        state_change.emit(self.name, "idle")

    player.velocity = velocity
    player.move_and_slide()


func _get_speed(vel: Vector2) -> float:
    if Input.is_action_pressed("crouch") ||\
        (vel.length() < Player.RUN_WALK_THRESHOLD):
        return Player.WALK_SPEED
    return Player.SPEED
