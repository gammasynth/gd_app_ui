extends MarginContainer

class_name ModularSettingOption


@onready var hbox = $hbox
@onready var center_box: CenterContainer = $hbox/center_box
@onready var labels_hbox: HBoxContainer = $hbox/center_box/labels_hbox
@onready var setting_label: RichTextLabel = $hbox/center_box/labels_hbox/setting_label
@onready var colon_label: RichTextLabel = $hbox/center_box/labels_hbox/colon_label

@onready var widgets_hbox: HBoxContainer = $hbox/widgets_hbox

var modular_settings: ModularSettingsMenu = null

var setting_name: String = ""
var setting_types: Array = []
var setting_change_function: Callable
var setting_values: Array = []
var widget_params: Array =[]
var emit_name_with_value_change:bool = false

var widgets: Array = []

var is_new:bool = true

static func get_setting_ui(setting_dictionary:Dictionary) -> ModularSettingOption:
	#var new_setting: Dictionary = {
		#"SETTING_NAME" : setting_name,
		#"SETTING_TYPES" : setting_types,
		#"SETTING_CHANGE_FUNCTION" : setting_change_function,
		#"SETTING_VALUES" : setting_values,
		#"WIDGET_PARAMS" : widget_params
	#}
	
	var new_setting: ModularSettingOption
	var use_registry: bool = false
	if App.app.registry_system: use_registry = true
	
	if use_registry: new_setting = Registry.pull("modular_ui", "modular_setting_option.tscn").instantiate()
	else: new_setting = load("res://lib/gd_app_ui/scene/prefab/ui/modular_ui/settings_ui/modular_setting_option.tscn").instantiate()
	
	new_setting.setting_name = setting_dictionary.get("SETTING_NAME")
	new_setting.setting_types = setting_dictionary.get("SETTING_TYPES")
	new_setting.setting_change_function = setting_dictionary.get("SETTING_CHANGE_FUNCTION")
	new_setting.setting_values = setting_dictionary.get("SETTING_VALUES")
	new_setting.widget_params = setting_dictionary.get("WIDGET_PARAMS")
	new_setting.emit_name_with_value_change = setting_dictionary.get("emit_name_with_value_change")
	return new_setting

func setup_from_settings(setting_dictionary:Dictionary):
	setting_name = setting_dictionary.get("SETTING_NAME")
	setting_types = setting_dictionary.get("SETTING_TYPES")
	setting_change_function = setting_dictionary.get("SETTING_CHANGE_FUNCTION")
	setting_values = setting_dictionary.get("SETTING_VALUES")
	widget_params = setting_dictionary.get("WIDGET_PARAMS")
	emit_name_with_value_change = setting_dictionary.get("emit_name_with_value_change")

func setting_value_was_set(for_setting_name:String, new_values:Array) -> void:
	var value:Variant = new_values
	if setting_name == for_setting_name: 
		if new_values.size() == 1: value = new_values.get(0)
		update_setting_value_from_external(value)

func update_setting_value_from_external(new_value:Variant) -> void:
	_update_setting_value_from_external(new_value)

func _update_setting_value_from_external(new_value:Variant) -> void:
	for widget in widgets:
		widget.update_setting_value_from_external(new_value)

func _ready() -> void:
	
	if not is_new:
		return
	
	is_new = false
	#if setting_types.is_empty(): queue_free(); return
	
	setting_label.text = setting_name
	
	#enum SETTING_TYPES {empty, number, vector2, vector3, boolean, color, string}
	var widget_registry: Registry = Registry.get_registry("setting_widgets")
	var widget_index: int = 0
	
	for widget_name:String in setting_types: 
		
		var widget_packed_scene_name: String = str(widget_name + ".tscn")
		
		#if not widget_registry.db.has(widget_packed_scene_name):
			#warn(str("registry does not have SettingWidget scene at key: " + widget_name))
			#continue
		
		var widget_packed_scene: PackedScene = widget_registry.grab(widget_packed_scene_name)
		#if not widget_packed_scene: warn("widget scene instance is null!"); continue
		
		var widget: SettingWidget = widget_packed_scene.instantiate()
		
		await Make.child(widget, widgets_hbox)
		widgets.append(widget)
		
		var value: Variant = null; if widget_params.size() > 0 and setting_values.size() - 1 <= widget_index: value = setting_values[widget_index]
		var params: Dictionary = {}; if widget_params.size() > 0 and widget_params.size() - 1 <= widget_index: params = widget_params[widget_index]
		
		if value == null and setting_values.size() > 0: value = setting_values.get(0)
		
		widget.modular_setting = self
		var _err: Error = await widget.widget_setup(widget_index, setting_change_function, value, params)
		#warn("widget setup", err)
		widget_index += 1
	
	
