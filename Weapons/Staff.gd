extends Weapon

const STAFF_SPELL_SCENE: PackedScene = preload("res://Weapons/StaffSpell.tscn")


func shoot(offset: int) -> void:
	var spell: Area2D = STAFF_SPELL_SCENE.instance()
	get_tree().current_scene.add_child(spell)
	spell.launch(global_position, Vector2.RIGHT.rotated(deg2rad(rotation_degrees + offset)), 200)

func triple_shoot() -> void:
	shoot(0)
	shoot(10)
	shoot(-10)
	# This
