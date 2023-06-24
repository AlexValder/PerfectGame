extends Area3D
class_name Pickable

@export_range(0.01, 10.0) var speed := 2.5
@export var title := ""
@export var id := "knife_normal"

@onready var label_show := $label_show as Area3D
@onready var _mesh := $mesh as Node3D
@onready var _label := $label_show/label as Label3D


func on_entered(_body: Node3D) -> void:
    pass


func on_exited(_body: Node3D) -> void:
    pass


func should_destroy(_body: Node3D) -> bool:
    return false


func start_destroy() -> void:
    pass


func start_reject() -> void:
    pass


func _ready() -> void:
    _label.text = title
    _label.visible = false


func _process(delta: float) -> void:
    _mesh.rotate_y(speed * delta)


func _on_body_entered(body: Node3D) -> void:
    on_entered(body)
    if should_destroy(body):
        start_destroy()
    else:
        start_reject()


func _on_body_exited(body: Node3D) -> void:
    on_exited(body)


func _on_label_area_entered(_body: Node3D) -> void:
    _label.visible = true


func _on_label_area_exited(_body: Node3D) -> void:
    _label.visible = false
