extends Resource

class_name Kingdom

@export var name: String

@export_group("Stats")
@export_range(1, 6, 1) var population: int;
@export_range(1, 6, 1) var military: int;
@export_range(1, 6, 1) var morale: int;
@export_range(1, 6, 1) var resource: int;
@export_range(1, 6, 1) var mana: int;

@export_group("Known")
@export var populationKnown: bool = false;
@export var manaKnown: bool = false;
@export var militaryKnown: bool = false;
@export var resourceKnown: bool = false;
@export var moraleKnown: bool = false;
