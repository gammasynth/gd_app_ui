extends SettingWidget

@onready var line_edit: LineEdit = $LineEdit


func _widget_setup() -> Error:
	if widget_params.has("text"): line_edit.text = widget_params.get("text")
	if widget_params.has("placeholder_text"): line_edit.placeholder_text = widget_params.get("placeholder_text")
	if widget_params.has("alignment"): line_edit.alignment = widget_params.get("alignment")
	if widget_params.has("max_length"): line_edit.max_length = widget_params.get("max_length")
	if widget_params.has("editable"): line_edit.editable = widget_params.get("editable")
	return OK


func _on_line_edit_text_changed(new_text: String) -> void:
	update_setting_value(new_text)
