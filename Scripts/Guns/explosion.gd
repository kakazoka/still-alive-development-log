extends Area2D


@export var explosion_speed := 400
@export var maximum_distance := 1000

@onready var explosion: AnimatedSprite2D = $ExplosionSprite

var explosion_velocity := Vector2.ZERO
var distance_traveled := 0
var damage := 0
var impact_occurred: bool


func _ready():
	impact_occurred = false


func _process(delta):
	if not impact_occurred:
		var explosion_movement = explosion_velocity * explosion_speed * delta
		position += explosion_movement
		distance_traveled += explosion_movement.length()
		if distance_traveled >= maximum_distance:
			queue_free()


func explosion_direction(target_position: Vector2):
	explosion_velocity = (target_position - position).normalized()


func set_damage(value: int):
	damage = value


func _on_area_entered(area):
	if area.is_in_group("ZombieHitbox"):
		impact_occurred = true
		explosion.play("ExplosionImpact")
		area.zombie_take_damage(damage)


func _on_explosion_sprite_animation_finished():
	if impact_occurred:
		queue_free()
