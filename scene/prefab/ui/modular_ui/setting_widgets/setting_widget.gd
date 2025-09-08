extends MarginContainer

class_name SettingWidget

var setting_name:String = "":
	get:
		if modular_setting: return modular_setting.setting_name
		return setting_name

var modular_setting: ModularSettingOption = null

var widget_index: int = -1
var setting_change_function: Callable
var default_value: Variant = null
var widget_params: Dictionary = {}

var updating_from_external:bool = false

func widget_setup(_widget_index: int, _setting_change_function: Callable, _default_value: Variant, _widget_params: Dictionary) -> Error:
	widget_index = _widget_index
	setting_change_function = _setting_change_function
	default_value = _default_value
	widget_params = _widget_params
	if default_value is Callable: default_value = default_value.call()
	
	return await _widget_setup()

func _widget_setup() -> Error:
	return OK


func setup_spin_box_widget(this_spin_box:SpinBox):
	
	if modular_setting.setting_values.size() > 0:
		var v = modular_setting.setting_values.get(0)
		if v is Vector2 or v is Vector2i or v is Vector3 or v is Vector3i:
			if widget_index == 0:
				this_spin_box.value = v.x
			if widget_index == 1:
				this_spin_box.value = v.y
			if widget_index == 2:
				if v is Vector3 or v is Vector3i: this_spin_box.value = v.z
	
	if modular_setting.setting_values.size() - 1 <= widget_index: 
		var num = modular_setting.setting_values[widget_index]
		if num is float or num is int:
			this_spin_box.value = num
	
	
	if widget_params.has("prefix"): this_spin_box.prefix = widget_params.get("prefix")
	if widget_params.has("suffix"): this_spin_box.suffix = widget_params.get("suffix")
	
	if widget_params.has("editable"): this_spin_box.editable = widget_params.get("editable")
	
	if widget_params.has("step"): this_spin_box.step = widget_params.get("step")
	
	if widget_params.has("min_value"): this_spin_box.min_value = widget_params.get("min_value")
	if widget_params.has("max_value"): this_spin_box.max_value = widget_params.get("max_value")
	
	if widget_params.has("allow_greater"): this_spin_box.allow_greater = widget_params.get("allow_greater")
	if widget_params.has("allow_lesser"): this_spin_box.allow_lesser = widget_params.get("allow_lesser")
	
	if widget_params.has("value"): this_spin_box.value = widget_params.get("value")
	
	if widget_params.has("rounded"): this_spin_box.rounded = widget_params.get("rounded")
	



func setup_button(this_button:Button):
	var setting_value: Variant = null
	if modular_setting.setting_values.size() - 1 <= widget_index: setting_value = modular_setting.setting_values[widget_index]
	
	if modular_setting.setting_values.size() > 0 and modular_setting.setting_values[0] is String: this_button.text = modular_setting.setting_values[0]
	
	if setting_value is bool:
		this_button.button_pressed = setting_value
	
	if setting_value is Color:
		if this_button is ColorPickerButton:
			this_button.color = setting_value
	
	if widget_params.has("text"): this_button.text = widget_params.get("text")
	
	if widget_params.has("icon"): this_button.icon = widget_params.get("icon")
	
	if widget_params.has("flat"): this_button.flat = widget_params.get("flat")
	
	if widget_params.has("toggle_mode"): this_button.toggle_mode = widget_params.get("toggle_mode")
	
	if widget_params.has("button_mask"): this_button.button_mask = widget_params.get("button_mask")
	
	if widget_params.has("disabled"): this_button.disabled = widget_params.get("disabled")
	
	var disabled_callable = null
	if widget_params.has("disabled_callable"): 
		var f = widget_params.get("disabled_callable")
		if f is Callable:
			var v = f.call()
			if v is bool: 
				disabled_callable = f
				this_button.disabled = v
	
	if widget_params.has("connect_disable_signal"):
		var signal_disable = widget_params.get("connect_disable_signal")
		if signal_disable is Signal:
			signal_disable.connect(signal_to_toggle_button_disabled.bind(this_button))



func signal_to_toggle_button_disabled(toggle_disabled:bool, button:Button) -> void: button.disabled = toggle_disabled

func update_setting_value_from_external(new_value:Variant) -> void:
	updating_from_external = true
	_update_setting_value_from_external(new_value)
	updating_from_external = false

func _update_setting_value_from_external(new_value:Variant) -> void:
	pass



func update_setting_value(new_value:Variant) -> void:
	if updating_from_external: return
	if not is_node_ready(): await ready
	if setting_change_function.is_null(): 
		printerr("NULL SETTING CALLABLE!")
		return
	
	modular_setting.setting_values[widget_index] = new_value
	
	if modular_setting.emit_name_with_value_change:
		setting_change_function.call(new_value, modular_setting.setting_name)
	else:
		setting_change_function.call(new_value)
	
	if modular_setting.modular_settings: modular_setting.modular_settings.settings.save_settings()
