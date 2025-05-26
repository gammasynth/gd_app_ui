extends SettingWidget


@onready var menu_bar: MenuBar = $MenuBar
@onready var select: PopupMenu = $MenuBar/Select

func _widget_setup() -> Error:
	
	if widget_params.has("WINDOW_TITLE"): select.title = widget_params.get("WINDOW_TITLE")
	
	var item_index:int = 0
	
	while widget_params.has(str("ITEM_" + str(item_index))):
		
		var val: Variant = widget_params.get(str("ITEM_" + str(item_index)))
		
		if val is String:
			select.add_item(val)
		elif val is Dictionary:
			var item_def: Dictionary = val as Dictionary
			
			if item_def.has("ITEM_NAME") and item_def.get("ITEM_NAME") is String:
				var item_name: String = item_def.get("ITEM_NAME")
				
				var accel : Key = 0
				if item_def.has("ACCEL") and item_def.get("ACCEL") is Key: accel = item_def.get("ACCEL")
				
				select.add_item(item_name, -1, accel)
		
		item_index += 1
	
	return OK




func _on_select_index_pressed(index: int) -> void:
	update_setting_value(index)
