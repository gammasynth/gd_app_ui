extends SettingWidget

@onready var check_box: CheckBox = $CheckBox


func _widget_setup() -> Error:
	setup_button(check_box)
	return OK


func _on_check_box_button_down() -> void:
	await get_tree().create_timer(0.01).timeout
	update_setting_value(check_box.button_pressed)
