#|*******************************************************************
# modular_tilemap.gd
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
extends DatabaseTileMapLayer

class_name ModularTilemap

var tile_data: Dictionary = {}

func setup_tileset() -> Error:
	return _setup_tileset()

func _setup_tileset() -> Error:
	return OK


func add_tile_to_set(tileset: TileSet, tile_source_id:int, source_name:String, texture: Texture2D, tile_size:Vector2i) -> int:
	if texture == null:
		warn("creating tile", ERR_DOES_NOT_EXIST, true, true)
		return ERR_DOES_NOT_EXIST
	var tile_atlas_source = TileSetAtlasSource.new()
	
	var cell_size:Vector2i = tile_size
	
	var w = texture.get_width()
	var h = texture.get_height()
	
	if w % tile_size.x != 0 or h % tile_size.y != 0:
		# texture size does not fit evenly into grid
		# will hope for the best and just use whole image size as texture region for this tile_size tile
		cell_size = Vector2i(w,h)
	elif w > tile_size.x or h > tile_size.y:
		# texture size is multiple of grid size
		# decide what to do ehre later ?
		pass
	
	#tile_atlas_source.texture_region_size = cell_size.abs()
	tile_atlas_source.set_texture_region_size(cell_size)
	tile_atlas_source.set_texture(texture)
	
	var x = 0
	for i in floor(float(w) / float(cell_size.x)):
		#print("tile + " + str(i + 1))
		tile_atlas_source.create_tile(Vector2i(x,0))
		x += 1
	
	chatd(str("created " + str(x) + " tiles for texture: " + source_name))
	
	
	
	while tile_source_id <= tileset.get_source_count() - 1:
		tile_source_id += 1
	
	if tile_source_id > tileset.get_source_count():
		tile_source_id = tileset.get_source_count()
	
	tileset.add_source(tile_atlas_source, tile_source_id)
	tile_source_id += 1
	return tile_source_id



func get_tileset_from_registry(registry_name:String, tile_size:Vector2i=Vector2i(8,8), exclude_groups:Array[String]=[]) -> Error: # this assumes a Registry's data consists of { file_name : RegistryEntryGroup }
	
	chat("Setting up tileset...", Text.COLORS.white)
	
	var building_registry:Registry = Registry.registries[registry_name]
	#print(building_registry)
	var group_keys = building_registry.data.keys()
	for key:String in group_keys:
		for exclude in exclude_groups:
			if key.contains(exclude):
				group_keys.erase(key)
	
	chatd(str("Found keys: " + str(group_keys)))
	
	var tileset = TileSet.new()
	tileset.tile_size = tile_size
	
	var tile_source_id: int = 0
	
	for group_key in group_keys:
		var group = building_registry.data[group_key]
		tile_source_id = add_tiles_from_database(group, tileset, tile_source_id, tile_size)
	
	set_tile_set(tileset)
	chat("Tileset completed.", Text.COLORS.white)
	return OK

func add_tiles_from_database(group:Database, tileset: TileSet, tile_source_id, tile_size:Vector2i) -> int:
	for k in group.data:
		var e = group.data[k]
		if e is RegistryEntryGroup or e is RegistryEntry:
			tile_source_id = add_tiles_from_database(e, tileset, tile_source_id, tile_size)
		else:
			if e is Texture2D:
				var texture: Texture2D = e
				tile_data[tile_source_id] = group
				tile_source_id = add_tile_to_set(tileset, tile_source_id, group.name, texture, tile_size)
			else:
				print(name + " | error with unknown tile element: " + str(e))
				return ERR_BUG
	return tile_source_id
