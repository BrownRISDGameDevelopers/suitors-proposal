extends Resource

class_name LetterResource

@export var is_proposal: bool;

@export_group("Letter")
@export_multiline var greeting: String;
@export_multiline var content: String;
@export_multiline var signoff: String;

@export_group("Seasonal Content")
@export_multiline var summerVersion: String
@export_multiline var fallVersion: String
@export_multiline var winterVersion: String
@export_multiline var springVersion: String
