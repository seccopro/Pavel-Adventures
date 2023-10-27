extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimationPlayer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():                                   #basic gravity
		velocity.y += gravity * delta

	#jump logic (animation is timed with the movement of the jump)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():           
		velocity.y = JUMP_VELOCITY
		anim.play("jump_start")                             #plays one animation then loops the second                    
		anim.queue("fall_loop")
		
	#NEED TO IMPLEMENT "FALL LOOP" AFTER FALLING FROM GROUND (NO JUMP) AND "FALL END" AFTER "FALL LOOP"
	
	#movement logic
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == -1:
		$Sprite2D.flip_h = true
	elif direction == 1:
		$Sprite2D.flip_h = false
		
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			if anim.current_animation != ("run"):    #   <- FOR SOME REASON WORKS, COULD BE DONE BETTER
				anim.play("run_start")                        #player starts running and then loops the run animation
				anim.queue("run")
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*(delta*9))   #need to implement RUN_STOP 
		if velocity.y == 0:                                  #idle animation 
			anim.play("idle")
			#need to implement RUN_STOP 

	move_and_slide()
	
	if Game.PlayerHP <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")
		
	if self.position.y > 640:
		queue_free()
		get_tree().change_scene_to_file("res://main.tscn")
