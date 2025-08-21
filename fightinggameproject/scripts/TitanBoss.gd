extends BaseBoss
class_name TitanBoss

func _ready():
	max_health = 50000
	health = max_health
	damage = 600
	speed = 80
	print("Titan Appeared!")

func skill_ground_slam():
	print("Titan Destroyed!")
	var players = get_tree().get_nodes_in_group("Player")
	for p in players:
		if global_position.distance_to(p.global_position) < 500:
			p.take_damage(damage * 2)
			p.apply_status("stun", 3.0)

func skill_regeneration():
	print("Titan Healing!")
	health = min(max_health, health + 2000)
	
func use_random_skill():
	if randi() % 2 == 0:
		skill_ground_slam()
	else:
		skill_regeneration()
