extends SettingWidget

@onready var line_edit: LineEdit = $LineEdit


func _widget_setup() -> Error:
	if default_value and default_value is String: line_edit.text = default_value
	if modular_setting.setting_values.size() > 0 and modular_setting.setting_values.get(0) is String: line_edit.text = modular_setting.setting_values.get(0)
	if widget_params.has("text"): line_edit.text = widget_params.get("text")
	if widget_params.has("placeholder_text"): line_edit.placeholder_text = widget_params.get("placeholder_text")
	if widget_params.has("alignment"): line_edit.alignment = widget_params.get("alignment")
	if widget_params.has("max_length"): line_edit.max_length = widget_params.get("max_length")
	if widget_params.has("editable"): line_edit.editable = widget_params.get("editable")
	return OK


func _on_line_edit_text_changed(new_text: String) -> void:
	update_setting_value(new_text)


func _update_setting_value_from_external(new_value:Variant) -> void:
	if new_value is String: 
		line_edit.text = new_value
