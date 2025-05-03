extends TextureRect
signal suitor_chosen(suitor)

func _on_knight_dwarf_pressed() -> void:
	_suitor_chosen(1)
func _on_councilwoman_dwarf_pressed() -> void:
	_suitor_chosen(1)
func _on_bird_guy_pressed() -> void:
	_suitor_chosen(1)
func _on_peacock_pressed() -> void:
	_suitor_chosen(1)
func _on_mushroom_pressed() -> void:
	_suitor_chosen(1)
func _on_forest_lady_pressed() -> void:
	_suitor_chosen(1)
func _on_vampire_pressed() -> void:
	_suitor_chosen(1)
func _on_skeleton_pressed() -> void:
	_suitor_chosen(1)
func _on_water_guy_pressed() -> void:
	_suitor_chosen(1)
func _on_water_girl_pressed() -> void:
	_suitor_chosen(1)

func _suitor_chosen(suitor):
	suitor_chosen.emit(suitor)
