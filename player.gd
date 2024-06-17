extends Area2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player´s movevement vector
	if Input.is_action_pressed("derecha"):
		velocity.x += 1
	if Input.is_action_pressed("izquierda"):
		velocity.x -= 1
	if Input.is_action_pressed("abajo"):
		velocity.y += 1
	if Input.is_action_pressed("arriba"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "Walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assigment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "Up"
		$AnimatedSprite2D.flip_v =velocity.y > 0


func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false