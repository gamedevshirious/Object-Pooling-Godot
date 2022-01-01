extends Node2D

func _ready():
	ObjectPoolManager.register_obj("ball", "res://scenes/Ball/Ball.tscn")

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var id = ObjectPoolManager.get("ball")
		var ball = instance_from_id(id)
		
		ball.position = $Position2D.position
		ObjectPoolManager.debug_key("ball")
		
func _on_Destroyer_body_exited(body):
	ObjectPoolManager.destroy(body.get_instance_id())
