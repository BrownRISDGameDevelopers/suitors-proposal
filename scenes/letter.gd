extends TextureRect

@onready var panel = $Panel
@onready var greeting: Label = $MarginContainer/VBoxContainer/Greeting
@onready var content: RichTextLabel = $MarginContainer/VBoxContainer/Content
@onready var signoff: Label = $MarginContainer/VBoxContainer/Signoff
const LETTER_1 = preload("res://resources/letters/Letter1.tres")
func _ready():
	generate_content("spring", LETTER_1)

func generate_content(season: String, letter_resource: LetterResource) -> void:
	
	if letter_resource.is_proposal:
		if season == "summer":
			greeting.text = letter_resource.greeting
			content.text = letter_resource.summerVersion
			signoff.text = letter_resource.signoff
			
		elif season == "fall":
			greeting.text = letter_resource.greeting
			content.text = letter_resource.fallVersion
			signoff.text = letter_resource.signoff
			
		elif season == "winter":
			greeting.text = letter_resource.greeting
			content.text = letter_resource.winterVersion
			signoff.text = letter_resource.signoff
			
		elif season == "spring":
			greeting.text = letter_resource.greeting
			content.text = letter_resource.springVersion
			signoff.text = letter_resource.signoff
			
	else:
		greeting.text = letter_resource.greeting
		content.text = letter_resource.regularContent
		signoff.text = letter_resource.signoff
		
