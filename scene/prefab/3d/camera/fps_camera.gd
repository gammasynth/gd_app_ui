#|*******************************************************************
# fps_camera.gd
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
extends Node3D

@export var base : Node3D = self

@onready var default_camera : Camera3D = $Camera3D
@export var camera : Camera3D 

@export var rotation_speed: float = 0.001

@export var upper_look_clamp_degrees: float = 95.0
@export var lower_look_clamp_degrees: float = -55.0


func _ready():
	print(default_camera)
	if not camera: camera = default_camera

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			base.rotate_y(-event.relative.x * rotation_speed)
			camera.rotate_x(-event.relative.y * rotation_speed)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(lower_look_clamp_degrees), deg_to_rad(upper_look_clamp_degrees))
