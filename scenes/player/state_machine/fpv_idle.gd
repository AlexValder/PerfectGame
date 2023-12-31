extends PlayerState


func on_enter() -> void:
    player.velocity = Vector3.ZERO
    player.camera.is_fpv = true


func physics_process(delta: float) -> void:
    if !player.is_on_floor():
        state_change.emit(self.name, "fall")

    var input := Input.get_vector(
        "camera_right", "camera_left", "camera_down", "camera_up")
    if !is_zero_approx(input.length()):
        player.camera.rotate_camera_joy(input, delta)
        player.rotate_player()

        var rot := player.camera.get_camera_rotation()
        player.hand.rotation.x = rot.x

    player.move_and_slide()


func unhandled_input(event: InputEvent) -> void:
    super.unhandled_input(event)
    if event.is_action_released("fpv"):
        state_change.emit(self.name, "idle")

    if event is InputEventMouseMotion:
        player.rotate_player()

        var rot := player.camera.get_camera_rotation()
        player.hand.rotation.x = rot.x


func on_leave() -> void:
    player.hand.rotation.x = 0
