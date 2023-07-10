extends Area3D
class_name Pickable

@export_range(0.01, 10.0) var speed := 2.5
@export var title := ""
@export var id := ""

@onready var label_show := $label_show as Area3D
@onready var _mesh := $mesh as Node3D
@onready var _label := $label_show/label as Label3D


func body_fits(body: Node3D) -> bool:
    return body is Player


func on_entered(player: Player) -> void:
    player.inventory.add_item(id)


func on_exited(_player: Player) -> void:
    pass


func should_destroy(_player: Player) -> bool:
    return true


func start_destroy() -> void:
    var timer := get_tree().create_timer(2.0)
    var tween := create_tween()
    tween.tween_property(_label, "modulate:a", 0, 0.5)
    tween.play()

    _mesh.visible = false
    body_entered.disconnect(_on_body_entered)
    body_exited.disconnect(_on_body_exited)
    label_show.body_entered.disconnect(_on_label_area_entered)
    label_show.body_exited.disconnect(_on_label_area_exited)
    timer.timeout.connect(queue_free, CONNECT_ONE_SHOT)


func start_reject() -> void:
    pass


func _ready() -> void:
    _label.text = title
    _label.modulate.a = 0

    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
    label_show.body_entered.connect(_on_label_area_entered)
    label_show.body_exited.connect(_on_label_area_exited)


func _process(delta: float) -> void:
    _mesh.rotate_y(speed * delta)


func _on_body_entered(body: Node3D) -> void:
    if !body_fits(body):
        return

    on_entered(body)
    if should_destroy(body):
        start_destroy()
    else:
        start_reject()


func _on_body_exited(body: Node3D) -> void:
    if !body_fits(body):
        return

    on_exited(body)


func _on_label_area_entered(_body: Node3D) -> void:
    _label.modulate.a = 1


func _on_label_area_exited(_body: Node3D) -> void:
    var tween := create_tween()
    tween.tween_property(_label, "modulate:a", 0, 0.5)
    tween.play()
