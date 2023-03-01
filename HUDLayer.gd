extends Control

class_name HUDLayer

export var active: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if active:
		_make_active()
	else:
		_make_inactive()

func activate():
	if active:
		print_debug("activate() on active HUDLayer")
	else:
		_make_active()


func deactivate():
	if !active:
		print_debug("deactivate() on inactive HUDLayer")
	else:
		_make_inactive()


func _make_active():
	print_debug("become active")
	active = true
	mouse_filter = MOUSE_FILTER_PASS
	show()


func _make_inactive():
	print_debug("become inactive")
	active = false
	mouse_filter = MOUSE_FILTER_IGNORE
	hide()
