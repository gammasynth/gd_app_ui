#|*******************************************************************
# chat_system_ui.gd
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
extends Control

class_name ChatSystemUI

@export var chat_message_path = "res://src/scene/prefab/ui/chat_message_ui.tscn"

@onready var chat_panel: PanelContainer = $ChatPanelContainer
@onready var chat_messages_v_box: VBoxContainer = $ChatPanelContainer/ChatHBox/ChatVBox/ScrollContainer/ChatMessagesVBox

@onready var chat_message_count: RichTextLabel = $ChatMessageCount
@onready var prompt_chat_message: RichTextLabel = $PromptChatMessage

@onready var line_edit: LineEdit = $ChatPanelContainer/ChatHBox/ChatVBox/LineEdit

var new_message_count:int = 0

var toggled = false

func initialize_chat_system():
	ChatSystem.instance.message_posted.connect(spawn_chat_message)

func _process(_delta):
	if App.is_server or App.is_client: visible = true
	else: visible = false
	
	if chat_message_count.visible and new_message_count > 0: chat_message_count.text = str("[center]" + str(new_message_count) + " new messages![/center]")

func _unhandled_input(event: InputEvent) -> void: if visible and event.is_action("ui_chat") and event.is_pressed() and not event.is_echo(): toggle_chat()

func toggle_chat():
	if toggled: close_chat()
	else: open_chat()


func open_chat() -> void:
	new_message_count = 0
	line_edit.grab_focus()
	toggled = true
	chat_panel.visible = true
	prompt_chat_message.visible = false
	chat_message_count.visible = false

func close_chat() -> void:
	line_edit.release_focus()
	toggled = false
	chat_panel.visible = false
	prompt_chat_message.visible = true
	chat_message_count.visible = true


func _on_line_edit_text_submitted(message: String) -> void:
	if message.is_empty(): return close_chat()
	
	line_edit.text = ""
	line_edit.release_focus()
	
	ChatSystem.send_message(message)
	new_message_count -= 1
	scroll()


func scroll():$ChatPanelContainer/ChatHBox/ChatVBox/ScrollContainer.scroll_vertical += 2000


@rpc("any_peer", "call_local", "reliable")
func spawn_chat_message(username, message):
	var chat_message = load(chat_message_path).instantiate()
	await Make.child(chat_message, chat_messages_v_box)
	chat_message.setup_message(username, message)
	new_message_count += 1
