extends CharacterBody3D
class_name StairsCharacter
# Extend this class to make a character capable of stepping up stairs.

@export_category("Stair Stepping")
## The maximum height of step the player can step on
@export var step_height : float = 0.33
## How much extra height below the collider to extend the separating ray
@export var step_margin : float = 0.05

var _separator : CollisionShape3D
var _raycast : RayCast3D
var _rayShapeLocalHeight : float

func _ready() -> void:
	for node in get_children():
		if !(node is CollisionShape3D):
			continue
		
		var col : CollisionShape3D = node as CollisionShape3D
		var col_shape : Shape3D = col.shape
			
		_separator = CollisionShape3D.new()
		_separator.rotation_degrees = Vector3.RIGHT * 90
		
		var shape = SeparationRayShape3D.new()
		shape.length = step_height
		_separator.shape = shape
		
		_raycast = RayCast3D.new()
		_raycast.target_position = Vector3.DOWN * step_height
		_raycast.collision_mask = collision_mask
		_raycast.exclude_parent = true
		_raycast.enabled = false
		
		_rayShapeLocalHeight = col.position.y - col_shape.height * 0.5 + step_height
		
		add_child(_separator)
		add_child(_raycast)
		
## Call this before move_and_slide()
func handle_stairs() -> void:
	if is_on_floor() == false || get_last_slide_collision() == null:
		_separator.disabled = true
		return
	
	var local_pos : Vector3 = to_local(get_last_slide_collision().get_position())
	local_pos.y = _rayShapeLocalHeight+step_margin
	
	_raycast.position = local_pos
	_raycast.force_update_transform()
	_raycast.force_raycast_update()
	
	var angle = _raycast.get_collision_normal().angle_to(up_direction)
	if (angle > floor_max_angle):
		return
		
	_separator.disabled = false
	_separator.position = local_pos
