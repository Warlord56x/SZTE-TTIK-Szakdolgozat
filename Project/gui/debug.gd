extends Label


func _process(_delta):
	text = "FPS:" + str(int(Engine.get_frames_per_second()))
