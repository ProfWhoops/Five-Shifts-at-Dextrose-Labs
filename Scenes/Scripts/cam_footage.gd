extends Control
@export var pan_speed := 20.0

@onready var camFootage: TextureRect = $UpadBOOST/CamFootage
@onready var tv_static: TextureRect = $UpadBOOST/Static
@onready var timer = $"../../Timer"
@onready var audio_static_player = $"../../AudioStaticPlayer"

const RECEPTION = preload("uid://gifdvlgawek1")
const HALLWAY_1 = preload("uid://b34emyh41y4ej")



var camera_textures = {
	1 : RECEPTION,
	2 : HALLWAY_1
}

var current_camera = 1


var pan_x := 0.0
var pan_dir := 1.0
var pan_range : float

var old_camerasOpen := false
var static_buzzing := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camFootage.texture = camera_textures[1]
	audio_static_player.playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if old_camerasOpen != GlobalVariables.camerasOpen:
		set_pan_range()
		old_camerasOpen = GlobalVariables.camerasOpen
	# TV static
	if not static_buzzing:
		tv_static.self_modulate.a = randf_range(0.3, 0.6)
	tv_static.flip_h = randi_range(0, 1)
	tv_static.flip_v = randi_range(0, 1)
	
	
	# pan the camera footage
	pan_x += pan_dir * pan_speed * delta
	
	if pan_x > pan_range or pan_x < 0:
		pan_dir *= -1
	
	camFootage.position.x = -pan_x
	
	static_volume()
	
func set_camera(cam_id):
	static_flash()
	
	current_camera = cam_id
	camFootage.texture = camera_textures[cam_id]
	set_pan_range()
	pan_x = pan_range / 2	
	pan_dir = 1.0
	
	
func set_pan_range():
	print("setting pan range")
	if camFootage.texture:
		
		var texture_size = camFootage.texture.get_size()
		print("texture: ", texture_size.x)
		
		print("rect: ", camFootage.size.x)
		
		var scale_x = camFootage.size.x / texture_size.x
		
		var drawn_width = texture_size.x * scale_x
		print("drawn: ", drawn_width)
		
		var visible_width = camFootage.get_parent().size.x
		print("visible: ", visible_width)
		
		pan_range = max(0, drawn_width - visible_width)
		print("pan_range: ", pan_range)
		
			
func static_flash() -> void:
	static_buzzing = true
	tv_static.self_modulate.a = 1
	timer.wait_time = randf_range(0.6, 1.4)
	timer.start()
	# continued at _on_timer_timeout():

func static_volume():
	if static_buzzing:
		audio_static_player.volume_db = 0
	elif GlobalVariables.camerasOpen == true:
		audio_static_player.volume_db = -15
	else:
		audio_static_player.volume_db = -30
		

func _on_cam_1_pressed() -> void:
	set_camera(1)


func _on_cam_2_pressed() -> void:
	set_camera(2)

func _on_timer_timeout():
	static_buzzing = false
