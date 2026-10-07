extends Node

func play(stream: AudioStream, volume: float = 0.0, world_position: Variant = null, player_process_mode: Node.ProcessMode = Node.ProcessMode.PROCESS_MODE_PAUSABLE):
	var player: Node

	if world_position != null:
		player = AudioStreamPlayer2D.new()
		player.global_position = world_position
	else:
		player = AudioStreamPlayer.new()

	player.stream = stream
	player.volume_db = volume
	player.process_mode = player_process_mode

	get_tree().root.call_deferred("add_child", player)
	player.call_deferred("play")

	player.finished.connect(func(): player.queue_free())
