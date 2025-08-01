class_name GetCollision
extends Node2D

@export var Ship: CollisionShape2D
@export var RayCast: RayCast2D

func GetCollision(ShipCollision: bool, RayCastCollision: bool):
	assert(ShipCollision == true and RayCastCollision == true, "ERROR: Can't return both CollisionShapes at the same time!")
	assert(ShipCollision == null and RayCastCollision == null, "ERROR: Please pick a CollisionShape!") #Checking for Null values for both bools
	
	if RayCastCollision:
		return RayCast
	else:
		return Ship
