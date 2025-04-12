extends VBoxContainer

class_name CountryPopup

@export var kingdom: Kingdom

var bars: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func updateStats():
	for key in bars.keys():
		var data = bars[key]
		data["node"].visible = not data["known"]
		if data["known"]:
			data["node"].value = data["value"]

func _ready() -> void:
	hide()
	
	bars = {
		"mana": {"node": %ManaBar, "value": kingdom.mana, "known": kingdom.manaKnown},
		"morale": {"node": %MoraleBar, "value": kingdom.morale, "known": kingdom.moraleKnown},
		"military": {"node": %MilitaryBar, "value": kingdom.military, "known": kingdom.militaryKnown},
		"resource": {"node": %ResourceBar, "value": kingdom.resource, "known": kingdom.resourceKnown},
		"population": {"node": %PopulationBar, "value": kingdom.population, "known": kingdom.populationKnown}
	}
	
	%Header.text = kingdom.name
	updateStats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	# offset
	mouse_pos -= Vector2(0, size.y)
	
	print(mouse_pos)
	
	print(mouse_pos.y, size.y)
	
	if mouse_pos.y > size.y:
		mouse_pos += Vector2(0, 2 * size.y)
	
	position = mouse_pos
