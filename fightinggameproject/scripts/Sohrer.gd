extends Warrior
class_name Sohrer

func _ready():
	super._ready()  

	name = "Sohrer"
	max_health = 1300
	health = max_health
	mana = 320
	attack_damage = 24   

	skill1_name = "Quick Slash"
	skill1_damage = 45
	skill1_mana = 12
	skill1_cooldown = 3.0
	skill1_effect = ""

	skill2_name = "Rage Unleashed"
	skill2_damage = 0
	skill2_mana = 50
	skill2_cooldown = 30.0
	skill2_effect = "rage_mode"

func _apply_skill_effect(effect: String, target: Player):
	if effect == "rage_mode":
		print("Rage mode activated! ")
		increase_damage(attack_damage * 3, 8.0) 
		increase_speed_attack(attack_speed* 1.5, 8.0)
	else:
		super._apply_skill_effect(effect, target)
