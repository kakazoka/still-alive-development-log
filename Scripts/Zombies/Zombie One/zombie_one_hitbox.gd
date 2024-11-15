extends Area2D


@export var health := 15

@onready var zombie: AnimatedSprite2D = get_parent().get_node("ZombieOneSprite")
@onready var zombie_script = get_parent()


func zombie_take_damage(amount: int):
	if health > 0:
		health -= amount
		zombie_script.zombie_hit()
		if health <= 0:
			die()

func die():
	zombie_script.stop_movement()
	zombie.play("Death")
