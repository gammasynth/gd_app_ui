@tool
extends Control

class_name ModularLoadingScreen

@onready var menu_margin: MarginContainer = $menu_margin
@onready var menu_vbox: VBoxContainer = $menu_margin/vbox

@onready var title_text: RichTextLabel = $menu_margin/vbox/title_text
@onready var splash_texture: TextureRect = $menu_margin/vbox/splash_texture
@onready var event_text: RichTextLabel = $menu_margin/vbox/event_text
@onready var progress_bar: ProgressBar = $menu_margin/vbox/progress_bar


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


@export var additive_load:bool = true

var connected_workers:int = 0
var finished_workers:int = 0

func _ready_up() -> Error:
	print("initialized.")
	return OK


func registry_started(total_workload:int):
	print("total workers: " + str(connected_workers))
	setup_loader(total_workload)

func registry_worked(amt):
	handle_registry_work_step(amt)

func registry_finished():
	finished_workers += 1
	print("workers finished: " + str(finished_workers))
	while finished_workers > connected_workers:
		finished_workers -= 1
	if connected_workers > 0 and finished_workers == connected_workers:
			print("Registry finished, but no Core instance to return to!")



func handle_registry_work_step(work_amount:int) -> Error:
	await push_progress(work_amount)
	print("work step " + str(work_amount))
	await RenderingServer.frame_post_draw
	return OK


func setup_loader(final_value:int) -> Error:
	if not progress_bar.is_node_ready(): await progress_bar.ready
	if additive_load:
		#progress_bar.value = 0
		progress_bar.max_value += final_value# + 10000000
	else:
		progress_bar.value = 0
		progress_bar.max_value = final_value# + 10000000
	await RenderingServer.frame_post_draw
	return OK


func push_work_text(work_text:String) -> Error:
	event_text.text = work_text
	await RenderingServer.frame_post_draw
	return OK



func push_progress(value:int) -> Error:
	progress_bar.value += value
	await RenderingServer.frame_post_draw
	return OK
