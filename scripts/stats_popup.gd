extends VBoxContainer

class_name CountryPopup

@onready var suitorBox: TextureRect = $Suitor
@onready var header: Label = $Stats/Header
@onready var manaBar: TextureRect = $Stats/ManaBar
@onready var moraleBar: TextureRect = $Stats/MoraleBar
@onready var militaryBar: TextureRect = $Stats/MilitaryBar
@onready var resourceBar: TextureRect = $Stats/ResourceBar
@onready var populationBar: TextureRect = $Stats/PopulationBar

var stat_to_img = {
	1: preload("res://assets/map/stats_popup/1bar.png"),
	2: preload("res://assets/map/stats_popup/2bar.png"),
	3: preload("res://assets/map/stats_popup/3bar.png"),
	4: preload("res://assets/map/stats_popup/4bar.png"),
	5: preload("res://assets/map/stats_popup/5bar.png"),
	6: preload("res://assets/map/stats_popup/6bar.png")
}
var hidden_bar = preload("res://assets/map/stats_popup/hiddenbar.png")

@export var kingdom: Kingdom:
	set(value):
		update_stats(value)

@export var suitor: LetterResource:
	set(value):
		update_suitor(value)

var offset_x: bool = false
var offset_y: bool = false

func update_suitor(new_suitor: LetterResource):
	if not new_suitor:
		suitorBox.hide()
		return

	suitorBox.show()
	%SuitorName.text = new_suitor.name

# Called when the node enters the scene tree for the first time.
func update_stats(new_kingdom: Kingdom):
	print(new_kingdom)
	%Header.text = new_kingdom.name
	
	var bars = {
		"mana": {"node": manaBar, "value": new_kingdom.mana, "known": new_kingdom.manaKnown},
		"morale": {"node": moraleBar, "value": new_kingdom.morale, "known": new_kingdom.moraleKnown},
		"military": {"node": militaryBar, "value": new_kingdom.military, "known": new_kingdom.militaryKnown},
		"resource": {"node": resourceBar, "value": new_kingdom.resource, "known": new_kingdom.resourceKnown},
		"population": {"node": populationBar, "value": new_kingdom.population, "known": new_kingdom.populationKnown}
	}

	print(new_kingdom.name, " mana: ",
	new_kingdom.mana, " morale: ",
	new_kingdom.morale, " military: ",
	new_kingdom.military, " resource: ",
	new_kingdom.resource, " population: ",
	new_kingdom.population)
	
	for key in bars.keys():
		var data = bars[key]

		if data["node"]:
			if data["known"]:
				data["node"].texture = stat_to_img[data["value"]]
			else:
				data["node"].texture = hidden_bar

func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_parent().get_local_mouse_position()
	# offset
	var new_pos = mouse_pos - Vector2(0, size.y)
	
	if (size.y >= mouse_pos.y) or (offset_x):
		offset_x = true
		alignment = BoxContainer.ALIGNMENT_BEGIN
		new_pos += Vector2(0, size.y)
		
	if ((size.x + mouse_pos.x) >= get_parent().size.x) or (offset_y):
		offset_y = true
		new_pos -= Vector2(size.x, 0)
		
	position = new_pos


func _on_visibility_changed() -> void:
	if visible:
		set_process(true)
	else:
		set_process(false)
		alignment = BoxContainer.ALIGNMENT_END
		offset_x = false
		offset_y = false
