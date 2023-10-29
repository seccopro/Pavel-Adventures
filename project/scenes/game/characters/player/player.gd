extends CharacterBody2D

@onready var state_machine : CharacterStateMachine = $"CharacterStateMachine"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # Get the gravity from the project settings to be synced with RigidBody nodes.

func _physics_process(delta):		#"MAIN" runs every delta time - CALLS ALL OTHER FUNCTIONS
	# Add the gravity.
	if not is_on_floor():	#gravity / falling
		velocity.y += gravity * delta
	#and activate physics
	move_and_slide()
	#camera controlling, zoom
	camera()

func camera():
	if(Input.is_action_just_pressed("camera_zoom_in")):
		print("zoom in")
		$"Camera2D".zoom.x += 0.5
		$"Camera2D".zoom.y += 0.5
	if(Input.is_action_just_pressed("camera_zoom_out")):
		print("zoom out")
		$"Camera2D".zoom.x -= 0.5
		$"Camera2D".zoom.y -= 0.5	
