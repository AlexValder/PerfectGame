extends Node3D
class_name Door

@export var house_path: NodePath
## Leave empty if doesn't require a key
@export var key_id: String

@onready var _anim := $anim_player as AnimationPlayer
@onready var _label := $message as Label3D
@onready var _label_timer := $message/message_timer as Timer
@onready var _timer := $timer as Timer
var _key_name := ""
var _house: House
var _opened := false
var _requires_key := false


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


func _ready() -> void:
    var house := get_node(house_path)
    assert(house is House)
    _house = house

    _requires_key = !key_id.is_empty()
    if _requires_key:
        _key_name = DataBase.get_item_info(key_id).name

    _label.modulate.a = 0
    _label.outline_modulate.a = 0


func _can_open(player: Player) -> bool:
    if player.inventory.get_active_item() != key_id:
        _spawn_label("Required: %s" % _key_name, Color.RED)
        return false

    _spawn_label("Unlocked with: %s" % _key_name, Color.YELLOW)
    player.inventory.remove_item(key_id)
    _requires_key = false
    return true


func _start_timer() -> void:
    _timer.start()


func _on_timer_timeout() -> void:
    close()


func _spawn_label(text: String, color: Color) -> void:
    if _label_timer.time_left > 0:
        _label_timer.stop()

    _label.text = text
    _label.modulate = color
    _label.outline_modulate.a = 1
    _label_timer.start()


func _on_message_timer_timeout() -> void:
    var tween := create_tween()
    tween.tween_property(_label, "modulate:a", 0, 0.5)
    tween.parallel().tween_property(_label, "outline_modulate:a", 0, 0.5)
    tween.play()
