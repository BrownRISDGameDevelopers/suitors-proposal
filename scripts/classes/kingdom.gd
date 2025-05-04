extends Resource

class_name Kingdom

@export var name: String

@export_group("Letter")
@export var letter_border: Texture
@export var theme: Theme

@export_group("Stats")
@export_range(0, 6) var population: int = 0;
@export_range(0, 6) var military: int = 0;
@export_range(0, 6) var morale: int = 0;
@export_range(0, 6) var resource: int = 0;
@export_range(0, 6) var mana: int = 0;

@export_group("Known")
@export var populationKnown: bool = false
@export var manaKnown: bool = false
@export var militaryKnown: bool = false
@export var resourceKnown: bool = false
@export var moraleKnown: bool = false
