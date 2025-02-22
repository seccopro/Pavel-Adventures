class_name Player
extends CharacterBody2D

@export var input_enabled: bool = true

@onready var canvas_group: CanvasGroup = %CanvasGroup
@onready var state_machine: StateMachine = %FSM_movement
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree

# TODO(pmerku): player.cfg
const WALK_SPEED: float = 300.0
const ACCELERATION_SPEED: float = WALK_SPEED * 6.0
const JUMP_VELOCITY: float = -400.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: float = 0.0

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
	velocity.y += gravity * delta

func apply_movement(delta: float) -> void:
	velocity.x = move_toward(velocity.x, direction, ACCELERATION_SPEED * delta)
