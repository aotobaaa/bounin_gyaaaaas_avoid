extends Area2D

signal hit

@export var speed = 400
var screen_size
var mouse_x = 0
var mouse_y = 0

func _ready():
    screen_size = get_viewport_rect().size
    hide()

func _process(delta):
    var velocity = Vector2.ZERO

    if Input.is_action_pressed("右"):
        velocity.x += 1
    if Input.is_action_pressed("左"):
        velocity.x -= 1
    if Input.is_action_pressed("下"):
        velocity.y += 1
    if Input.is_action_pressed("上"):
        velocity.y -= 1

    if Input.is_action_pressed("mobairu"):
        var mouse_pos = get_global_mouse_position()
        mouse_x = mouse_pos.x
        mouse_y = mouse_pos.y

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
        $AnimatedSprite2D.flip_h = velocity.x < 0
    elif velocity.y != 0:
        $AnimatedSprite2D.animation = "b"
        $AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(_body):
    hide()
    hit.emit()
    $CollisionShape2D.set_deferred("disabled", true)

func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false
