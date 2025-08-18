extends SettingWidget

@onready var color_picker_button: ColorPickerButton = $CenterContainer/ColorPickerButton

func _widget_setup() -> Error:
	setup_button(color_picker_button)
	if modular_setting.setting_values.size() > 0:
		if modular_setting.setting_values.get(0) is Color: color_picker_button.color = modular_setting.setting_values.get(0)
	if widget_params.has("color"): color_picker_button.color = widget_params.get("color")
	if widget_params.has("edit_alpha"): color_picker_button.edit_alpha = widget_params.get("edit_alpha")
	return OK


func _on_color_picker_button_color_changed(color: Color) -> void:
	update_setting_value(color)

func _update_setting_value_from_external(new_value:Variant) -> void:
	if new_value is Color: color_picker_button.color = new_value
