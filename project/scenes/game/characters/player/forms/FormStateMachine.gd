class_name FormStateMachine extends Node

@export var current_form : Form

@export_group("Forms")
@export var no_form: Form
@export var rock_form: Form
@export var fire_form: Form
@export var gravity_form: Form
@export var ice_form: Form

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if !(child is Form):
			print("child isn't a form: " + str(child))
			return
		
		print("appended form: " + str(child))
		#load states
		child.no_form = no_form
		child.rock_form = rock_form
		child.fire_form = fire_form
		child.gravity_form = gravity_form
		child.ice_form = ice_form
		
func _physics_process(delta: float) -> void:
	#CHANGES FORM
	if current_form.next_form != null:
		switch_forms(current_form.next_form)

	#RUNS FORM
	current_form.form_process(delta)

func switch_forms(new_form: Form) -> void:
	if current_form == null:
		return

	current_form.on_exit()
	current_form.next_form = null
	
	current_form = new_form
	current_form.on_enter()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
