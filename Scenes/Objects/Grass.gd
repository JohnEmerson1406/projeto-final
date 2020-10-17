extends Node2D

const GrassEffect = preload("res://Scenes/Objects/GrassEffect.tscn")

func enable_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position


func _on_Hurtbox_area_entered(area):
	enable_grass_effect()
	queue_free()
