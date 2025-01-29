extends DatabaseMarginContainer

class_name AppUI

signal splashed

var app: App

var loading_screen : ModularLoadingScreen: get = _get_loading_screen

func _get_loading_screen() -> ModularLoadingScreen: 
	if loading_screen and is_instance_valid(loading_screen): return loading_screen
	var screen: ModularLoadingScreen
	
	if app.registry_system: 
		var scene = Registry.pull("generic_modular_ui", "modular_loading_screen.tscn")
		if scene: screen = scene.instantiate()
	
	if not screen: screen = load("res://core/scene/prefab/ui/modular_ui/generic_modular_ui/modular_loading_screen.tscn").instantiate()
	return screen

var cutscene : ModularCutscene :
	set(c):
		cutscene = c
		if c:
			cutscene.finished.connect(cutscene_ended)

@export var splash_video_path: String = ""
@export var splash_audio_path: String = ""
@export var splash_audio_bus: StringName = "Master"

var splash_screen : ModularCutscene : get = _get_splash_screen


func _get_splash_screen() -> ModularCutscene: 
	var screen: ModularCutscene
	if splash_screen and is_instance_valid(splash_screen): screen = splash_screen
	
	if app.registry_system and not screen: 
		var scene = Registry.pull("generic_modular_ui", "modular_cutscreen.tscn")
		if scene: screen = scene.instantiate()
	
	if not screen: screen = load("res://core/scene/prefab/ui/modular_ui/generic_modular_ui/modular_cutscene.tscn").instantiate()
	
	splash_screen = screen
	if cutscene != splash_screen: cutscene = splash_screen
	return splash_screen

var splashing: bool = false





func _init() -> void:
	app = App.app
	
	app.app_starting.connect(app_starting)
	app.pre_load.connect(start_loading_screen)

func _ready_up() -> Error:
	if App.ui != self: App.ui = self
	return OK


func app_starting() -> void: 
	app.ui_subduing = true
	
	splash_screen.play_on_ready = false
	splash_screen.finish_on_audio = true
	
	await Make.child(splash_screen, self)
	
	if not splash_screen.video.stream:
		splash_screen.stream_path = splash_video_path
	
	if not splash_screen.audio.stream:
		splash_screen.audio_stream_path = splash_audio_path
	
	splashing = true
	splash_screen.start()
	
	if splashing: 
		await splashed
	
	app.ui_subduing = false
	app.ui_mercy.emit()




func start_loading_screen() -> Error:
	app.ui_subduing = true
	await Make.child(loading_screen, self)
	app.ui_subduing = false
	app.ui_mercy.emit()
	return OK


func cutscene_ended() -> void:
	if cutscene: cutscene.queue_free()
	if splashing:
		splashing = false
		splashed.emit()

func loading_screen_finished() -> void:
	loading_screen.queue_free()
