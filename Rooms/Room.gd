extends Node2D
class_name DungeonRoom

export(bool) var boss_room: bool = false

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://Characters/Enemies/SpawnExplosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"FLYING_CREATURE": preload("res://Characters/Enemies/Flying Creature/FlyingCreature.tscn"),
	"GOBLIN": preload("res://Characters/Enemies/Goblin/Goblin.tscn"),
	"ZOMBIE": preload("res://Characters/Enemies/Zombie/Zombie.tscn"),
	"NECROMANCER": preload("res://Characters/Enemies/Necromancer/Necromancer.tscn"),
	"TANK": preload("res://Characters/Enemies/Tank/Tank.tscn"),
	"BOSS": preload("res://Characters/Enemies/Bosses/Boss.tscn"),
}

var num_enemies: int

onready var tilemap: TileMap = get_node("TileMap2")
onready var entrance: Node2D = get_node("Entrance")
onready var door_container: Node2D = get_node("Doors")
onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
onready var player_detector: Area2D = get_node("PlayerDetector")


func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count()
	if num_enemies == 1:
		$BossSong.play()

func _on_enemy_killed() -> void:
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()


func _open_doors() -> void:
	for door in door_container.get_children():
		door.open()

func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position), 1)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position) + Vector2.DOWN, 2)

func _spawn_enemies() -> void:
	for enemy_position in enemy_positions_container.get_children():
		var enemy: KinematicBody2D
		if boss_room:
			enemy = ENEMY_SCENES.BOSS.instance()
			num_enemies = 15
		else:
			var random_value: int = randi() % 19
			if random_value == 0 or random_value == 1:
				enemy = ENEMY_SCENES.NECROMANCER.instance()
			elif random_value == 2 or random_value == 3 or random_value == 4:
				enemy = ENEMY_SCENES.TANK.instance()
			elif random_value == 5 or random_value == 6 or random_value == 7 or random_value == 8:
				enemy = ENEMY_SCENES.GOBLIN.instance()
			elif random_value == 9 or random_value == 10 or random_value == 11 or random_value == 12 or random_value == 13:
				enemy = ENEMY_SCENES.ZOMBIE.instance()
			else:
				enemy = ENEMY_SCENES.FLYING_CREATURE.instance()

		enemy.position = enemy_position.position
		call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite = SPAWN_EXPLOSION_SCENE.instance()
		spawn_explosion.position = enemy_position.position
		call_deferred("add_child", spawn_explosion)


func _on_PlayerDetector_body_entered(_body: KinematicBody2D) -> void:
	player_detector.queue_free()
	if num_enemies > 0:
		_close_entrance()
		_spawn_enemies()
	else:
		_close_entrance()
		_open_doors()
