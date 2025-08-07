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
