extends Pickable
class_name Key


func _ready() -> void:
    super._ready()

    var info := DataBase.get_item_info(id)
    _label.text = info.name
