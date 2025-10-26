#|*******************************************************************
# server_alert_message.gd
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
extends AlertMessage

class_name ServerAlertMessage

func _ready() -> void:
	
	if not is_multiplayer_authority():
		return
	
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



func _on_begin_fade_timer_timeout() -> void:
	if not is_multiplayer_authority():
		return
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), alert_fade_time + (alerts_scroll_box.get_child_count() / 2.0))
	tween_fade.tween_callback(queue_free)
