#|*******************************************************************
# alert_system_ui.gd
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

class_name AlertSystemUI

@export var alerts_v_box: VBoxContainer

@export var alert_message_path:String = "res://lib/gd_app_ui/scene/prefab/ui/alerts/alert_message.tscn"
@export var server_alert_message_path:String = "res://lib/gd_app_ui/scene/prefab/ui/alerts/server_alert_message.tscn"



func initialize_alert_system():
	
	#multiplayer_spawner.add_spawnable_scene(alert_message_path)
	#multiplayer_spawner.add_spawnable_scene(server_alert_message_path)
	
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
	AlertSystem.create_warning("Systemrule modified!", str("The Systemrule " + systemrule + " has been set to " + str(value) + "."))
