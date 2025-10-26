#|*******************************************************************
# modular_loading_screen.gd
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
@tool
extends Control

class_name ModularLoadingScreen

@export var await_fadeout_time:float=0.5
@export var fadeout_time:float=1.0

@onready var menu_margin: MarginContainer = $menu_margin
@onready var menu_vbox: VBoxContainer = $menu_margin/vbox

@onready var title_text: RichTextLabel = $menu_margin/vbox/title_text
@onready var splash_texture: TextureRect = $menu_margin/vbox/splash_texture
@onready var subtitle_text: RichTextLabel = $menu_margin/vbox/subtitle_text


@onready var event_text: RichTextLabel = $menu_margin/vbox/event_text
@onready var progress_bar: ProgressBar = $menu_margin/vbox/progress_bar
@onready var description_text: RichTextLabel = $menu_margin/vbox/description_text


@export var margin_all:int = 0:
	set(m):
		if menu_margin:
			menu_margin.add_theme_constant_override("margin_left", m)
			menu_margin.add_theme_constant_override("margin_right", m)
			menu_margin.add_theme_constant_override("margin_top", m)
			menu_margin.add_theme_constant_override("margin_bottom", m)
		margin_all = m

@export var menu_pos:Vector2 = Vector2.ZERO:
	set(v):
		if menu_vbox: menu_vbox.position = v
		menu_pos = v

@export var show_percentage:bool:
	get:
		if progress_bar:
			return progress_bar.show_percentage
		return show_percentage
	set(b):
		if progress_bar: progress_bar.show_percentage = b
		show_percentage = b

@export var bar_size:float:
	get:
		if progress_bar:
			return progress_bar.size.y
		return bar_size
	set(f):
		if progress_bar:
			progress_bar.custom_minimum_size.y = f
			progress_bar.size.y = f
		bar_size = f



var load_tracker: LoadTracker = null

#func _ready_up() -> Error:
	#print("initialized.")
	#return OK

func setup_loader(_load_tracker:LoadTracker):
	load_tracker = _load_tracker
	load_tracker.loading_screen = self
	load_tracker.progress_bar = progress_bar
	load_tracker.event_text = event_text
	load_tracker.description_text = description_text
	load_tracker.finished.connect(load_tracker_finished)

func load_tracker_finished():
	load_tracker.progress_bar.value = load_tracker.progress_bar.max_value
	await get_tree().create_timer(await_fadeout_time).timeout
	Make.fade_delete(self, fadeout_time)
