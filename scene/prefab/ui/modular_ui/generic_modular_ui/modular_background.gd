extends Control

class_name ModularBackground

@export var scene: Node

var background: Variant

func _ready() -> void:
	var vp:SubViewport = $"background_ vpc/background_vp"
	if vp.get_child_count() > 0:
		background = vp
	var tex:TextureRect = $background_texture
	if tex.texture:
		background = tex
	if not background: background = $background_color_rect
	for c in get_children():
		if c != background: c.queue_free()
