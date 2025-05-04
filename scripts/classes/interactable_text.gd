extends Resource
class_name InteractableText

@export_multiline var text: String
@export_enum("population", "mana", "military", "resource", "morale") var revealedStat: Array[String]
