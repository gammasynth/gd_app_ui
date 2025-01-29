extends SettingWidget

@onready var color_picker_button: ColorPickerButton = $ColorPickerButton

func _widget_setup() -> Error:
	setup_button(color_picker_button)
	if widget_params.has("color"): color_picker_button.color = widget_params.get("color")
	if widget_params.has("edit_alpha"): color_picker_button.edit_alpha = widget_params.get("edit_alpha")
	return await Cast.wait()


func _on_color_picker_button_color_changed(color: Color) -> void:
	update_setting_value(color)
