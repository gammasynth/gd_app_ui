#|*******************************************************************
# alert_message.gd
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
extends MarginContainer

class_name AlertMessage

@onready var alerts_v_box = get_parent()
@onready var alerts_scroll_box = alerts_v_box.get_parent()

#@onready var alert_system: AlertSystem = alerts_scroll_box.get_parent()
#@onready var ui:UI = alert_system.get_parent()
#@onready var game:Game = ui.get_parent()
#@onready var app:App = game.get_parent()

@export var use_centering:bool=true
@export var use_colors:bool=true

@export var alert_type_text: RichTextLabel
@export var alert_title_text: RichTextLabel
@export var alert_message_text: RichTextLabel


@onready var begin_fade_timer: Timer = $BeginFadeTimer

const ALERT_TYPE_COLORS = {
	Alert.ALERT_TYPES.ALERT : Color(0.34, 0.32, 1.0, 1.0),
	Alert.ALERT_TYPES.WARNING : Color(1.0, 0.31, 0.14, 1.0),
	Alert.ALERT_TYPES.ERROR : Color(1.0, 0.0, 0.13, 1.0),
	Alert.ALERT_TYPES.TIP : Color(0.0, 1.0, 0.9, 1.0)
}

const ALERT_TITLE_COLORS = {
	Alert.ALERT_TYPES.ALERT : Color(0.55, 0.76, 1.0, 1.0),
	Alert.ALERT_TYPES.WARNING : Color(1.0, 0.49, 0.34, 1.0),
	Alert.ALERT_TYPES.ERROR : Color(1.0, 0.0, 0.26, 1.0),
	Alert.ALERT_TYPES.TIP : Color(1.0, 0.99, 0.6, 1.0)
}


var alert_type : Alert.ALERT_TYPES = Alert.ALERT_TYPES.ALERT
var alert_title : String = "Alert"
var alert_message : String = "This is an Alert."

var alert_screen_time : float = 1.0
var alert_fade_time : float = 1.0

var custom_alert_screen_time : float = -1.0
var custom_alert_fade_time : float = -1.0


func create_alert_message(alert:Alert):
	alert_type = alert.alert_type
	alert_title = alert.alert_title
	alert_message = alert.alert_message
	
	custom_alert_screen_time = alert.custom_alert_screen_time
	custom_alert_fade_time = alert.custom_alert_fade_time



func _ready() -> void:
	alert_type_text.text = Text.center(alert_type_to_string(alert_type), use_centering)
	alert_type_text.modulate = ALERT_TYPE_COLORS[alert_type]
	if not use_colors: alert_type_text.modulate = Color.WHITE
	
	alert_title_text.text = Text.center(alert_title, use_centering)
	alert_title_text.modulate = ALERT_TITLE_COLORS[alert_type]
	if not use_colors: alert_title_text.modulate = Color.WHITE
	
	alert_message_text.text = Text.center(alert_message, use_centering)
	
	
	
	alert_screen_time = alert_type_to_fade_time(alert_type)
	alert_fade_time = alert_screen_time / 4.0
	
	if custom_alert_screen_time >= 0:
		alert_screen_time = custom_alert_screen_time
	if custom_alert_fade_time >= 0:
		alert_fade_time = custom_alert_fade_time
	
	begin_fade_timer.start(alert_screen_time)


func alert_type_to_string(_alert_type:Alert.ALERT_TYPES) -> String:
	var alert_string = "Alert"
	match _alert_type:
		Alert.ALERT_TYPES.ALERT:
			alert_string = "Alert"
		Alert.ALERT_TYPES.WARNING:
			alert_string = "Warning!"
		Alert.ALERT_TYPES.ERROR:
			alert_string = "Error!"
		Alert.ALERT_TYPES.TIP:
			alert_string = "Tip"
	return alert_string

func alert_type_to_fade_time(_alert_type:Alert.ALERT_TYPES) -> float:
	var fade_time = 1.0
	match _alert_type:
		Alert.ALERT_TYPES.ALERT:
			fade_time = 1.0
		Alert.ALERT_TYPES.WARNING:
			fade_time = 3.0
		Alert.ALERT_TYPES.ERROR:
			fade_time = 4.0
		Alert.ALERT_TYPES.TIP:
			fade_time = 2.0
	return fade_time


func _on_begin_fade_timer_timeout() -> void:
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), alert_fade_time + (alerts_scroll_box.get_child_count() / 2.0))
	tween_fade.tween_callback(queue_free)
