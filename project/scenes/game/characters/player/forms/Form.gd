class_name Form extends Node

#Masks - forms
var no_form: Form
var rock_form: Form
var fire_form: Form
var gravity_form: Form
var ice_form: Form

@export_group("Behaviour Flags")
@export var passive : String
@export var special_1 : String
@export var special_2 : String
@export var special_3 : String

var next_form : Form

func on_enter() -> void:
	pass

func form_process(delta: float) -> void:
	pass

func form_input(event: InputEvent) -> void:
	pass

func on_exit() -> void:
	pass
