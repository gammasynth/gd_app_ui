extends SettingWidget

@onready var button: Button = $Button


func _widget_setup() -> Error:
	setup_button(button)
	return OK


func _on_button_button_down() -> void:
	await get_tree().create_timer(0.01).timeout
	update_setting_value(true)
