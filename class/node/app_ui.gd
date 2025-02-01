extends DatabaseMarginContainer

class_name AppUI

signal splashed

static var app: App
static var ui: AppUI

var loading_screen : ModularLoadingScreen: get = _get_loading_screen

@export var custom_loading_screen_scene_path: String = ""
func _get_loading_screen() -> ModularLoadingScreen: 
	if loading_screen and is_instance_valid(loading_screen): return loading_screen
	var screen: ModularLoadingScreen
	
	#if app.registry_system: 
		#var scene = Registry.pull("generic_modular_ui", "modular_loading_screen.tscn")
		#if scene: screen = scene.instantiate()
	var loading_screen_path:String = "res://lib/gd_app_ui/scene/prefab/ui/modular_ui/generic_modular_ui/modular_loading_screen.tscn"
	if not custom_loading_screen_scene_path.is_empty(): loading_screen_path = custom_loading_screen_scene_path;
	
	if not screen: screen = load(loading_screen_path).instantiate()
	loading_screen = screen
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
	
	#if app.registry_system and not screen: 
		#var scene = Registry.pull("generic_modular_ui", "modular_cutscreen.tscn")
		#if scene: screen = scene.instantiate()
	
	if not screen: screen = load("res://lib/gd_app_ui/scene/prefab/ui/modular_ui/generic_modular_ui/modular_cutscene.tscn").instantiate()
	
	splash_screen = screen
	if cutscene != splash_screen: cutscene = splash_screen
	return splash_screen

var splashing: bool = false





func _initialized() -> void:
	app = App.app
	if ui: push_error("No, only use one instance of AppUI.")
	ui = self
	
	app.app_starting.connect(app_starting)
	app.pre_load.connect(start_loading_screen)

func _ready_up() -> Error:
	if App.ui != self: App.ui = self
	return OK


func app_starting() -> void: 
	app.ui_subduing = true
	
	setup_window()
	
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



func setup_window() -> void:
	#get_window().borderless = true
	get_window().min_size = Vector2i(0, 0)
	get_tree().get_root().set_transparent_background(true)
	get_window().set_wrap_controls(true)
	
	get_window().size = Vector2i(250, 0)
	
	refresh_window()



func start_loading_screen() -> Error:
	app.ui_subduing = true
	app.state = app.APP_STATES.LOADING
	await Make.child(loading_screen, self)
	
	loading_screen.setup_loader(App.load_tracker)
	
	
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
