extends SettingWidget

@onready var spin_box_x: SpinBox = $hbox/SpinBoxX
@onready var spin_box_y: SpinBox = $hbox/SpinBoxY
@onready var spin_box_z: SpinBox = $hbox/SpinBoxZ


func _widget_setup() -> Error:
	setup_spin_box_widget(spin_box_x)
	setup_spin_box_widget(spin_box_y)
	setup_spin_box_widget(spin_box_z)
	return OK


func _on_spin_box_x_value_changed(value: float) -> void:
	var vec :Vector3 = Vector3(spin_box_x.value, spin_box_y.value, spin_box_z.value)
	
	modular_setting.setting_values[0] = (vec)
	
	if modular_setting.emit_name_with_value_change:
		setting_change_function.call(vec, modular_setting.setting_name)
	else:
		setting_change_function.call(vec)
	
	if modular_setting.modular_settings: modular_setting.modular_settings.settings.save_settings()


func _on_spin_box_y_value_changed(value: float) -> void:
	var vec :Vector3 = Vector3(spin_box_x.value, spin_box_y.value, spin_box_z.value)
	
	modular_setting.setting_values[0] = (vec)
	
	if modular_setting.emit_name_with_value_change:
		setting_change_function.call(vec, modular_setting.setting_name)
	else:
		setting_change_function.call(vec)
	
	if modular_setting.modular_settings: modular_setting.modular_settings.settings.save_settings()


func _on_spin_box_z_value_changed(value: float) -> void:
	var vec :Vector3 = Vector3(spin_box_x.value, spin_box_y.value, spin_box_z.value)
	
	modular_setting.setting_values[0] = (vec)
	
	if modular_setting.emit_name_with_value_change:
		setting_change_function.call(vec, modular_setting.setting_name)
	else:
		setting_change_function.call(vec)
	
	if modular_setting.modular_settings: modular_setting.modular_settings.settings.save_settings()
