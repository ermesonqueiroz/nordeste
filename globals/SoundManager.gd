extends Node

func play(stream: AudioStream, volume: float = 0.0, player_process_mode: Node.ProcessMode = Node.ProcessMode.PROCESS_MODE_PAUSABLE):
	var player = AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume
	player.process_mode = player_process_mode

	add_child(player)
	player.play()

	player.finished.connect(func(): player.queue_free())
