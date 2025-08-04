extends Control

var chat_message_prefab = load("res://src/scene/prefab/ui/chat_message_h_box.tscn")

@onready var chat_panel: PanelContainer = $ChatPanelContainer
@onready var chat_h_box: HBoxContainer = $ChatPanelContainer/ChatHBox

@onready var chat_messages_v_box: VBoxContainer = $ChatPanelContainer/ChatHBox/ChatVBox/ScrollContainer/ChatMessagesVBox

@onready var chat_message_count: RichTextLabel = $ChatMessageCount
@onready var prompt_chat_message: RichTextLabel = $PromptChatMessage

@onready var line_edit: LineEdit = $ChatPanelContainer/ChatHBox/ChatVBox/LineEdit

var new_message_count = 0


var toggled = false

func _process(_delta):
	if NodeControl.game.hosting or NodeControl.game.is_client:
		visible = true
	else:
		visible = false
	
	if chat_message_count.visible == true:
		if new_message_count > 0:
			chat_message_count.text = str("[center]" + str(new_message_count) + " new messages![/center]")

func toggle_chat():
	if toggled:
		toggled = false
		chat_panel.visible = false
		prompt_chat_message.visible = true
		chat_message_count.visible = true
	else:
		new_message_count = 0
		line_edit.grab_focus()
		toggled = true
		chat_panel.visible = true
		prompt_chat_message.visible = false
		chat_message_count.visible = false

func close_chat():
	toggled = false
	chat_panel.visible = false
	prompt_chat_message.visible = true
	chat_message_count.visible = true

func _on_line_edit_text_submitted(new_text: String) -> void:
	var profile = NodeControl.game.player_profile
	var player_icon_path = profile.get_head_icon_texture_path()
	var player_name = profile.player_name
	var message = new_text
	
	if message.is_empty():
		line_edit.text = ""
		line_edit.release_focus()
		toggle_chat()
		return
	
	line_edit.text = ""
	line_edit.release_focus()
	
	var pid = multiplayer.get_unique_id()
	if pid == 1:
		spawn_chat_message(pid, player_icon_path, player_name, message)
	else:
		request_spawn_server_chat_message(pid, player_icon_path, player_name, message)


func scroll():
	$ChatPanelContainer/ChatHBox/ChatVBox/ScrollContainer.scroll_vertical += 2000


func request_spawn_server_chat_message(pid, player_icon_path, player_name, message):
	spawn_chat_message.rpc_id(1, pid, player_icon_path, player_name, message)

@rpc("any_peer", "reliable")
func spawn_chat_message(pid, player_icon_path, player_name, message):
	var chat_message = chat_message_prefab.instantiate()
	chat_message.setup_message(pid, player_icon_path, player_name, message)
	chat_messages_v_box.add_child(chat_message, true)
