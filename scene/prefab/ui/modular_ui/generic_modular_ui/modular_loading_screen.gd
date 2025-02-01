@tool
extends Control

class_name ModularLoadingScreen

@onready var menu_margin: MarginContainer = $menu_margin
@onready var menu_vbox: VBoxContainer = $menu_margin/vbox

@onready var title_text: RichTextLabel = $menu_margin/vbox/title_text
@onready var splash_texture: TextureRect = $menu_margin/vbox/splash_texture
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
	load_tracker.progress_bar = progress_bar
	load_tracker.event_text = event_text
	load_tracker.description_text = description_text
	load_tracker.finished.connect(Make.fade_delete.bind(self))
