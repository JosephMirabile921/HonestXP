extends Node

@export var slime_scene: PackedScene
var score
var seconds
var level = 1
var xp_needed
var current

func on_hit():
	score += 1
	current += 1
	$HUD/TextureProgressBar.max_value = xp_needed
	$HUD/TextureProgressBar.value = current
	$Splat.play()
	if current >= xp_needed:
		current -= xp_needed
		level_up()
		$HUD.update_score(level)
		$HUD/TextureProgressBar.max_value = xp_needed
		$HUD/TextureProgressBar.value = current

func new_game():
	score = 0
	current = 0
	seconds = 60
	level = 1
	xp_needed = get_xp_needed(level + 1)
	get_tree().call_group("slimes", "queue_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD/TextureProgressBar.show()
	$HUD/XPBar.show()
	$HUD/ScoreLabel.show()
	$HUD/TextureProgressBar.max_value = xp_needed
	$HUD/TextureProgressBar.value = current
	$HUD.update_score(level)
	$HUD.update_count(seconds)
	$Go.play()
	$Song.play()
	$HUD.show_message("Squash the slimes!")
	

func _on_slime_timer_timeout():
	# Create a new instance of the Mob scene.
	var slime = slime_scene.instantiate()

	# Choose a random location on Path2D.
	var slime_spawn_location = get_node("SlimePath/SlimeSpawnLocation")
	slime_spawn_location.progress_ratio = randf()

	# Set the slime's direction perpendicular to the path direction.
	var direction = slime_spawn_location.rotation + PI / 2

	# Set the slime's position to a random location.
	slime.position = slime_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(200.0, 300.0), 0.0)
	slime.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(slime)

func _on_start_timer_timeout():
	$SlimeTimer.start()
	$ScoreTimer.start()

func _on_countdown():
	if seconds > 0:
		seconds -= 1
		$HUD.update_count(seconds)
	else:
		$ScoreTimer.stop()
		$SlimeTimer.stop()
		$StartTimer.stop()
		$HUD.show_game_over()
		$Player.hide()
		$Player/PlayerCollider.set_deferred("disabled", true)
		$Song.stop()
		$GameOver.play()

func get_xp_needed(x):
	return round(x * 3)

func level_up():
	level += 1
	$LevelUp.play()
	xp_needed = get_xp_needed(level + 1)
