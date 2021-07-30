extends Node

export (PackedScene) var Enemy
var score

func _ready():
	randomize()
	new_game()


func game_over():
	$Background.stop()
	$GameOver.play()
	
	yield (get_tree().create_timer(2), "timeout")
	
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	new_game()
	
func new_game():
	$Background.play()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_StartTimer_timeout():
	$EnemyTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	score += 1
	$CanvasLayer/Score.text = str(score)


func _on_EnemyTimer_timeout():
	$EnemyPath/EnemySpawnLocation.offset = randi()
	
	var enem = Enemy.instance()
	add_child(enem)
	
	enem.position = $EnemyPath/EnemySpawnLocation.position
	
	var direction = $EnemyPath/EnemySpawnLocation.rotation + PI / 21
	direction += rand_range(-PI/4, PI/4)
	enem.rotation = direction
	
	enem.linear_velocity = Vector2(rand_range(enem.min_speed, enem.max_speed), 0)
	enem.linear_velocity = enem.linear_velocity.rotated(direction)
