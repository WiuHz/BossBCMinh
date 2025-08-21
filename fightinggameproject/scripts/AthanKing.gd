extends Warrior
class_name AthanKing

func _ready():
	super._ready()
	
	name = "Athan King"
	max_health = 900      
	health = max_health
	mana = 350
	attack_damage = 21    

	skill1_name = "Blade Rush"
	skill1_damage = 60
	skill1_mana = 15
	skill1_cooldown = 4.0
	skill1_effect = "slow"     
	
	skill2_name = "King's Wrath"
	skill2_damage = 180
	skill2_mana = 60
	skill2_cooldown = 23.0
	skill2_effect = "speed_buff"
