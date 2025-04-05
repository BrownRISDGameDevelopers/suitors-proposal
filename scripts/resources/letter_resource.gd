extends Resource

class_name LetterResource

@export var is_proposal: bool;

@export_group("Letter")
@export_multiline var greeting: String;
@export_multiline var content: String;
@export_multiline var signoff: String;
