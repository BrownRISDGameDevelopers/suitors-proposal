extends Button  # This script extends the Button node

var i = 0

# Called when the button is pressed
func _on_button_pressed():
	i += 1
	print("Button clicked! %d" % i)

# Connects the button's pressed signal when the script is ready
func _ready():
	connect("pressed", Callable(self, "_on_button_pressed"))
