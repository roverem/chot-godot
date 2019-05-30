extends KinematicBody2D

const MOVE_SPEED = 220
const JUMP_FORCE = 800
const GRAVITY = 50
const MAX_FALL_SPEED = 1000

onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

var y_velo = 0
var facing_right = false

var jumping = false
var wall_colliding = "None"

func _physics_process(delta):
	var move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	
	if jumping:
		move_dir *= 1.8
		
	if wall_colliding == "TileMap":
		move_dir = 0
	
	var collision = move_and_slide(Vector2(move_dir * MOVE_SPEED,y_velo), Vector2(0,-1))
	
	
	var grounded = is_on_floor()
	y_velo += GRAVITY
	
	if grounded:
		jumping = false
		wall_colliding = "None"
		
	
	if grounded and Input.is_action_pressed("jump"):
		y_velo = -JUMP_FORCE
		jumping = true
		
		
	if grounded and y_velo >= 5:
		y_velo = 5
		
	if y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED
		
		
	if facing_right and move_dir > 0:
		_flip()
	if !facing_right and move_dir < 0:
		_flip()
		
	if grounded:
		if move_dir == 0:
			play_anim("idle")
		else:
			play_anim("walk")
	else:
		play_anim("jump")
		
	
	if position.y > get_viewport_rect().size.y:
		position.y = -200
		
func _flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h
	
func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)
	
	
	
func _on_WallColliderRight_body_entered(body):
	print(body.name)
	wall_colliding = body.name


func _on_WallColliderLeft_body_entered(body):
	print(body.name)
	wall_colliding = body.name