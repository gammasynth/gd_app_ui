extends DatabaseMarginContainer

class_name AppUI

signal splashed

static var app: App
static var ui: AppUI

const BASE_WINDOW_SIZE := Vector2(1152, 648)

@export var window_minimum_size := Vector2(0,0)
@export var fixed_window_size := Vector2(0,0)


var loading_screen : ModularLoadingScreen: get = _get_loading_screen

@export var custom_loading_screen_scene_path: String = ""
func _get_loading_screen() -> ModularLoadingScreen: 
	if loading_screen and is_instance_valid(loading_screen): return loading_screen
	#if app.registry_system: 
		#var scene = Registry.pull("generic_modular_ui", "modular_loading_screen.tscn")
		#if scene: screen = scene.instantiate()
	var loading_screen_path:String = "res://lib/gd_app_ui/scene/prefab/ui/modular_ui/generic_modular_ui/modular_loading_screen.tscn"
	if not custom_loading_screen_scene_path.is_empty(): loading_screen_path = custom_loading_screen_scene_path;
	
	if not loading_screen: loading_screen = load(loading_screen_path).instantiate()
	current_loading_screen = loading_screen
	return loading_screen

var current_loading_screen : ModularLoadingScreen = null

var cutscene : ModularCutscene :
	set(c):
		cutscene = c
		if c:
			cutscene.finished.connect(cutscene_ended)

@export var splash_video_path: String = ""
@export var splash_audio_path: String = ""
@export var splash_audio_bus: StringName = "Master"

var splash_screen : ModularCutscene : get = _get_splash_screen


@export var current_scene : Control = null
@export var requested_next_scene : Control = null


@export var alert_system_ui_path:String = "res://lib/gd_app_ui/scene/ui/alert_system_ui.tscn"
var alert_system_ui:AlertSystemUI = null

@export var chat_system_ui_path:String = "res://lib/gd_app_ui/scene/ui/chat_system_ui.tscn"
var chat_system_ui:ChatSystemUI = null

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
	if App.ui != self: App.ui = self
	
	app.app_starting.connect(app_ui_starting)
	app.pre_load.connect(start_loading_screen)



func app_ui_starting() -> void: 
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



static func request_scene(new_scene:Control) -> void:
	if not ui: return
	
	if ui.current_scene == null:
		ui.set_scene(new_scene)
	else:
		ui.requested_next_scene = new_scene


func set_scene(new_scene:Control) -> void:
	if current_scene:
		if has_node(current_scene.get_path()): remove_child(current_scene)
	
	add_child(new_scene)
	current_scene = new_scene
	
	requested_next_scene = null


func _process(delta: float) -> void:
	# TODO
	#  this should probably be done somewhere else!
	if requested_next_scene != null: set_scene(requested_next_scene)


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
