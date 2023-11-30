class_name AttackState extends State

@onready var cd_timer = $attack_cooldown

var time_elapsed:float = 0.0

var attack_duration: float = .5

@export var basic_blast: Resource  = load("res://scenes/game/characters/player/attacks/basic_blast/basic_blast.tscn")
@export var basic_blast_cast_duration: float = 0.0	 #seconds
var basic_blast_is_on_cooldown: bool = false


func on_enter() -> void:
	print(CSM.previous_state)
	if basic_blast_is_on_cooldown:
		return
	
		#play attack animation	
	player.add_child(basic_blast.instantiate())
	cd_timer.start()
	basic_blast_is_on_cooldown = true
#		player.can_flip_sprite = false
#		$flipper_blocker_remover.start()


func state_input(event : InputEvent) -> void:
	input_check.permission_checker($".", event)

func state_process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed >= attack_duration:
		next_state = CSM.previous_state

func on_exit() -> void:
	cd_timer.stop()
	time_elapsed = 0.0
	
	CSM.previous_state = $"."


func _on_attack_cooldown_timeout():
	basic_blast_is_on_cooldown = false
