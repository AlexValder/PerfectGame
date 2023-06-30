extends CharacterBody3D
class_name Player

@onready var camera := $camera as PlayerCamera
@onready var mesh := $mesh as MeshInstance3D
@onready var hand := $mesh/hand as RayCast3D
@onready var reach := $mesh/grabbable as Area3D

const SPEED := 250.0
const WALK_SPEED := 120.0
const RUN_WALK_THRESHOLD := 0.5

const GRAVITY := 98.0
const ANGLE_ACC := 10.0

var _inv := []


func add_item(id: String) -> void:
    _inv.push_back(id)


func has_item(id: String) -> bool:
    return _inv.has(id)


func remove_item(id: String) -> void:
    var ind := _inv.find(id)
    if ind >= 0:
        _inv.remove_at(ind)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("action"):
        _try_action()


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
