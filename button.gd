extends Button  # This script extends the Button node

# Called when the button is pressed
func _on_button_pressed():
	print("Button clicked!")

# Connects the button's pressed signal when the script is ready
func _ready():
	connect("pressed", Callable(self, "_on_button_pressed"))
