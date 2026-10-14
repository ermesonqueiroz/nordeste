extends BaseEnemy
class_name FrogEnemy

func flash() -> void:
	super.flash()
	$FrogTongue.flash()
