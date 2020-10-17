extends KinematicBody2D

const DeathEffect = preload("res://Scenes/Objects/EnemyDeathEffect.tscn")

var velocity = Vector2.ZERO

export var FRICTION = 200
export var ACCELERATION = 300
export var MAX_SPEED = 50

var knockback = Vector2.ZERO
var knockback_distance = 120

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

onready var stats = $Stats
onready var playerDetectZone = $PlayerDetectionZone

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO * FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectZone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(MAX_SPEED * direction, ACCELERATION * delta)
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectZone.can_see_player():
		state = CHASE


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * knockback_distance
	


func _on_Stats_no_health():
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	queue_free()
