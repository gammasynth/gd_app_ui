extends PopupMenu
class_name ContextMenu

enum MENU_TYPES {MANUAL, TAP, RIGHT_CLICK}
var menu_type:MENU_TYPES = MENU_TYPES.TAP

#static var instance: ContextMenu
var actions: Dictionary
var forced_position:Variant = null

func create(_show: bool = true) -> void:
	App.app.get_window().add_child(self)
	
	if forced_position:
		if forced_position is Vector2 or forced_position is Vector2i:
			position = forced_position
		if forced_position is Callable:
			position = forced_position.call()
	else:
		position = DisplayServer.mouse_get_position()
	
	
	clear(true)
	assemble_actions()
	
	if _show: popup()


func assemble_actions() -> void:
	if not id_pressed.is_connected(on_id_clicked): id_pressed.connect(on_id_clicked)
	var idx:int = 0
	for action in actions:
		var a = actions[action]
		if a is Callable:
			add_item(action)
		elif a is Dictionary:
			if a.has("IS_CALLABLE") and a.get("IS_CALLABLE") and a.has("callable") and a.get("callable") is Callable:
				add_item(action, idx)
				if a.has("tooltip"): 
					set_item_tooltip(idx, a.get("tooltip"))
					print(get_item_tooltip(idx))
			else:
				assemble_submenu_actions(action, a, null, -1)
		elif a is String:
			if a == "TITLE":
				add_item(action, idx)
				set_item_disabled(idx,true)
			elif a == "SEPARATOR":
				add_separator(action, idx)
			else:
				printerr(str("what is " + str(a)))
		else:
			printerr(str("what is " + str(a)))
		idx += 1


func assemble_submenu_actions(action: String, _sub_actions: Dictionary, _submenu: ContextMenu = null, _idx:int=-1) -> void:
	var submenu = _submenu; if not submenu: submenu = ContextMenu.setup(null, _sub_actions)
	if not submenu.id_pressed.is_connected(submenu.on_id_clicked): 
		submenu.id_pressed.connect(submenu.on_id_clicked)
	
	add_submenu_node_item(action, submenu, _idx)
	
	var idx:int = 0
	for subaction in _sub_actions:
		var this = _sub_actions[subaction]
		if this is Callable:
			submenu.add_item(subaction, idx)
		elif this is Dictionary:
			if this.has("IS_CALLABLE") and this.get("IS_CALLABLE") and this.has("callable") and this.get("callable") is Callable:
				submenu.add_item(subaction, idx)
				if this.has("tooltip"): submenu.set_item_tooltip(idx, this.get("tooltip"))
				print(submenu.get_item_tooltip(idx))
			else:
				var subsubmenu = ContextMenu.setup(null, this)
				submenu.add_submenu_node_item(subaction, subsubmenu)
				subsubmenu.assemble_actions()
		else:
			var subsubmenu = ContextMenu.setup(null, this)
			submenu.add_submenu_node_item(subaction, subsubmenu)
			subsubmenu.assemble_actions()
		idx += 1


func on_id_clicked(id) -> void:
	var action = actions[get_item_text(id)]
	if action is Callable:
		action.call()
	if action is Dictionary:
		if action.has("callable"): action.get("callable").call()


static func setup(node:Node=null, _actions:Dictionary={}, _menu_type:MENU_TYPES = MENU_TYPES.MANUAL, _forced_position:Variant = null) -> ContextMenu:
	var instance: ContextMenu = ContextMenu.new()
	instance.actions = _actions
	instance.menu_type = _menu_type
	instance.forced_position = _forced_position
	if _menu_type != MENU_TYPES.MANUAL: node.gui_input.connect(instance.receive_input)
	return instance

func receive_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if menu_type == MENU_TYPES.TAP and event.button_index == 1:
				create()
			if menu_type == MENU_TYPES.RIGHT_CLICK and event.button_index == 2:
				create()
