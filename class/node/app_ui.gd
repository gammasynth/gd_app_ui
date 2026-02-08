#|*******************************************************************
# app_ui.gd
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
extends DatabaseMarginContainer

class_name AppUI

signal splashed

static var app: App
static var ui: AppUI

const BASE_WINDOW_SIZE := Vector2(1152, 648)

@export var window_minimum_size := Vector2(0,0)
@export var fixed_window_size := Vector2(0,0)


var loading_screen : ModularLoadingScreen
@export var loading_screen_ui_path: String = "res://lib/gd_app_ui/scene/prefab/ui/modular_ui/generic_modular_ui/modular_loading_screen.tscn"

var cutscene : ModularCutscene :
	set(c):
		cutscene = c
		if c:
			cutscene.finished.connect(cutscene_ended)

@export var splash_video_path: String = ""
@export var splash_audio_path: String = ""
@export var splash_audio_bus: StringName = "Master"

var splash_screen : ModularCutscene


@export var current_scene : Node = null
@export var requested_next_scene : Node = null


@export var alert_system_ui_path:String = "res://lib/gd_app_ui/scene/ui/alert_system_ui.tscn"
var alert_system_ui:AlertSystemUI = null

@export var chat_system_ui_path:String = "res://lib/gd_app_ui/scene/ui/chat_system_ui.tscn"
var chat_system_ui:ChatSystemUI = null

#func _get_splash_screen() -> ModularCutscene: 
	#var screen: ModularCutscene
	#if splash_screen and is_instance_valid(splash_screen): screen = splash_screen
	#
	##if app.registry_system and not screen: 
		##var scene = Registry.pull("generic_modular_ui", "modular_cutscreen.tscn")
		##if scene: screen = scene.instantiate()
	#
	#if not screen: screen = load("res://lib/gd_app_ui/scene/prefab/ui/modular_ui/generic_modular_ui/modular_cutscene.tscn").instantiate()
	#
	#splash_screen = screen
	#if cutscene != splash_screen: cutscene = splash_screen
	#return splash_screen

var splashing: bool = false


func get_loading_screen() -> ModularLoadingScreen:
	if loading_screen: return loading_screen
	loading_screen = load(loading_screen_ui_path).instantiate()
	return loading_screen


func _initialized() -> void:
	app = App.app
	if ui: push_error("No, only use one instance of AppUI.")
	ui = self
	if App.ui != self: App.ui = self
	
	app.app_starting.connect(app_ui_starting)
	app.pre_load.connect(start_loading_screen)
	_app_ui_initialized()

func _app_ui_initialized() -> void: pass


func app_ui_starting() -> void: 
	app.ui_subduing = true
	setup_window()
	
	#splash_screen.play_on_ready = false
	#splash_screen.finish_on_audio = true
	
	#await Make.child(splash_screen, self)
	#
	#if not splash_screen.video.stream:
		#splash_screen.stream_path = splash_video_path
	#
	#if not splash_screen.audio.stream:
		#splash_screen.audio_stream_path = splash_audio_path
	#
	#splashing = true
	#splash_screen.start()
	
	if splashing: 
		await splashed
	
	alert_system_ui = load(alert_system_ui_path).instantiate()
	await Make.child(alert_system_ui, self)
	
	chat_system_ui = load(chat_system_ui_path).instantiate()
	await Make.child(chat_system_ui, self)
	
	app.ui_subduing = false
	app.ui_mercy.emit()



func setup_window() -> void:
	#get_window().borderless = true
	
	
	get_window().min_size = Vector2i(window_minimum_size)
	get_tree().get_root().set_transparent_background(true)
	get_window().set_wrap_controls(true)
	
	get_window().size = Vector2i(fixed_window_size)
	
	refresh_window()



func start_loading_screen() -> Error:
	app.ui_subduing = true
	app.state = app.APP_STATES.LOADING
	
	var load_screen:ModularLoadingScreen=get_loading_screen()
	if not load_screen.is_inside_tree(): await Make.child(load_screen, self)
	loading_screen.setup_loader(App.load_tracker)
	
	
	app.ui_subduing = false
	app.ui_mercy.emit()
	return OK


func cutscene_ended() -> void:
	if cutscene: cutscene.queue_free()
	if splashing:
		splashing = false
		splashed.emit()




static func request_scene(new_scene:Node) -> void:
	if not ui: return
	ui.set_scene(new_scene)

static func request_change_scene(new_scene:Node) -> Error:
	if not ui: return ERR_CANT_CONNECT
	return await ui.change_scene(new_scene)


func set_scene(new_scene:Node) -> void:
	if current_scene and is_instance_valid(current_scene): current_scene.queue_free()
	
	add_child(new_scene)
	current_scene = new_scene

func change_scene(new_scene:Node) -> Error:
	if current_scene and is_instance_valid(current_scene): current_scene.queue_free()
	
	await Make.child(new_scene, self)
	current_scene = new_scene
	return OK


#func _process(delta: float) -> void:
	# TODO
	#  this should probably be done somewhere else!
	#if requested_next_scene != null: set_scene(requested_next_scene)


static func resize(new_size:Vector2i=Vector2i(0, 0)) -> void:
	if not ui: return
	if not ui.get_window(): return
	if new_size == Vector2i(0, 0): return
	ui.get_window().size = new_size

static func refresh_window(new_size:Vector2i=Vector2i(0, 0)):
	if not ui: return
	if not ui.get_window(): return
	resize(new_size)
	ui.get_window().child_controls_changed()

static func refresh_controls(control:Control=null):
	#var main_size:Vector2 = Vector2.ZERO
	if not control:
		if ui:
			control = ui
			#main_size = control.size
	
	if not control or not is_instance_valid(control): return
	
	for child in control.get_children():
		if child is Control: refresh_controls(child)
	
	#if control is not Container: 
		#if control.get_parent() is Container: control.size = Vector2.ZERO
	
	if control is Container:
		control.queue_sort()
	#hide_control(control)
	#reset_cms(control)
	#await control.get_tree().process_frame
	#await control.get_tree().process_frame
	#control.reset_size()
	#show_control(control)


static func reset_cms(control:Control):
	for child in control.get_children():
		if child is Control: reset_cms(child)
	control.item_rect_changed.emit()
	#control.set_custom_minimum_size.call_deferred(control.custom_minimum_size)

static func hide_control(control:Control):
	for child in control.get_children():
		if child is Control: hide_control(child)
	control.hide()

static func show_control(control:Control):
	for child in control.get_children():
		if child is Control: show_control(child)
	control.show.call_deferred()
