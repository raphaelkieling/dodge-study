extends Area2D

signal hit

export var speed = 400
var screen_size
var target = Vector2()


func _ready():
	hide()
	screen_size = get_viewport_rect().size
	
	
func _process(delta):
	var velocity = Vector2()
	
	if position.distance_to(target) > 10:
		velocity = target - position
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
		
	if velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y < 0
		$AnimatedSprite.flip_h = false


func _on_Player_body_entered(body):
	emit_signal("hit")
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
	
func start(pos):
	position = pos
	target = pos
	show()
	$CollisionShape2D.disabled = false
