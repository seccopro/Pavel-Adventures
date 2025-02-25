class_name Player
extends CharacterBody2D

@export var player_stats: PlayerStats

@onready var canvas_group: CanvasGroup = %CanvasGroup
@onready var state_machine: StateMachine = %FSM_movement
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree

@onready var direction: float = 0.0
@onready var speed: float = player_stats.walk_speed

@onready var can_double_jump: bool = false

func _physics_process(delta: float) -> void:
	if not is_zero_approx(velocity.x):
			if velocity.x > 0.0:
				canvas_group.scale.x = 1.0
			else:
				canvas_group.scale.x = -1.0

func apply_physics(delta: float) -> void:
	apply_gravity(delta)
	apply_movement(delta)
	
	move_and_slide()

func apply_gravity(delta: float) -> void:
	velocity.y += player_stats.gravity * delta

func apply_movement(delta: float) -> void:
	speed = clamp(speed, -player_stats.horizontal_speed_cap, player_stats.horizontal_speed_cap)
	var acceleration: float = speed * player_stats.speed_multiplier
	velocity.x = move_toward(velocity.x, direction, acceleration * delta)
