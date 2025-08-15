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
	
	if id_pressed.is_connected(on_id_clicked):
		id_pressed.disconnect(on_id_clicked)
	
	id_pressed.connect(on_id_clicked)
	clear(true)
	assemble_actions()
	
	if _show: popup()


func assemble_actions() -> void:
	for action in actions:
		var a = actions[action]
		if a is Callable:
			add_item(action)
		elif a is Dictionary:
			assemble_submenu_actions(action, a)
		else:
			printerr(str("what is " + str(a)))


func assemble_submenu_actions(action: String, _sub_actions: Dictionary, _submenu: PopupMenu = null) -> void:
	var submenu
	if not _submenu:
		submenu = PopupMenu.new()
	else:
		submenu = _submenu
	
	submenu.id_pressed.connect(func (id: int):
		var callable = _sub_actions[submenu.get_item_text(id)]
		if callable is Callable: callable.call()
	)
	add_submenu_node_item(action, submenu)
		
	for subaction in _sub_actions:
		if _sub_actions[subaction] is Callable:
			submenu.add_item(subaction)
		else:
			var subsubmenu = PopupMenu.new()
			submenu.add_submenu_node_item(subaction, subsubmenu)
			assemble_submenu_actions(subaction, _sub_actions[subaction], subsubmenu)


func on_id_clicked(id) -> void:
	var action = actions[get_item_text(id)]
	if action is Callable:
		action.call()


static func setup(node, _actions, _menu_type:MENU_TYPES = MENU_TYPES.MANUAL, _forced_position:Variant = null) -> ContextMenu:
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
