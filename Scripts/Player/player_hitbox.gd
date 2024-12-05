extends Area2D


@onready var player_script = get_parent()

var damage_interval := 1.0
var damage_timer = 0.0
var current_damage := 0
var is_zombie_in_area: bool


func _ready():
	player_script = get_parent()
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))


func _process(delta):
	if is_zombie_in_area:
		damage_timer -= delta
		if damage_timer <= 0:
			damage_timer = damage_interval
			player_script.player_take_damage(current_damage)


func _on_body_entered(body):
	if body.is_in_group("Zombie"):
		is_zombie_in_area = true
		current_damage = body.damage_amount
		damage_timer = 0


func _on_body_exited(body):
	if body.is_in_group("Zombie"):
		is_zombie_in_area = false
		current_damage = 0
