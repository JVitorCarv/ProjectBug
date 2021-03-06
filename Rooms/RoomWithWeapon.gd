extends DungeonRoom

const WEAPONS: Array = [preload("res://Weapons/WarHammer.tscn"), preload("res://Weapons/BattleAxe.tscn"),
preload("res://Weapons/Book.tscn"), preload("res://Weapons/Crossbow.tscn")]

onready var weapon_pos: Position2D = get_node("WeaponPos")

func _ready() -> void:
	var weapon: Node2D = WEAPONS[randi() % WEAPONS.size()].instance()
	weapon.position = weapon_pos.position
	weapon.on_floor = true
	add_child(weapon) # Adds a random weapon
