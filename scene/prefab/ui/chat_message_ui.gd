extends HBoxContainer

@export var player_icon_path = "res://src/assets/texture/chara/player/player_chara/heads/blue_head/blue_head.png"
@export var player_name_text = ""
@export var message_text = ""


var icon = null

@onready var player_icon: TextureRect = $PlayerIcon
@onready var player_name_label: RichTextLabel = $PlayerNameLabel
@onready var message_label: RichTextLabel = $MessageLabel

var self_spawned = false

func setup_message(pid, icon_path, player_name, message):
	player_icon_path = icon_path
	player_name_text = str("[center]" + str(player_name) + "[/center]")
	message_text = str("[center]" + str(message) + "[/center]")
	
	if pid == NodeControl.game.my_peer_id:
		self_spawned = true


func _ready():
	if not self_spawned:
		get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().new_message_count += 1
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().scroll()

func _process(delta: float) -> void:
	if icon == null:
		if not player_icon_path.is_empty():
			icon = load(player_icon_path)
			player_icon.texture = icon
	
	var game = NodeControl.game
	if game.is_client:
			return
	
	player_name_label.text = str("[center]" + str(player_name_text) + "[/center]")
	message_label.text = str("[center]" + str(message_text) + "[/center]")
