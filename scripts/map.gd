extends TextureRect

class_name Map

signal suitor_chosen(suitor)

@export var mountains: Kingdom
@export var cloud: Kingdom
@export var forest: Kingdom
@export var water: Kingdom
@export var undead: Kingdom

@onready var KnightDwarf = $Mountain/KnightDwarf
@onready var CouncilwomanDwarf = $Mountain/CouncilwomanDwarf
@onready var BirdGuy = $Cloud/BirdGuy
@onready var Peacock = $Cloud/Peacock
@onready var Mushroom = $Forest/Mushroom
@onready var ForestLady = $Forest/ForestLady
@onready var Vampire = $Undead/Vampire
@onready var Skeleton = $Undead/Skeleton
@onready var WaterGuy = $Underwater/WaterGuy
@onready var WaterGirl = $Underwater/WaterGirl

func _on_knight_dwarf_pressed() -> void:
	suitor_chosen.emit(KnightDwarf.letter_resource)

func _on_councilwoman_dwarf_pressed() -> void:
	suitor_chosen.emit(CouncilwomanDwarf.letter_resource)

func _on_bird_guy_pressed() -> void:
	suitor_chosen.emit(BirdGuy.letter_resource)

func _on_peacock_pressed() -> void:
	suitor_chosen.emit(Peacock.letter_resource)

func _on_mushroom_pressed() -> void:
	suitor_chosen.emit(Mushroom.letter_resource)

func _on_forest_lady_pressed() -> void:
	suitor_chosen.emit(ForestLady.letter_resource)

func _on_vampire_pressed() -> void:
	suitor_chosen.emit(Vampire.letter_resource)

func _on_skeleton_pressed() -> void:
	suitor_chosen.emit(Skeleton.letter_resource)

func _on_water_guy_pressed() -> void:
	suitor_chosen.emit(WaterGuy.letter_resource)

func _on_water_girl_pressed() -> void:
	suitor_chosen.emit(WaterGirl.letter_resource)

func _suitor_chosen(suitor):
	suitor_chosen.emit(suitor)
