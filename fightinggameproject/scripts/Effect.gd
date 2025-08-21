extends Area2D

@export_enum("stun", "slow", "damage_buff", "speed_buff") var effect_type: String
@export var effect_amount = 1

func _ready():
	add_to_group("effect")
