extends Control

class_name AlertSystemUI

@onready var alerts_v_box: VBoxContainer = $AlertsScrollBox/AlertsVBox

@export var alert_message_path:String = "res://lib/gd_app_ui/scene/prefab/ui/alerts/alert_message.tscn"
@export var server_alert_message_path:String = "res://lib/gd_app_ui/scene/prefab/ui/alerts/server_alert_message.tscn"


func _ready() -> void:
	initialize_alert_system()

func initialize_alert_system():
	AlertSystem.instance.connect("alert_called", push_alert_ui)
	AlertSystem.instance.connect("warning_called", push_alert_ui)
	AlertSystem.instance.connect("error_called", push_alert_ui)
	AlertSystem.instance.connect("tip_called", push_alert_ui)
	
	AlertSystem.instance.connect("systemrule_changed", systemrule_changed)



func push_alert_ui(alert:Alert):
	var alert_message:AlertMessage = null
	if alert.server_alert:
		if not alert_message_path.is_empty(): 
			alert_message = load(alert_message_path).instantiate()
	else:
		if not server_alert_message_path.is_empty(): 
			alert_message = load(server_alert_message_path).instantiate()
	
	if not alert_message: return
	
	alert_message.create_alert_message(alert)
	
	alerts_v_box.add_child(alert_message, true)


func systemrule_changed(systemrule:String,value):
	AlertManager.create_warning("Systemrule modified!", str("The Systemrule " + systemrule + " has been set to " + str(value) + "."))
