extends TextureRect
signal suitor_chosen(suitor)

@export var mountains: Kingdom = null
@export var cloud: Kingdom = null
@export var forest: Kingdom = null
@export var water: Kingdom = null
@export var undead: Kingdom = null

func _on_knight_dwarf_pressed() -> void:
	_suitor_chosen(1, mountains)
func _on_councilwoman_dwarf_pressed() -> void:
	_suitor_chosen(2, mountains)
func _on_bird_guy_pressed() -> void:
	_suitor_chosen(1, cloud)
func _on_peacock_pressed() -> void:
	_suitor_chosen(2, cloud)
func _on_mushroom_pressed() -> void:
	_suitor_chosen(1, forest)
func _on_forest_lady_pressed() -> void:
	_suitor_chosen(2, forest)
func _on_vampire_pressed() -> void:
	_suitor_chosen(1, undead)
func _on_skeleton_pressed() -> void:
	_suitor_chosen(2, undead)
func _on_water_guy_pressed() -> void:
	_suitor_chosen(1, water)
func _on_water_girl_pressed() -> void:
	_suitor_chosen(2, water)

func _suitor_chosen(suitor, kingdom):
	suitor_chosen.emit(suitor, kingdom)
