extends CharacterBody2D
class_name Player

var max_health: int
var health: int
var mana: int
var speed: int
var attack_damage: int  
var attack_speed: int
var attack_range:float
var attack_type: String
var nearby_items: Array[Area2D] = []
var my_items: Array[Area2D] = []
var damage_buff: int = 0
var speed_buff: int = 0
var attack_speed_buff: int = 0

var skill1_name: String
var skill1_damage: int
var skill1_mana: int
var skill1_cooldown: float
var skill1_ready: bool = true 
var skill1_effect: String = ""
@onready var skill1_timer := Timer.new()

var skill2_name: String 
var skill2_damage: int 
var skill2_mana: int
var skill2_cooldown: float 
var skill2_ready: bool = true
var skill2_effect: String = ""
@onready var skill2_timer := Timer.new()

@onready var damage_timer := Timer.new()
@onready var speed_timer := Timer.new()
@onready var attack_speed_timer := Timer.new()

func _ready():
	add_child(damage_timer)
	damage_timer.one_shot = true
	damage_timer.connect("timeout", Callable(self, "_on_damage_buff_timeout"))
	
	add_child(speed_timer)
	speed_timer.one_shot = true
	speed_timer.connect("timeout", Callable(self, "_on_speed_buff_timeout"))
	
	add_child(attack_speed_timer)
	attack_speed_timer.one_shot = true
	attack_speed_timer.connect("timeout", Callable(self, "_on_attack_speed_buff_timeout"))
	
	add_child(skill1_timer)
	skill1_timer.one_shot = true 
	skill1_timer.connect("timeout", Callable(self, "_on_skill1_timer_timeout"))
	
	add_child(skill2_timer)
	skill2_timer.one_shot
	skill2_timer.connect("timeout", Callable(self, "_on_skill2_timer_timeout"))
	

func _movement(delta):
	var direct = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		direct.y += 1 
	if Input.is_action_pressed("ui_down"):
		direct.y -= 1
	if Input.is_action_pressed("ui_left"):
		direct.x -= 1
	if Input.is_action_pressed("ui_right"):
		direct.x += 1 
		
	velocity = direct.normalized() *speed 
	move_and_slide()
	
func increase_health(amount: int):
	if health > max_health: 
		return("HP is full!")
		
	var before = health
	health = min(health + amount, max_health)
	var healed = health - before
	
	print("+ ", healed, " HP!")
	
func increase_mana(amount: int):
	mana += amount 
	print("+ ", amount, " Mana!")

func increase_speed(amount: int, duration: float = 30.0):
	speed_buff += amount*3
	speed += speed_buff
	print("Speed +", amount, "for", duration, "seconds")
	speed_timer.start(duration)

func _on_speed_buff_timeout():
	print("Speed buff expired.")
	speed -= speed_buff
	speed_buff = 0
	
func increase_damage(amount: int, duration: float = 30.0):
	damage_buff += amount*1.5
	attack_damage += damage_buff
	print("Damage +", amount*1,5, "for", duration, "seconds")
	damage_timer.start(duration)
	
func _on_damage_buff_timeout():
	print("Damage buff expired.")
	attack_damage -= damage_buff
	damage_buff = 0
	
func increase_speed_attack(amount: int, duration: float = 30.0):
	attack_speed_buff += amount*2
	attack_speed += attack_speed_buff 
	print("Damage speed +", amount*2, "for", duration, "seconds")
	attack_speed_timer.start(duration)
		
func _on_attack_speed_buff():
	print("Attack speed buff expired.")
	attack_speed -= attack_speed_buff
	attack_speed_buff = 0
	
	
func _apply_item(item: Area2D):
	match item.item_type:
		"health":
			increase_health(item.amount)
		"mana":
			increase_mana(item.amount)
		"speed boost":
			increase_speed(item.amount, 30.0)
		"damage buff":
			increase_damage(item.amount, 30.0)
		"attack speed buff":
			increase_speed_attack(item.amount, 30.0)
		_ :
			pass 
				
func _try_pick_up(delta):
	for item in nearby_items:
		if item and item.is_inside_tree():
			_apply_item(item)
			my_items.append(item)
			item.free_queue()
	nearby_items.clear()
			
func _on_item_area_entered(area):
	if area.is_in_group("item") and not nearby_items.has(area):
		nearby_items.append(area)

func _on_item_area_exited(area):
	if nearby_items.has(area):
		nearby_items.erase(area)

func normal_attack(target: Player):
	if target and target.health > 0:
		print(attack_damage, "damages!")
		target.take_damage(attack_damage)
		
func stun(duration: float):
	print("Stun!")
	speed = 0
	$TimerStun.start(duration)

func slow(duration: float):
	print("Slow!")
	speed *= 0.6
	$TimerSlow.start(duration)

func _apply_skill_effect(effect: String, target: Player):
	match effect:
		"stun":
			target.stun(3.0)
		"slow":
			target.slow(3.0)
		"damage_buff":
			increase_damage(30, 5.0)
		"speed_buff":
			increase_speed(30, 5.0)
		
func use_skill1(target: Player):
	if not skill1_timer.time_left > 0: 
		print("Skill is cooldown!")
		return 
		
	if mana < skill1_mana:
		print("Not enough mana!")
		
	if target and target.health > 0: 
		print(target.health)
	mana -= skill1_mana
	target.take_damage(skill1_damage)
	_apply_skill_effect(skill1_effect, target)
	skill1_timer.start(skill1_cooldown)
		
func use_skill2(target: Player):
	if not skill2_timer.time_left > 0:
		print("Skill is cooldown!")
		return 
		
	if mana < skill2_mana:
		print("Not enough mana!")
		
	if target and target.health > 0:
		print(target.health)
	mana -= skill2_mana
	target.take_damage(skill2_damage)
	_apply_skill_effect(skill2_effect, target)
	skill2_timer.start(skill2_cooldown)
		
		
func take_damage(amount):
	health -= amount 
	if health < 0:
		health = 0
		print("You died!")
		
func key_pick_up(event): 
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_I:
			_try_pick_up(event) 
			
func key_normal_attack(event, target: Player):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_U:
			normal_attack(target)
		
func key_use_skill1(event, target: Player, effect_amount: int):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_O:
			use_skill1(target)
			
func key_use_skill2(event, target: Player, skill2_effect: String):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_P:
			use_skill2(target)
			

			
