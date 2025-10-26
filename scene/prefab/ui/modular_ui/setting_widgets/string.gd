#|*******************************************************************
# string.gd
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
extends SettingWidget

@onready var line_edit: LineEdit = $LineEdit


func _widget_setup() -> Error:
	if default_value and default_value is String: line_edit.text = default_value
	if modular_setting.setting_values.size() > 0 and modular_setting.setting_values.get(0) is String: line_edit.text = modular_setting.setting_values.get(0)
	if widget_params.has("text"): line_edit.text = widget_params.get("text")
	if widget_params.has("placeholder_text"): line_edit.placeholder_text = widget_params.get("placeholder_text")
	if widget_params.has("alignment"): line_edit.alignment = widget_params.get("alignment")
	if widget_params.has("max_length"): line_edit.max_length = widget_params.get("max_length")
	if widget_params.has("editable"): line_edit.editable = widget_params.get("editable")
	return OK


func _on_line_edit_text_changed(new_text: String) -> void:
	update_setting_value(new_text)


func _update_setting_value_from_external(new_value:Variant) -> void:
	if new_value is String: 
		line_edit.text = new_value
