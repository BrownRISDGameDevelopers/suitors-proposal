extends VBoxContainer

class_name CountryPopup

@export var kingdom: Kingdom:
	set(value):
		updateStats(value)

var offset_x: bool = false
var offset_y: bool = false

# Called when the node enters the scene tree for the first time.
func updateStats(new_kingdom: Kingdom):
	%Header.text = new_kingdom.name
	
	var bars = {
		"mana": {"node": %ManaBar, "value": new_kingdom.mana, "known": new_kingdom.manaKnown},
		"morale": {"node": %MoraleBar, "value": new_kingdom.morale, "known": new_kingdom.moraleKnown},
		"military": {"node": %MilitaryBar, "value": new_kingdom.military, "known": new_kingdom.militaryKnown},
		"resource": {"node": %ResourceBar, "value": new_kingdom.resource, "known": new_kingdom.resourceKnown},
		"population": {"node": %PopulationBar, "value": new_kingdom.population, "known": new_kingdom.populationKnown}
	}
	
	for key in bars.keys():
		var data = bars[key]
		data["node"].visible = not data["known"]
		if data["known"]:
			data["node"].value = data["value"]

func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	# offset
	var new_pos = mouse_pos - Vector2(0, size.y)
	
	if (size.y >= mouse_pos.y) or (offset_x):
		offset_x = true
		new_pos += Vector2(0, size.y)
		
	if ((size.x + mouse_pos.x) >= get_viewport_rect().size.x) or (offset_y):
		offset_y = true
		new_pos -= Vector2(size.x, 0)
		
	position = new_pos


func _on_visibility_changed() -> void:
	if visible:
		set_process(true)
	else	:
		set_process(false)
		offset_x = false
		offset_y = false
