extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var mouse_x = 0
var mouse_y = 0

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("右"):
		velocity.x += 1
	if Input.is_action_pressed("左"):
		velocity.x -= 1
	if Input.is_action_pressed("下"):
		velocity.y += 1
	if Input.is_action_pressed("上"):
		velocity.y -= 1
	mouse_x = get_global_mouse_position().x
	mouse_y = get_global_mouse_position().y
	if Input.is_action_pressed("mobairu"):
		if mouse_x > position.x:
			velocity.x += 1
		else:
			velocity.x -= 1
		if mouse_y > position.y:
			velocity.y += 1
		else:
			velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "a"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "b"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
