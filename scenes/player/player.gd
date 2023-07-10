extends CharacterBody3D
class_name Player

signal active_item_change(id, item)

@onready var camera := $camera as PlayerCamera
@onready var hand := $mesh/hand as RayCast3D
@onready var inventory := $inventory as Inventory
@onready var reach := $mesh/grabbable as Area3D
@onready var _mesh := $mesh as MeshInstance3D
@onready var _shape := $shape as CollisionShape3D

const SPEED := 250.0
const WALK_SPEED := 120.0
const RUN_WALK_THRESHOLD := 0.5

const GRAVITY := 98.0 / 2
const ANGLE_ACC := 10.0


func rotate_player(angle: float, delta: float) -> void:
    _mesh.rotation.y = lerp_angle(
        _mesh.rotation.y, angle, delta * Player.ANGLE_ACC)
    _shape.rotation.y = lerp_angle(
        _shape.rotation.y, angle, delta * Player.ANGLE_ACC)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("action"):
        _try_action()
        get_tree().root.set_input_as_handled()
    elif event.is_action_pressed("next_item"):
        inventory.next_item()
        get_tree().root.set_input_as_handled()
    elif event.is_action_pressed("prev_item"):
        inventory.prev_item()
        get_tree().root.set_input_as_handled()


func _try_action() -> void:
    if _use_hand():
        return

    if _try_grab():
        return


func _use_hand() -> bool:
    if !hand.is_colliding():
        return false

    var collider := hand.get_collider()

    var door := collider.owner as Door
    if door != null:
        door.open(self)
        return true
    return false


func _try_grab() -> bool:
    if !reach.has_overlapping_areas():
        return false

    var areas := reach.get_overlapping_areas()
    var area := areas.front() as Node

    if area is Pickable:
        var pick := area as Pickable
        pick._on_body_entered(self)
        return true

    return false
