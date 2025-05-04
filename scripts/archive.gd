extends Control

class_name Archive

var archived_letters: Array = []
var current_index: int = 0

var current_letter_instance
var current_letter_resource: LetterResource
signal archive_closed

@onready var close_button: TextureButton = $CloseButton
@onready var previous_button: TextureButton = $PreviousButton
@onready var next_button: TextureButton = $NextButton
@onready var ui: Control = $UI

const LETTER = preload("res://scenes/Letter.tscn")
const MISC_LIT = preload("res://scenes/MiscLit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_button.pressed.connect(_on_previous_button_pressed)
	next_button.pressed.connect(_on_next_button_pressed)
	update_letter()
	print(archived_letters.size())
	print(current_index)

func load_letter_list(letter_resources: Array) -> void:
	archived_letters = letter_resources.duplicate(true)

func update_letter(slide_direction := 0) -> void:
	var prev_target
	var curr_target
	
	if slide_direction > 0:
		prev_target = - ui.size.x
		curr_target = ui.size.x
	else:
		prev_target = ui.size.x
		curr_target = - ui.size.x
	
	if current_letter_instance:
		var tween_out = create_tween()
		tween_out.tween_property(current_letter_instance, "position:x", prev_target, 0.7)
		tween_out.tween_interval(0.7)
		tween_out.tween_callback(current_letter_instance.queue_free)
			
	if not archived_letters:
		return
	
	var letter = archived_letters[current_index]
	print("current letter", letter)
	#var letter = load(letter_path) as LetterResource
	var close_button
	
	if letter is LetterResource:
		current_letter_instance = LETTER.instantiate() as Letter
		close_button = current_letter_instance.get_node("Letter/CloseButton")
		ui.add_child(current_letter_instance)
		current_letter_instance.generate_content(letter.season_generated, letter)
		
	else:
		current_letter_instance = MISC_LIT.instantiate()
		ui.add_child(current_letter_instance)
		current_letter_instance.setup(letter)
		close_button = current_letter_instance.get_node("CloseButton")
		
	if close_button:
		close_button.queue_free()
	
	current_letter_instance.position = Vector2(curr_target, 0)
	var tween_in = create_tween()
	tween_in.tween_property(current_letter_instance, "position", Vector2.ZERO, 0.7)
	update_arrows()

func update_arrows() -> void:
	previous_button.disabled = (current_index == 0)
	next_button.disabled = (current_index == archived_letters.size() - 1)

func _on_previous_button_pressed() -> void:
	if current_index > 0:
		current_index += -1
		update_letter(-1)
		
		print(current_index)
		print(current_letter_instance)

func _on_next_button_pressed() -> void:
	if current_index < archived_letters.size():
		current_index += 1
		update_letter(1)
		
		print(current_index)
		print(current_letter_instance)

func _on_close_button_pressed() -> void:
	archive_closed.emit()

func _on_close_button_mouse_entered() -> void:
	close_button.material.set_shader_parameter("enabled", true)
	close_button.size = close_button.size * 1.1

func _on_close_button_mouse_exited() -> void:
	close_button.material.set_shader_parameter("enabled", false)
	close_button.size = close_button.size / 1.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
