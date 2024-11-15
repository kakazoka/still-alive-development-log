extends Area2D


@export var bullet_speed := 400
@export var maximum_distance := 1000

@onready var bullet: AnimatedSprite2D = $BulletSprite

var bullet_velocity := Vector2.ZERO
var distance_traveled := 0
var damage := 0
var impact_occurred: bool


func _ready():
	impact_occurred = false


func _process(delta):
	if not impact_occurred:
		var bullet_movement = bullet_velocity * bullet_speed * delta
		position += bullet_movement
		distance_traveled += bullet_movement.length()
		if distance_traveled >= maximum_distance:
			queue_free()


func bullet_direction(target_position: Vector2):
	bullet_velocity = (target_position - position).normalized()


func set_damage(value: int):
	damage = value


func _on_area_entered(area):
	if area.is_in_group("ZombieHitbox"):
		impact_occurred = true
		bullet.play("BulletImpact")
		area.zombie_take_damage(damage)


func _on_bullet_sprite_animation_finished():
	if impact_occurred:
		queue_free()
