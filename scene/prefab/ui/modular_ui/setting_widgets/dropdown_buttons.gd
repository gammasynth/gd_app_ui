extends SettingWidget

@onready var menu_button: MenuButton = $MenuButton
var popup:PopupMenu = null

var items_dict:Dictionary = {}

func _widget_setup() -> Error:
	popup = menu_button.get_popup()
	popup.index_pressed.connect(_on_index_pressed)
	
	if widget_params.has("WINDOW_TITLE"): popup.title = widget_params.get("WINDOW_TITLE")
	
	var item_index:int = 0
	
	while widget_params.has(str("ITEM_" + str(item_index))):
		
		var val: Variant = widget_params.get(str("ITEM_" + str(item_index)))
		
		if val is String:
			items_dict.set(item_index, val)
			popup.add_item(val)
		elif val is Dictionary:
			var item_def: Dictionary = val as Dictionary
			
			if item_def.has("ITEM_NAME") and item_def.get("ITEM_NAME") is String:
				var item_name: String = item_def.get("ITEM_NAME")
				
				var accel : Key = 0
				if item_def.has("ACCEL") and item_def.get("ACCEL") is Key: accel = item_def.get("ACCEL")
				
				items_dict.set(item_index, item_name)
				popup.add_item(item_name, -1, accel)
		
		item_index += 1
	menu_button.text = items_dict.get(default_value)
	return OK




func _on_index_pressed(index: int) -> void:
	update_setting_value(index)
	menu_button.text = items_dict.get(index)

func _update_setting_value_from_external(new_value:Variant) -> void:
	if new_value is int: 
		if items_dict.has(new_value):
			menu_button.text = items_dict.get(new_value)
