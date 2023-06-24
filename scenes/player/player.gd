extends CharacterBody3D
class_name Player

@onready var _camera := $camera as PlayerCamera
@onready var _mesh := $mesh as MeshInstance3D

var _inv := []

const GRAVITY := 98.0
const SPEED := 250.0
const CROUCH_SPEED := 120.0
const ANGLE_ACC := 10.0


func add_item(id: String) -> void:
    _inv.push_back(id)


func _physics_process(delta: float) -> void:
    if is_on_floor():
        var vel := Input.get_vector("right", "left", "backwards", "forward")
        velocity = Vector3(-vel.x, 0, -vel.y) * delta * _get_speed()
        velocity = velocity.rotated(Vector3.UP, _camera.get_angle())

        if velocity.length() > 0:
            var look_dir := -Vector2(velocity.z, velocity.x)
            _mesh.rotation.y = lerp_angle(
                _mesh.rotation.y, look_dir.angle(), delta * ANGLE_ACC)

    velocity.y -= GRAVITY * delta

    move_and_slide()


func _get_speed() -> float:
    if Input.is_action_pressed("crouch"):
        return CROUCH_SPEED
    return SPEED
