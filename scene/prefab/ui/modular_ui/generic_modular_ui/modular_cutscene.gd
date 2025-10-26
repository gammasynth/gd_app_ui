#|*******************************************************************
# modular_cutscene.gd
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

#@onready var modular_background: ModularBackground = $modular_background
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
	if not video.stream and not audio.stream: 
		finish_cutscene()
		return
	
	started = true
	
	video.play()
	audio.play()


func check_stream():
	if stream_path:
		stream = load(stream_path)
	
	if stream is VideoStream: 
		video.stream = stream
	

func check_audio_stream():
	if audio_stream_path:
		audio_stream = load(audio_stream_path)
	
	if audio_stream is AudioStream: 
		audio.stream = audio_stream; return


func _input(event: InputEvent) -> void:
	if skippable and not done:
		if event is InputEventMouseButton and event.pressed: 
			finish_cutscene()
			return
		
		if event.is_pressed(): finish_cutscene()


func finish_cutscene() -> void:
	if done: return
	done = true
	video.stop()
	audio.stop()
	finished.emit()

func _on_video_stream_player_finished() -> void:
	finish_cutscene()


func _on_audio_stream_player_finished() -> void:
	if finish_on_audio: finish_cutscene()
