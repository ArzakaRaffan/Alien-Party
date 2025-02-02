extends StaticBody2D

@export var bounce_y: float = -240.0
@export var gravity:float =  3000.0
@onready var label_1: Label = $Label1
@onready var label_2: Label = $Label2
@onready var polygon_1: Sprite2D = $"Polygon1"
@onready var polygon_2: Sprite2D = $"Polygon2"
@export var path: String
var orig_y_position
var y_speed:float = 0.0 
var ready_player_one:bool = false
var ready_player_two:bool = false
@onready var transition: ColorRect = $"../../CanvasLayer/Transition"

func _ready() -> void:
	orig_y_position = position.y
	
func _bounce() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0,-40), .15)
	tween.chain().tween_property(self, "position", position, .15)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is MC:
		_bounce()
		if ready_player_one:
			unready_one()
		else :
			ready_one()
	if area.get_parent() is MC_Pink:
		_bounce()
		if ready_player_two:
			unready_two()
		else :
			ready_two()

func ready_one():
	unready_all_one()
	ready_player_one = true
	label_1.show()
	polygon_1.show()
	test_ready()
func ready_two():
	unready_all_two()
	ready_player_two = true
	label_2.show()
	polygon_2.show()
	test_ready()
func unready_one():
	ready_player_one = false
	label_1.hide()
	polygon_1.hide()
func unready_two():
	ready_player_two = false
	label_2.hide()
	polygon_2.hide()

func unready_all_one():
	for i in range (get_parent().get_child_count()) :
		get_parent().get_child(i).unready_one()
		
func unready_all_two():
	for i in range (get_parent().get_child_count()) :
		get_parent().get_child(i).unready_two()
		
func test_ready() :
	if ready_player_one and ready_player_two :
		transition.get_child(0).play("fade_out")
		await transition.get_child(0).animation_finished
		get_tree().change_scene_to_file(path)
