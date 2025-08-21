extends CharacterBody2D
class_name BaseBoss

var max_health: int = 20000
var health: int = max_health
var damage: int = 500
var speed: int = 100

var target: Player = null
var skill_cooldown := 0.0
var skill_interval := 2.5   

func _ready():
	print("Boss appear:", self)

func _process(delta):
	if target == null:
		target = get_closest_player()
	
	if target:
		move_towards_target(delta)

	skill_cooldown -= delta
	if skill_cooldown <= 0:
		use_random_skill()
		skill_cooldown = skill_interval

# -------------------------
func get_closest_player() -> Player:
	var players = get_tree().get_nodes_in_group("Player")
	if players.is_empty():
		return null
	
	var closest = players[0]
	var min_dist = global_position.distance_to(players[0].global_position)

	for p in players:
		var d = global_position.distance_to(p.global_position)
		if d < min_dist:
			min_dist = d
			closest = p
	
	return closest

func move_towards_target(delta):
	var dir = (target.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()
	
func use_random_skill():
	print("Boss skill!")
