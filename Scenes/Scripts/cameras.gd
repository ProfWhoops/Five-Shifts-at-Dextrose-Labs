extends Control

@onready var cam_footage: Control = %CamHider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalVariables.camerasOpen:
		cam_footage.show()
	else:
		cam_footage.hide()
		

func _on_camera_button_mouse_entered() -> void:
	if GlobalVariables.camerasOpen:
		GlobalVariables.camerasOpen = false
	else:
		GlobalVariables.camerasOpen = true
