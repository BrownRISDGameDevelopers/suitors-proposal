extends Resource

class_name LetterResource

@export_category("Suitor")
@export var kingdom: Kingdom
@export var portrait: Texture

@export_group("Letter")
@export_multiline var greeting: String
@export_multiline var signoff: String

@export_group("Seasonal Content")
@export_multiline var summerVersion: String
@export var summerClickableContent: Array[InteractableText]
@export_multiline var fallVersion: String
@export var fallClickableContent: Array[InteractableText]
@export_multiline var winterVersion: String
@export var winterClickableContent: Array[InteractableText]
@export_multiline var springVersion: String
@export var springClickableContent: Array[InteractableText]

@export_group("Content Generated")
@export_enum("summer", "fall", "winter", "spring") var season_generated: String
