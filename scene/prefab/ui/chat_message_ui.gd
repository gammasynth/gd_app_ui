extends HBoxContainer
class_name ChatMessageUI

@onready var user_icon: TextureRect = $user_icon
@onready var username_label: RichTextLabel = $username_label
@onready var message_label: RichTextLabel = $message_label


func setup_message(username, message):
	username_label.text = str("[center]" + str(username) + "[/center]")
	message_label.text = str("[center]" + str(message) + "[/center]")
	
