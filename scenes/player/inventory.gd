extends CanvasLayer
class_name Inventory

@onready var _items := [
    $hbox/item_0 as Label,
    $hbox/item_1 as Label,
    $hbox/item_2 as Label,
    $hbox/item_3 as Label,
    $hbox/item_4 as Label,
] as Array[Label]

var _inv := ["(none)"] as Array[String]
var _active_item := 0


func next_item() -> void:
    if _inv.is_empty():
        return

    _active_item += 1
    if _active_item > _inv.size() - 1:
        _active_item = 0
    _update_active_item()


func prev_item() -> void:
    if _inv.is_empty():
        return

    _active_item -= 1
    if _active_item < 0:
        _active_item = _inv.size() - 1
    _update_active_item()


func add_item(id: String) -> void:
    if !_inv.has(id):
        _inv.push_back(id)
        _update_active_item()


func get_active_item() -> String:
    if _active_item <= 0:
        return ""
    return _inv[_active_item]


func has_item(id: String) -> bool:
    return _inv.has(id)


func remove_item(id: String) -> void:
    var index := _inv.find(id)
    if index <= 0:
        return

    _inv.remove_at(index)

    if _active_item == index:
        _active_item = 0
        _update_active_item()
    elif _active_item > index:
        _active_item -= 1
        _update_active_item()


func _ready() -> void:
    # todo: retrieve
    _update_active_item()


func _update_active_item() -> void:
    var size := _inv.size()
    const i_size := 5

    for i in i_size:
        _items[i].visible = size > wrapi(i + 3, 0, 5)
        _items[i].text = _get_name(_active_item + i - 2)


func _get_name(index: int) -> String:
    index = wrapi(index, 0, _inv.size())

    if index == 0:
        return "(none)"

    var info := DataBase.get_item_info(_inv[index])
    return info.name
