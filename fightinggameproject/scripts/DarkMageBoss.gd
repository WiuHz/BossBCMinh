extends BaseBoss
class_name DarkMageBoss

func _ready():
	max_health = 30000
	health = max_health
	damage = 500
	speed = 90
	print("Dark Mage Boss appeared!")

func skill_firestorm():
	print("Flame Balls!")
	var players = get_tree().get_nodes_in_group("Player")
	for p in players:
		if global_position.distance_to(p.global_position) < 600:
			p.take_damage(damage * 3)

func skill_dark_aura():
	print("Dark Slow Aura!")
	var players = get_tree().get_nodes_in_group("Player")
	for p in players:
		p.apply_status("slow", 5.0)
		
func use_random_skill():
	if randi() % 2 == 0:
		skill_firestorm()
	else:
		skill_dark_aura()
