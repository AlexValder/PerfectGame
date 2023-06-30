extends Node3D
class_name Door

@export var house_path: NodePath
## Leave empty if doesn't require a key
@export var key_name: String

@onready var _anim := $anim_player as AnimationPlayer
@onready var _timer := $timer as Timer
var _house: House
var _opened := false
var _requires_key := false


func _ready() -> void:
    var house := get_node(house_path)
    assert(house is House)
    _house = house

    _requires_key = !key_name.is_empty()


func open(player: Player) -> void:
    if _opened:
        return

    if _requires_key && !_can_open(player):
        return

    _opened = true

    if _house.is_player_inside():
        _anim.play("door/open_inside")
    else:
        _anim.play("door/open_outside")

    if _anim.animation_finished.is_connected(_start_timer):
        _anim.animation_finished.disconnect(_start_timer)
    _anim.animation_finished.connect(_start_timer.unbind(1), CONNECT_ONE_SHOT)


func close() -> void:
    var plane := $frame/door2 as Node3D
    var plane_col := $frame/door2/anim_body as AnimatableBody3D
    var tween := create_tween()
    tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
    tween.tween_property(plane, "rotation:y", 0, 3.0)
    tween.parallel().tween_property(plane_col, "rotation:y", 0, 3.0)
    tween.tween_callback(func(): _opened = false)
    tween.play()


func _can_open(player: Player) -> bool:
    if !player.has_item(key_name):
        return false

    player.remove_item(key_name)
    _requires_key = false
    return true


func _start_timer() -> void:
    _timer.start()


func _on_timer_timeout() -> void:
    close()
