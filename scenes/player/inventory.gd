extends CanvasLayer
class_name Inventory

const ALPHA_3 := 0.50
const ALPHA_2 := 0.75
const ALPHA_1 := 1.00

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

    _items[0].visible = size > 3
    _items[0].text = _get_name(_active_item - 2)

    _items[1].visible = size > 4
    _items[1].text = _get_name(_active_item - 1)

    _items[2].visible = true
    _items[2].text = _get_name(_active_item)

    _items[3].visible = size > 1
    _items[3].text = _get_name(_active_item + 1)

    _items[4].visible = size > 2
    _items[4].text = _get_name(_active_item + 2)


func _get_name(index: int) -> String:
    index = wrapi(index, 0, _inv.size())

    if index == 0:
        return "(none)"

    var info := DataBase.get_item_info(_inv[index])
    return info.name
