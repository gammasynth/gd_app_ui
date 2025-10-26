#|*******************************************************************
# context_menu.gd
#*******************************************************************
# This file is part of gd_app_ui.
# 
# gd_app_ui is an open-source software library.
# gd_app_ui is licensed under the MIT license.
# https://github.com/gammasynth/gd_app_ui
#*******************************************************************
# Copyright (c) 2025 AD - present; 1447 AH - present, Gammasynth.  
# 
# Gammasynth
# 
# Gammasynth (Gammasynth Software), Texas, U.S.A.
# https://gammasynth.com
# https://github.com/gammasynth
# 
# This software is licensed under the MIT license.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
#|*******************************************************************
extends PopupMenu
class_name ContextMenu

signal spawned_menu(context_menu:ContextMenu)

enum MENU_TYPES {MANUAL, TAP, RIGHT_CLICK}
var menu_type:MENU_TYPES = MENU_TYPES.TAP

#static var instance: ContextMenu
var actions: Dictionary
var forced_position:Variant = null

func create(_show: bool = true) -> void:
	wrap_controls = true
	App.app.add_child(self)
	
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
	spawned_menu.emit(self)


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
			else:
				var context = a; if a.has("context_menu"): context = a.get("context_menu")
				assemble_submenu_actions(action, context, null, idx)
			if a.has("tooltip"): 
				set_item_tooltip(idx, a.get("tooltip"))
			if a.has("disable") and a.get("disable"):
				set_item_disabled(idx, true)
			if a.has("disabled_callable") and a.get("disabled_callable") is Callable:
				set_item_disabled(idx, a.get("disabled_callable").call())
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
			else:
				var context = this; if this.has("context_menu"): context = this.get("context_menu")
				var subsubmenu = ContextMenu.setup(null, context)
				submenu.add_submenu_node_item(subaction, subsubmenu, idx)
				subsubmenu.assemble_actions()
			
			if this.has("tooltip"): submenu.set_item_tooltip(idx, this.get("tooltip"))
			if this.has("disable") and this.get("disable"):
				set_item_disabled(idx, true)
			if this.has("disabled_callable") and this.get("disabled_callable") is Callable:
				set_item_disabled(idx, this.get("disabled_callable").call())
		else:
			var subsubmenu = ContextMenu.setup(null, this)
			submenu.add_submenu_node_item(subaction, subsubmenu, idx)
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
