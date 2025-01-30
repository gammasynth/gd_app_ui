extends DatabaseControl

class_name ModularCutscene

signal finished

@export var play_on_ready:bool = true

@export var skippable:bool = true

@export var stream_path: String = ""
@export var stream: VideoStream = null

@export var audio_stream_path: String = ""
@export var audio_stream: AudioStream = null
@export var audio_bus_name:StringName = "Master"

@export var finish_on_audio: bool = false

@onready var modular_background: ModularBackground = $modular_background
@onready var video: VideoStreamPlayer = $VideoStreamPlayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer


var done: bool = false
var started: bool = false



func _ready_up() -> Error:
	if play_on_ready: try_play()
	return OK


func _pre_start() -> Error:
	try_play()
	return OK


func try_play():
	if started: return
	
	audio.set_bus(audio_bus_name)
	if not audio.stream: check_audio_stream()
	
	if not video.stream: check_stream()
	if not video.stream and not audio.stream: finish_cutscene()
	
	started = true
	
	video.play()
	audio.play()


func check_stream():
	if stream_path:
		stream = load(stream_path)
	
	if stream is VideoStream: 
		video.stream = stream; return

func check_audio_stream():
	if audio_stream_path:
		audio_stream = load(audio_stream_path)
	
	if audio_stream is AudioStream: 
		audio.stream = audio_stream; return


func _unhandled_input(event: InputEvent) -> void:
	if skippable and not done:
		if event is InputEventMouseButton and event.pressed: finish_cutscene()
		if event.is_pressed(): finish_cutscene()


func finish_cutscene() -> void:
	if done: return
	done = true
	finished.emit()

func _on_video_stream_player_finished() -> void:
	finish_cutscene()


func _on_audio_stream_player_finished() -> void:
	if finish_on_audio: finish_cutscene()
