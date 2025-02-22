class_name PlayerStats
extends Resource

@export_group("Movement")

@export_subgroup("Moving")
@export var walk_speed: float = 300.0
@export var run_speed: float = 500.0
@export var speed_multiplier: float = 6.0

@export_subgroup("Jumping")
@export var jump_velocity: float = -600.0
@export_range(0.0, 1.0) var jump_deceleration: float = 0.6

@export_group("Physics")
@export var gravity: float = 980.0
