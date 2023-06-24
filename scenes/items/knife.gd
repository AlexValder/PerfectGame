extends Pickable


func on_entered(body: Node3D) -> void:
    if body is Player:
        var p := body as Player
        p.add_item(self.id)


func should_destroy(body: Node3D) -> bool:
    return body is Player


func start_destroy() -> void:
    var timer := get_tree().create_timer(2.0)
    _mesh.visible = false
    body_entered.disconnect(_on_body_entered)
    body_exited.disconnect(_on_body_exited)
    label_show.body_entered.disconnect(_on_label_area_entered)
    label_show.body_exited.disconnect(_on_label_area_exited)
    timer.timeout.connect(queue_free, CONNECT_ONE_SHOT)
