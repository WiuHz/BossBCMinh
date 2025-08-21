extends BaseBoss
class_name DestructionBeast 

func _ready():
	max_health = 40000
	health = max_health
	damage = 800
	speed = 150
	print("Destruction Beast appeared!")

func skill_bite():
	print("Fatal Bite!")
	if target:
		target.take_damage(target.max_health / 4)  

func skill_roar():
	print("Stunning Roar!")
	var players = get_tree().get_nodes_in_group("Player")
	for p in players:
		if global_position.distance_to(p.global_position) < 700:
			p.apply_status("stun", 4.0)

func use_random_skill():
	if randi() % 2 == 0:
		skill_bite()
	else:
		skill_roar()
