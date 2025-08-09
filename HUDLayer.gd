extends Control

class_name HUDLayer

@export var active := true


func _ready() -> void:
	if active:
		_make_active()
	else:
		_make_inactive()


func activate() -> void:
	if active:
		print_debug("activate() on active HUDLayer")
	else:
		_make_active()


func deactivate() -> void:
	if !active:
		print_debug("deactivate() on inactive HUDLayer")
	else:
		_make_inactive()


func _make_active() -> void:
	active = true
	mouse_filter = MOUSE_FILTER_PASS
	show()


func _make_inactive():
	active = false
	mouse_filter = MOUSE_FILTER_IGNORE
	hide()
