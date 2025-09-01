extends RefCounted
## Settings is a Class that can store setting configurations for systems quickly, and also synch them as user files.
## 
## Settings is intended to be used in tandem with ModularSettingsMenu and ModularSettingOption, which are Control UI elements. [br]
## All Settings objects created with Settings.initialize_settings are tracked within the static all_settings Dictionary, if saveable is true.
## [br] [br] [br]
## To create a new Settings: [br] [br]
## 
## var my_settings: Settings = Settings.initialize_settings("my_settings") [br]
## my_settings.prepare_setting("setting1", Settings.SETTING_TYPES.number, func(x): my_number_var = x, my_number_var) [br]
## my_settings.prepare_setting("setting2", Settings.SETTING_TYPES.string, func(s): my_string_var = s, my_string_var) [br]
## my_settings.finish_prepare_settings()

## var my_ui = my_setting.instance_ui()


class_name Settings

const DEFAULT_SETTINGS_FOLDER = "user://settings/"
#enum SETTING_TYPES {empty, number, vector2, vector3, boolean, color, string}

static var all_settings: Dictionary = {}



var settings_file_path: String = ""
var setting_properties : Dictionary = {}
var saveable:bool = false
var emit_name_with_value_change:bool = false

var name:String = "Settings"

func _init(_name:String="settings") -> void: 
	name = _name
	return


#func get_settings_values() -> Dictionary:
	#var settings_values : Dictionary = {
		#
	#}
	#return settings_values

func convert_to_dictionary() -> Dictionary:
	var settings_dictionary: Dictionary = {
		"NAME" : name,
		"FILE_PATH" : settings_file_path,
		"ALL_SETTING_VALUES" : {}
	}
	
	for prop:String in setting_properties:
		var this_setting: Dictionary = setting_properties.get(prop)
		var this_setting_values: Array = this_setting["SETTING_VALUES"]
		
		var stringed_setting_values: Array = []
		for i in this_setting_values.size():
			var this_value: Variant = this_setting_values[i]
			if this_value is Color:
				var new_value: Dictionary = {"COLOR" : {"R" : this_value.r, "G" : this_value.g, "B" : this_value.b, "A": this_value.a} }
				this_value = new_value
			
			stringed_setting_values.append(this_value)
			#if this_value is Dictionary:
				#if this_value.size() == 1 and this_value.has("COLOR")
				#var new_value: Dictionary = {"COLOR" : {"R" : this_value.r, "G" : this_value.g, "B" : this_value.b}}
		this_setting_values = stringed_setting_values
		
		settings_dictionary["ALL_SETTING_VALUES"][prop] = this_setting_values
	
	return settings_dictionary


static func initialize_settings(_settings_name:String, _saveable:bool=false, _settings_file_path:String="user://settings/") -> Settings:
	var settings: Settings = Settings.new(_settings_name)
	settings.saveable = _saveable
	if _saveable:
		var dir: DirAccess = DirAccess.open("user://")
		dir.make_dir_recursive(_settings_file_path)
		dir.make_dir_recursive(DEFAULT_SETTINGS_FOLDER)
		
		var file_path: String = str(_settings_file_path + _settings_name.to_snake_case() + ".json")
		settings.settings_file_path = file_path
		
		if all_settings.has(_settings_name):
			print(str("Settings.initialize_settings | settings name already exists, trying to overwrite? @" + _settings_name))
			
			var old_setting: Settings = all_settings.get(_settings_name)
			if not old_setting:
				print(str("Settings.initialize_settings | allowing overwrite at empty entry? @" + _settings_name))
			else:
				print(str("Settings.initialize_settings | returning existing Settings entry, overwrite refused. @" + _settings_name + ", path@ " + _settings_file_path))
				return old_setting
	return settings



func prepare_setting(setting_name:String, setting_types:Array[String], setting_change_function:Callable, setting_values:Array[Variant], widget_params:Array[Dictionary]=[],emit_name_with_value_change:bool=false) -> void:
	if setting_properties.has(setting_name): 
		print(str("cant prepare setting! already has setting name entry: " + setting_name))
		return
	
	var new_setting: Dictionary = {
		"SETTING_NAME" : setting_name,
		"SETTING_TYPES" : setting_types,
		"SETTING_CHANGE_FUNCTION" : setting_change_function,
		"SETTING_VALUES" : setting_values,
		"WIDGET_PARAMS" : widget_params,
		"emit_name_with_value_change" : emit_name_with_value_change
	}
	
	setting_properties.set(setting_name, new_setting)
	return




func finish_prepare_settings() -> void:
	
	# This Settings Object has been initialized and (hopefully) assigned settings,
	# Check and compare it to any existing file for this Settings Object, if there is one,
	var loaded: bool = load_settings()
	
	if not loaded:
		# Regardless if we have an existing file above or not, we will need to start recording this Settings as a file, now, and whenever changed.
		var err: Error = save_settings()
		print("couldnt save file!", err)
	
	all_settings.erase(name)
	all_settings.get_or_add(name, self)
	
	return



func save_settings() -> Error:
	if not saveable: return OK
	var settings_dict: Dictionary = convert_to_dictionary()
	return File.save_dict_file(settings_dict, settings_file_path)


func load_settings() -> bool:
	if not saveable: return true
	if not FileAccess.file_exists(settings_file_path): return false
	
	# load old existing settings file, if it has the same property and name hash.
	# this way, if a code update changes the structure of a Settings file, the old settings file will be discarded to avoid error.
	var loaded_settings_obj_dict = File.load_dict_file(settings_file_path)
	var loaded_settings_name: String = loaded_settings_obj_dict.get("NAME")
	var loaded_settings_values_dict: Dictionary = loaded_settings_obj_dict.get("ALL_SETTING_VALUES")
	var loaded_property_names: Array = loaded_settings_values_dict.keys()
	
	
	
	var loaded_settings_hash: int = get_settings_hash(loaded_settings_name, loaded_property_names)
	var my_hash: int = get_settings_hash()
	
	if loaded_settings_hash != my_hash: return false
	
	# these files match hashes as the same name and properties lists
	# we can load the values that were saved to this setting file (from last session maybe?) instead of using our Settings Objects default property values.
	
	for prop: String in loaded_settings_values_dict:
		var this_setting: Dictionary = setting_properties.get(prop)
		
		var vals: Array = loaded_settings_values_dict.get(prop)
		
		var new_vals: Array = []
		var setting_callable: Callable = this_setting["SETTING_CHANGE_FUNCTION"]
		for i in vals.size():
			var val: Variant = vals[i]
			print(str("LOADED SETTING: [type : value]"))
			
			#print(type_string(typeof(val)))
			#print(val)
			
			if val is Dictionary:
				if val.size() == 1 and val.has("COLOR"):
					var v: Dictionary = val.get("COLOR")
					if v.has("R") and v.has("G") and v.has("B"):
						if v.size() == 4 and v.has("A"):
							var new_value: Color = Color(v.get("R"), v.get("G"), v.get("B"), v.get("A"))#{"COLOR" : {"R" : this_value.r, "G" : this_value.g, "B" : this_value.b, "A" : this_value.a}}
							val = new_value
						elif v.size() == 3:
							var new_value: Color = Color(v.get("R"), v.get("G"), v.get("B"), 1.0)
							val = new_value
			
			var setting_name:String = this_setting.get("SETTING_NAME")
			if emit_name_with_value_change:
				setting_callable.call(val, setting_name)
			else:
				setting_callable.call(val)
			new_vals.append(val)
		
		vals = new_vals
		this_setting["SETTING_VALUES"] = vals
	
	return true


func instance_ui(ui_parent:Node) -> ModularSettingsMenu:
	var this_ui: ModularSettingsMenu = await ModularSettingsMenu.build_settings_ui(self, ui_parent)
	return this_ui

func _instance_ui(ui_parent:Node) -> ModularSettingsMenu:
	var this_ui: ModularSettingsMenu = await ModularSettingsMenu.build_settings_ui(self, ui_parent)
	return this_ui

func instance_ui_window(ui_window_parent:Node, at_position:Vector2i=Vector2i(-1,-1)) -> ModularSettingsMenu:
	var window: Window = Window.new()
	
	window.min_size = Vector2i.ZERO
	window.wrap_controls = true
	window.popup_window = true
	#window.always_on_top = true
	window.exclusive = false
	window.transparent = true
	window.borderless = true
	
	window.close_requested.connect(func(): window.queue_free())
	
	#window.set_flag(Window.FLAG_TRANSPARENT, true)
	#window.set_flag(Window.FLAG_POPUP, true)
	
	#window.set_flag(Window.FLAG_RESIZE_DISABLED, true)
	#window.keep_title_visible = true
	#window.borderless = true
	
	await Make.child(window, ui_window_parent)
	
	
	var this_ui: ModularSettingsMenu = await ModularSettingsMenu.build_settings_ui(self, window)
	
	window.size = this_ui.size
	
	if at_position == Vector2i(-1,-1):
		at_position = DisplayServer.mouse_get_position() - (window.size / 2)
	window.position = at_position
	
	
	
	return this_ui


#static func pop(settings_name:String, ui_parent:Node) -> ModularSettingsMenu:
	#
	#if not all_settings.has(settings_name): return null
	#var settings: Settings = all_settings.get(settings_name)


func get_settings_hash(hash_name:String="settings", hash_props:Array=setting_properties.keys()) -> int:
	var prehash: String = hash_name
	
	var props: Array = hash_props
	props.sort()
	
	for prop:String in props:
		prehash = str(prehash + prop)
	
	return hash(prehash)
