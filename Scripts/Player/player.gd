extends CharacterBody2D


@export var health := 100
@export var speed := 200
@export var bullet_scene: PackedScene
@export var explosion_scene: PackedScene

@onready var player: AnimatedSprite2D = $PlayerSprite
@onready var camera: Camera2D = $PlayerCamera
@onready var guns = {
	"pistol": $Guns/Pistol,
	"revolver": $Guns/Revolver,
	"pump": $Guns/Pump,
	"rifle": $Guns/Rifle,
	"sniper": $Guns/Sniper,
	"rocket_launcher": $Guns/RocketLauncher
}

var equipped_gun: String = "pistol"
var is_dead: bool
var can_shoot: bool
var gun_damage = {
	"pistol": 10,
	"revolver": 20,
	"pump": 30,
	"rifle": 25,
	"sniper": 50,
	"rocket_launcher": 100
}


func _ready():
	for gun in guns.values():
		gun.visible = false
	guns[equipped_gun].visible = true
	is_dead = false
	can_shoot = true


func _process(_delta):
	if is_dead:
		return
	var mouse_position = get_global_mouse_position()
	update_player_animation()
	flip_player_sprite(mouse_position)
	update_gun_direction(mouse_position)
	if get_tree().current_scene.name == "Base":
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		for gun in guns.values():
			gun.visible = false
	else:
		for gun in guns.values():
			gun.visible = gun == guns[equipped_gun]
		if Input.is_action_pressed("Shoot") and can_shoot:
			shoot()


func _physics_process(_delta):
	if is_dead:
		velocity = Vector2.ZERO
		return
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	move_and_slide()


func update_player_animation():
	if Input.get_vector("Left", "Right", "Up", "Down"):
		player.play("Run")
	else:
		player.play("Idle")


func flip_player_sprite(mouse_position):
	player.flip_h = mouse_position.x > global_position.x


func update_gun_direction(mouse_position):
	var gun = guns[equipped_gun]
	gun.visible = true
	var mouse_direction = (mouse_position - gun.global_position).normalized()
	gun.rotation_degrees = rad_to_deg(atan2(mouse_direction.y, mouse_direction.x))
	gun.look_at(mouse_position)
	gun.scale.y = 1 if mouse_position.x > global_position.x else -1
	if Input.is_action_pressed("Shoot"):
		gun.play("Shoot")


func shoot():
	if can_shoot:
		can_shoot = false
		if not equipped_gun == "rocket_launcher":
			instantiate_bullet(gun_damage[equipped_gun])
		else:
			instantiate_explosion(gun_damage[equipped_gun])


func instantiate_bullet(damage: int):
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	get_parent().add_child(bullet)
	bullet.bullet_direction(get_global_mouse_position())
	bullet.set_damage(damage)


func instantiate_explosion(damage: int):
	var explosion = explosion_scene.instantiate()
	explosion.position = global_position
	get_parent().add_child(explosion)
	explosion.explosion_direction(get_global_mouse_position())
	explosion.set_damage(damage)


func _on_pistol_animation_finished():
	can_shoot = true


func _on_revolver_animation_finished():
	can_shoot = true


func _on_pump_animation_finished():
	can_shoot = true


func _on_rifle_animation_finished():
	can_shoot = true


func _on_sniper_animation_finished():
	can_shoot = true


func _on_rocket_launcher_animation_finished():
	can_shoot = true


func player_take_damage(amount: int):
	if health > 0:
		health -= amount
		player.stop()
		player.play("Hit")
		if health <= 0:
			die()


func die():
	is_dead = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	for gun in guns.values():
		gun.visible = false
	player.play("Death")
