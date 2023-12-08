Welcome to the assets use and create tutorial:

	USAGE:
		To use an asset, simply drag and drop that asset scene into your level and assign its exports;
			e.g: ruin_assets/interactable/ruin_door_1.tscn just drop it in the level, then click on it, and open the inspector.
				in the inspector you will see a field named "Next Scene", you should input the scene that the player will reach,
				by going trought the door.
				
			Same goes for any asset, just be sure to assign the exports properly!
			
		DRAG AND DROP ONLY APPLIES TO AREA-SPECIFIC ASSETS, not common ones, as they are used to craft new assets, as shown below.

	CREATING:
		To create a new area-specific asset, you will need to create a new scene, containing a 2DNode, carrying the asset name.
		Then add the desired sprites; as many as needed.
		After that, just add that asset-type common asset; 
			e.g. If you're creating a new lever, just add in the lever common asset: res://assets/common/interactable/lever_area
		Finally attach that asset script ( found in: res://scripts/common ) on the main node; the one carrying the asset name.
	
		Now SAVE the asset in the correct folder named in snake_case.
	
		Congratulations, you created a new asset!!
			To use it, please refer to the USAGE paragraph found above.

Good luck and have fun creating our new world! 
	-Duplo
