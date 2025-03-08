extends Node

# randomized player data 
var player_data = {
	"population": randi() % 6 + 1,
	"military": randi() % 6 + 1,
	"resources": randi() % 6 + 1,
	"mana": randi() % 6 + 1,
	"morale": randi() % 4 + 1
}

func get_player_data(key: String) -> int:
	return player_data.get(key, 0) 

func set_player_data(key: String, value: int) -> void:
	if player_data.has(key):
		player_data[key] = value
	else:
		print("Key not found")

# Create a dictionary to hold data for all kingdoms
var kingdoms_data = {
	"underwater": {
		"population": 4,
		"military": 1,
		"resources": 2,
		"mana": 6,
		"morale": 3
	},
	"mountain": {
		"population": 2,
		"military": 3,
		"resources": 6,
		"mana": 2,
		"morale": 4
	},
	"undead": {
		"population": 6,
		"military": 5,
		"resources": 2,
		"mana": 1,
		"morale": 2
	},
	"forest": {
		"population": 1,
		"military": 2,
		"resources": 3,
		"mana": 4,
		"morale": 6
	},
	"cloud": {
		"population": 2,
		"military": 4,
		"resources": 5,
		"mana": 3,
		"morale": 3
	}
}

# Method to get kingdom data
func get_kingdom_data(kingdom: String, key: String) -> int:
	return kingdoms_data.get(kingdom, {}).get(key, 0)  # returns 0 if kingdom or key doesn't exist

# Method to set kingdom data
func set_kingdom_data(kingdom: String, key: String, value: int) -> void:
	if kingdoms_data.has(kingdom):
		kingdoms_data[kingdom][key] = value
	else:
		print("Kingdom not found")

func calculateEnding(kingdom: String) -> int: return 
