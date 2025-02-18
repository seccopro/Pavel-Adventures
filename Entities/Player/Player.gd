class_name Player
extends CharacterBody2D

@export var input_enabled: bool = true

@onready var canvas_group: CanvasGroup = %CanvasGroup
@onready var state_machine: StateMachine = %FSM_movement
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree

var move_direction: Vector2
const SPEED: float = 100.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
		var direction: float = Input.get_axis("move_left", "move_right")
		var scale: Vector2 = Vector2(1, 1) if direction > 0 else Vector2(-1, 1)
		
		canvas_group.set_scale(scale)

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if not input_enabled:
		return
	
	#move_and_slide()

func disable() -> void:
	input_enabled = false
	animation_player.play("idle")

func enable() -> void:
	input_enabled = true
	visible = true
