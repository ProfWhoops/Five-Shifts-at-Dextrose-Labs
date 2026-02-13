extends Camera2D

@export var scrollArea : int
@export var scrollSpeed : float
@export var scrollDivisions : int
@export var officeSprite : Sprite2D

var screenWidth = ProjectSettings.get_setting("display/window/size/viewport_width")
var officeWidth : float
var distance : float
var divisionSize : float
var speedMultipilier : float

# Called when the node enters the scene tree for the first time.
func _ready():
	if scrollDivisions == 0:
		scrollDivisions = 1
	divisionSize = scrollArea / scrollDivisions
	if officeSprite:
		officeWidth = officeSprite.texture.get_width() * officeSprite.scale.x
		position.x = (officeWidth - screenWidth) / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	if GlobalVariables.camerasOpen:
		return
	if get_local_mouse_position().x < scrollArea:
		distance = scrollArea - get_local_mouse_position().x
		
		getSpeedMultiplier()
		
		position.x -= (scrollSpeed * speedMultipilier) * delta
		
	if get_local_mouse_position().x > screenWidth - scrollArea:
		distance = get_local_mouse_position().x - (screenWidth - scrollArea)
		
		getSpeedMultiplier()
		
		position.x += (scrollSpeed * speedMultipilier) * delta
		
	if officeSprite:
		if position.x < officeSprite.position.x:
			position.x = officeSprite.position.x
		if position.x + screenWidth > officeWidth:
			position.x = officeWidth - screenWidth

func getSpeedMultiplier() -> void:
	speedMultipilier = clamp(floor(distance / divisionSize) + 1, 1, scrollDivisions)
	speedMultipilier /= scrollDivisions
