extends Area2D

@export_enum("health", "mana", "speed boost", "damage buff", "attack speed buff") var item_type: String 
@export var amount = 20

func _ready():
	add_to_group("item")
