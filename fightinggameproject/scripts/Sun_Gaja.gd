extends Warrior
class_name Sun_Gaja

func _ready():
	super._ready()

	name = "Sun_Gaja"
	max_health = 1200   
	health = max_health
	mana = 400
	attack_damage = 100  

	skill1_name = "Ultra Flash!"
	skill1_damage = 80
	skill1_mana = 20
	skill1_cooldown = 5.0
	skill1_effect = "speed_buff"  

	skill2_name = "Solar Storm Sword!"
	skill2_damage = 300
	skill2_mana = 80
	skill2_cooldown = 30.0
	skill2_effect = "damage_buff"  
