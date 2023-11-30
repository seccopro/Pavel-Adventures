extends Node

var penis = true

@export_group("Character Movement")
#walking state ---------------------------
@export var walking_velocity: float = 450
@export var walking_velocity_cap: float = 600

#air state --------------------------------
@export var jump_velocity: float = -800
@export var moving_velocity: float = 500
@export var double_jump_velocity: float = -750    #good amount, less than 700 doesn't work

#climbing state----------------------
@export var vertical_speed :float = 400

#input check----------
@export var dash_velocity: float = 1000

