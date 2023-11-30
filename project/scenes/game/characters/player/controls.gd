class_name Controls extends Node
#here we can edit our controls without changing in script and / or project settings
var controls : Dictionary = {	
	#Basic movement	---------------------------------------------------------------
#	Script input : project settings input
	"move_left" : "move_left",		#a, left, and "left stick" left controller
	"move_right" : "move_right",	#d, right, and "left right" controller
	"move_up" : "up",				#w, up and "left stick up" controller 
	"move_down" : "down",			#s, down and "left stick down" controller 
	"jump" : "jump",				#space button and "A" button (xbox controller)
	
	"interact" : "interact",			#e and "B" button (xbox controller)
	"heal" : "heal",				#q and "Y"  button (xbox controller)
	"attack" : "attack",			#left click mouse and "X"  button (xbox controller)
	
	"special_1" : "special_1",		#ctrl and "Rb" button (xbox controller)
	"special_2" : "special_2",		#shift and "Lb" button (xbox controller)
	"special_3" : "special_3",		#right click mouse and "Lt" button (xbox controller)
	
	"basic_blast" : "attack",
	"magic_orb" : "special_1",
	"dark_sphere" : "spell_2",#dark sphere not unlocked yet / will work only in gravity mode
	
	"climb" : "special_2",
	"dash" : "special_3",
	"climb_up" : "up",
	"climb_down" : "down",
	
	"form_wheel" : "form_wheel",		#alt and "Rt" button (xbox controller)
#plus form wheel pressed	-----------------------
	"change_form_1" : "change_form_1",	#1 and "D-pad up" (xbox controller)
	"change_form_2" : "change_form_2",	#2 and "D-pad right" (xbox controller)
	"change_form_3" : "change_form_3",	#3 and "D-pad down" (xbox controller)
	"change_form_4" : "change_form_4",	#4 and "D-pad left" (xbox controller)
#--------------------------------------------------
	
#spells not implemented yet
	"spell_1" : "spell_1",				#1 and "D-pad up" (xbox controller)
	"spell_2" : "spell_2",				#1 and "D-pad right" (xbox controller)
	"spell_3" : "spell_3",				#1 and "D-pad down" (xbox controller)
	"spell_4" : "spell_4",				#1 and "D-pad left" (xbox controller)
}
