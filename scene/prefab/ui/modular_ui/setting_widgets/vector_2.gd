extends SettingWidget

@onready var spin_box_x: SpinBox = $hbox/SpinBoxX
@onready var spin_box_y: SpinBox = $hbox/SpinBoxY


func _widget_setup() -> Error:
	setup_spin_box_widget(spin_box_x)
	setup_spin_box_widget(spin_box_y)
	return await Cast.wait()



func _on_spin_box_x_value_changed(value: float) -> void:
	var vec :Vector2 = Vector2(spin_box_x.value, spin_box_y.value)
	
	modular_setting.setting_values[0] = (vec)
	
	setting_change_function.call(vec)
	
	modular_setting.modular_settings.settings.save_settings()


func _on_spin_box_y_value_changed(value: float) -> void:
	var vec :Vector2 = Vector2(spin_box_x.value, spin_box_y.value)
	
	modular_setting.setting_values[0] = (vec)
	
	setting_change_function.call(vec)
	
	modular_setting.modular_settings.settings.save_settings()
