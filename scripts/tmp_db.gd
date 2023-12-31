extends Node
class_name DataBase

const DB := {
    "items": {
        "knife_normal": {
            "name": "Knife"
        },
        "key_test": {
            "name": "Storage Key",
        },
        "key_test_2": {
            "name": "Rusty Key",
        },
        "key_test_3": {
            "name": "Broken Key",
        },
        "key_test_4": {
            "name": "Useless Key",
        },
        "key_test_5": {
            "name": "Key1",
        },
        "key_test_6": {
            "name": "Key2",
        },
    },
}


static func get_item_info(id: String) -> Dictionary:
    return DB.items.get(id, {})
