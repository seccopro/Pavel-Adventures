class_name Player
extends CharacterBody2D

@export var input_enabled: bool = true

@onready var canvas_group: CanvasGroup = %CanvasGroup
@onready var state_machine: StateMachine = %FSM_movement
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
		var direction: float = Input.get_axis("move_left", "move_right")
		var scale: Vector2 = Vector2(1, 1) if direction > 0 else Vector2(-1, 1)
		
		canvas_group.set_scale(scale)

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, delta)
	
	#if not input_enabled:
	#    return
	
	move_and_slide()

func disable() -> void:
	input_enabled = false
	animation_player.play("idle")

func enable() -> void:
	input_enabled = true
	visible = true
