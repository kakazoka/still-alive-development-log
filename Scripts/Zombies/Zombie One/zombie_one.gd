extends CharacterBody2D


@export var speed := 150
@export var damage_amount := 10

@onready var zombie: AnimatedSprite2D = $ZombieOneSprite
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

var is_hit: bool
var is_dead: bool


func _ready():
	is_hit = false
	is_dead = false


func _physics_process(_delta):
	if player.is_dead and not is_dead:
		velocity = Vector2.ZERO
		zombie.play("Idle")
	elif not is_dead and not is_hit:
		velocity = Vector2.ZERO
		if player:
			velocity = position.direction_to(player.position) * speed
		move_and_slide()
		zombie.play("Run")


func zombie_hit():
	is_hit = true
	velocity = Vector2.ZERO
	zombie.play("Hit")
	zombie.frame = 0


func stop_movement():
	is_dead = true
	velocity = Vector2.ZERO


func _on_zombie_one_sprite_animation_finished():
	if zombie.animation == "Hit":
		is_hit = false
	elif zombie.animation == "Death":
		queue_free()
