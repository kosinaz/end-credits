extends KinematicBody2D

onready var label = $Label
onready var collision_shape = $CollisionShape2D

func _ready():
	set_text("Hello worldHello worldHello worldHello world")

func set_text(word: String):
	label.text = word
	update_collision()

func update_collision():
	# Adjust collision shape to match the word's bounding box
	var rect = label.get_rect()
	var shape = RectangleShape2D.new()
	shape.extents = rect.size / 2
	collision_shape.shape = shape
	collision_shape.position = rect.size / 2
