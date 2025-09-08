extends DatabasePanelContainer

class_name ModularSettingsMenu

@onready var menu_title: RichTextLabel = $margin/menu_vbox/title_header/hbox/title_margin/menu_title
@onready var settings_vbox: VBoxContainer = $margin/menu_vbox/settings_vbox

var settings: Settings = null

var closing: bool = false

var dragging: bool = false
var drag_offset: Vector2i

var options:Dictionary = {} # setting_name String : option ModularSettingOption

static func build_settings_ui(settings_obj:Settings, ui_parent: Node = null) -> ModularSettingsMenu:
	
	var settings_ui: ModularSettingsMenu
	var use_registry: bool = App.app.registry_system
	
	if use_registry: settings_ui = Registry.pull("modular_settings", "modular_settings_menu.tscn").instantiate()
	else: settings_ui = load("res://lib/gd_app_ui/scene/prefab/ui/modular_ui/settings_ui/modular_settings_menu.tscn").instantiate()
	
	if not ui_parent:
		if App.ui: ui_parent = App.ui
	
	if ui_parent: await Make.child(settings_ui, ui_parent)
	
	settings_ui.settings = settings_obj
	
	settings_ui.menu_title.text = settings_obj.name
	
	var props: Dictionary = settings_obj.setting_properties
	
	for prop: String in props:
		var setting_dictionary: Dictionary = props.get(prop)
		
		var option:ModularSettingOption = ModularSettingOption.get_setting_ui(setting_dictionary)
		option.modular_settings = settings_ui
		settings_ui.settings.setting_value_was_set.connect(option.setting_value_was_set)
		
		settings_ui.options.set(prop, option)
		
		if ui_parent: await Make.child(option, settings_ui.settings_vbox)
	
	return settings_ui


func _process(_delta: float) -> void:
	var mouse: Vector2i = DisplayServer.mouse_get_position()
	if dragging: get_window().position = mouse + drag_offset


func _on_close_button_button_down() -> void:
	if closing: return
	closing = true
	if get_parent() is Window:
		if get_parent().get_parent():
			get_parent().queue_free()
		else:
			queue_free()
	else:
		queue_free()


func _on_title_header_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				drag_offset = get_window().position - DisplayServer.mouse_get_position()
				dragging = true
			else:
				dragging = false
