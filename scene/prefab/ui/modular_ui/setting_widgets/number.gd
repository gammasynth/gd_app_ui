extends SettingWidget

@onready var spin_box: SpinBox = $SpinBox

func _widget_setup() -> Error:
	setup_spin_box_widget(spin_box)
	return OK


func _on_spin_box_value_changed(value: float) -> void:
	update_setting_value(value)
