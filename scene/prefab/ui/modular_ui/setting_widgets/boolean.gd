extends SettingWidget

@onready var check_box: CheckBox = $CheckBox


func _widget_setup() -> Error:
	setup_button(check_box)
	return OK


func _update_setting_value_from_external(new_value:Variant) -> void:
	if new_value is bool: check_box.button_pressed = new_value


func _on_check_box_toggled(toggled_on: bool) -> void:
	update_setting_value(toggled_on)
