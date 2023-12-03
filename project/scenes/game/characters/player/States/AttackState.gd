class_name AttackState extends State

@onready var attack_cooldown = $attack_cooldown

var time_elapsed:float = 0.0

var attack_duration: float = 0.25

@export var basic_blast: Resource  = load("res://scenes/game/characters/player/attacks/basic_blast/basic_blast.tscn")
@export var basic_blast_cast_duration: float = 0.0	 #seconds
var basic_blast_is_on_cooldown: bool = false


func on_enter() -> void:
	if basic_blast_is_on_cooldown:
		print("attack on cd")
		return
	
		#play attack animation	
	player.add_child(basic_blast.instantiate())	
	basic_blast_is_on_cooldown = true
	attack_cooldown.start()
#		player.can_flip_sprite = false
#		$flipper_blocker_remover.start()


func state_input(event : InputEvent) -> void:
	input_check.permission_checker($".", event)

func state_process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed >= attack_duration:
		next_state = CSM.previous_state

func on_exit() -> void:
	time_elapsed = 0.0	
	CSM.previous_state = $"."


func _on_attack_cooldown_timeout():
	print("basic blast off cooldown")
	basic_blast_is_on_cooldown = false
