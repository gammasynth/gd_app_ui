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
