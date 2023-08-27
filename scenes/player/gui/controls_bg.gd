extends AcceptDialog

@onready var _scroll := $scroll as ScrollContainer
@onready var _grid := $scroll/vbox/grid as GridContainer

var _label1 := Label.new()
var _label2 := Label.new()


func _init() -> void:
    var action_settings := LabelSettings.new()
    action_settings.font_size = 24
    action_settings.font_color = Color.from_string("#774dff", Color.AQUA)
    action_settings.outline_size = 10
    action_settings.shadow_size = 0

    var input_settings := LabelSettings.new()
    action_settings.font_size = 20
    action_settings.shadow_size = 0

    _label1.label_settings = action_settings
    _label1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _label1.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    _label1.uppercase = true

    _label2.label_settings = input_settings
    _label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    _label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    _label2.uppercase = true


func _ready() -> void:
    visible = false

    var actions := InputMap.get_actions()
    for action in actions:
        if action.begins_with("ui"):
            continue

        _label1.text = action.replace("_", " ")
        _grid.add_child(_label1.duplicate())

        var inputs := InputMap.action_get_events(action)
        _label2.text = _get_pc(inputs)
        _grid.add_child(_label2.duplicate())
        _label2.text = _get_controller(inputs)
        _grid.add_child(_label2.duplicate())


func _process(delta: float) -> void:
    if !visible: return

    var bar := _scroll.get_v_scroll_bar()
    var max_value := bar.max_value

    var value := Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y) * 500
    if !is_zero_approx(value):
        bar.value = clamp(bar.value + value * delta, 0, max_value)


func _get_pc(inputs: Array[InputEvent]) -> String:
    for input in inputs:
        if input is InputEventKey:
            var key := input as InputEventKey
            return key.as_text_physical_keycode()
        elif input is InputEventMouseButton:
            var mouse := input as InputEventMouseButton
            match mouse.button_index:
                MOUSE_BUTTON_LEFT: return "LMB"
                MOUSE_BUTTON_RIGHT: return "RMB"
                MOUSE_BUTTON_MASK_MIDDLE: return "MMB"
                MOUSE_BUTTON_WHEEL_DOWN: return "Wheen Down"
                MOUSE_BUTTON_WHEEL_UP: return "Wheel Up"

    return "-"


func _get_controller(inputs: Array[InputEvent]) -> String:
    for input in inputs:
        if input is InputEventJoypadButton:
            var button := input as InputEventJoypadButton
            match button.button_index:
                JOY_BUTTON_A: return "A"
                JOY_BUTTON_B: return "B"
                JOY_BUTTON_X: return "X"
                JOY_BUTTON_Y: return "Y"
                JOY_BUTTON_DPAD_DOWN: return "Dpad Down"
                JOY_BUTTON_DPAD_UP: return "Dpad Up"
                JOY_BUTTON_DPAD_LEFT: return "Dpad Left"
                JOY_BUTTON_DPAD_RIGHT: return "Dpad Right"
                JOY_BUTTON_LEFT_SHOULDER: return "LB"
                JOY_BUTTON_RIGHT_SHOULDER: return "RB"
                JOY_BUTTON_LEFT_STICK: return "L"
                JOY_BUTTON_RIGHT_STICK: return "R"
                JOY_BUTTON_START: return "Start"
                JOY_BUTTON_GUIDE: return "Home"
                JOY_BUTTON_BACK: return "Back"
        elif input is InputEventJoypadMotion:
            var axis := input as InputEventJoypadMotion
            match axis.axis:
                JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y: return "Left Stick"
                JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y: return "Right Stick"
                JOY_AXIS_TRIGGER_LEFT: return "LT"
                JOY_AXIS_TRIGGER_RIGHT: return "RT"
    return "-"
