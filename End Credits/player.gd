extends KinematicBody2D

var _velocity = Vector2()
export var speed = Vector2(150.0, 350.0)
var _gravity = 1500.0
export var dead = false

func _physics_process(delta):
	_velocity.y += _gravity * delta
	var direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(_velocity, snap, Vector2.UP, true)

func get_direction():
	if dead:
		return Vector2()
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-Input.get_action_strength("ui_up") if is_on_floor() and Input.is_action_pressed("ui_up") else 0.0
	)

func calculate_move_velocity(linear_velocity, direction, move_speed):
	var velocity = linear_velocity
	velocity.x = move_speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = move_speed.y * direction.y
	return velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if dead:
		$AnimatedSprite.play("off")
	elif Input.is_action_pressed("ui_right"):
		$AnimatedSprite.play("walk" if is_on_floor() else "fly")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		$AnimatedSprite.play("walk" if is_on_floor() else "fly")
		$AnimatedSprite.flip_h = true
	elif Input.is_action_pressed("ui_up"):
		$AnimatedSprite.play("fly")
	else:
		$AnimatedSprite.play("idle" if is_on_floor() else "fly")
		
