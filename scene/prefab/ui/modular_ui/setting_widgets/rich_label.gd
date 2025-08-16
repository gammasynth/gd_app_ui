extends SettingWidget

@onready var rich_text_label: RichTextLabel = $RichTextLabel

func _widget_setup() -> Error:
	if default_value and default_value is String: rich_text_label.text = default_value
	if modular_setting.setting_values.size() > 0 and modular_setting.setting_values.get(0) is String: rich_text_label.text = modular_setting.setting_values.get(0)
	if widget_params.has("text"): rich_text_label.text = widget_params.get("text")
	return OK

#update_setting_value(new_text)
