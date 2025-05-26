extends DatabaseMarginContainer

class_name ModularSettingOption


@onready var hbox: HBoxContainer = $hbox
@onready var center_box: CenterContainer = $hbox/center_box
@onready var labels_hbox: HBoxContainer = $hbox/center_box/labels_hbox
@onready var setting_label: RichTextLabel = $hbox/center_box/labels_hbox/setting_label
@onready var colon_label: RichTextLabel = $hbox/center_box/labels_hbox/colon_label

@onready var widgets_hbox: HBoxContainer = $hbox/widgets_hbox

var modular_settings: ModularSettingsMenu = null

var setting_name: String = ""
var setting_types: Array[String] = []
var setting_change_function: Callable
var setting_values: Array[Variant] = []
var widget_params: Array[Dictionary] =[]


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
	else: new_setting = load("res://core/scene/prefab/ui/modular_ui/modular_setting_option.tscn").instantiate()
	
	new_setting.setting_name = setting_dictionary.get("SETTING_NAME")
	new_setting.setting_types = setting_dictionary.get("SETTING_TYPES")
	new_setting.setting_change_function = setting_dictionary.get("SETTING_CHANGE_FUNCTION")
	new_setting.setting_values = setting_dictionary.get("SETTING_VALUES")
	new_setting.widget_params = setting_dictionary.get("WIDGET_PARAMS")
	
	return new_setting


func _ready() -> void:
	
	#if setting_types.is_empty(): queue_free(); return
	
	setting_label.text = setting_name
	
	#enum SETTING_TYPES {empty, number, vector2, vector3, boolean, color, string}
	var widget_registry: Registry = Registry.get_registry("setting_widgets")
	var widget_index: int = 0
	
	for widget_name:String in setting_types: 
		
		var widget_packed_scene_name: String = str(widget_name + ".tscn")
		
		if not widget_registry.db.has(widget_packed_scene_name):
			warn(str("registry does not have SettingWidget scene at key: " + widget_name))
			continue
		
		var widget_packed_scene: PackedScene = widget_registry.grab(widget_packed_scene_name)
		if not widget_packed_scene: warn("widget scene instance is null!"); continue
		
		var widget: SettingWidget = widget_packed_scene.instantiate()
		
		await Make.child(widget, widgets_hbox)
		
		var value: Variant = null; if widget_params.size() > 0 and setting_values.size() - 1 <= widget_index: value = setting_values[widget_index]
		var params: Dictionary = {}; if widget_params.size() > 0 and widget_params.size() - 1 <= widget_index: params = widget_params[widget_index]
		
		widget.modular_setting = self
		var err: Error = await widget.widget_setup(widget_index, setting_change_function, value, params)
		warn("widget setup", err)
		widget_index += 1
