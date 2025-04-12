extends TextureRect

@onready var panel = $Panel
@onready var tween = $Tween

func _ready():
	# Start with the panel below the screen
	var start_pos = Vector2((get_viewport().size.x - panel.size.x) / 2, get_viewport().size.y + 50)
	var target_pos = Vector2((get_viewport().size.x - panel.size.x) / 2, (get_viewport().size.y - panel.size.y) / 2)

	panel.position = start_pos

	# Animate to center
	tween.tween_property(panel, "position", target_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_Button_pressed():
	queue_free()
