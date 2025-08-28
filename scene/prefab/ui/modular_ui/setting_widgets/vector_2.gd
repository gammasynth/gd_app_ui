extends SettingWidget

@onready var spin_box_x: SpinBox = $hbox/SpinBoxX
@onready var spin_box_y: SpinBox = $hbox/SpinBoxY



func _widget_setup() -> Error:
	
	setup_spin_box_widget(spin_box_x)
	setup_spin_box_widget(spin_box_y)
	return OK



func _on_spin_box_x_value_changed(value: float) -> void:
	if updating_from_external: return
	var vec :Vector2 = Vector2(spin_box_x.value, spin_box_y.value)
	
	modular_setting.setting_values[0] = (vec)
	
	if modular_setting.emit_name_with_value_change:
		setting_change_function.call(vec, modular_setting.setting_name)
	else:
		setting_change_function.call(vec)
	
	if modular_setting.modular_settings: modular_setting.modular_settings.settings.save_settings()


func _on_spin_box_y_value_changed(value: float) -> void:
	if updating_from_external: return
	var vec :Vector2 = Vector2(spin_box_x.value, spin_box_y.value)
	
	modular_setting.setting_values[0] = (vec)
	
	if modular_setting.emit_name_with_value_change:
		setting_change_function.call(vec, modular_setting.setting_name)
	else:
		setting_change_function.call(vec)
	
	if modular_setting.modular_settings: modular_setting.modular_settings.settings.save_settings()

func _update_setting_value_from_external(new_value:Variant) -> void:
	if new_value is Vector2 or new_value is Vector2i: 
		spin_box_x.value = new_value.x
		spin_box_y.value = new_value.y
