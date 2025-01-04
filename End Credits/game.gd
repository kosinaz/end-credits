extends Node2D

var word_scene = preload("res://word.tscn")
var dynamic_font = preload("res://word_font.tres")
var y_position = 200  # Starting Y position for the first line
var word_pool = []
var text_lines = [
	"Steamboats of Rogue River",
	"",
	"Code, art, and music by Kosina Zoltán.",
	"Art", 
	"Inspired by Walt Disney Animation Studios' Steamboat Willie",
	"Font",
	"Crunch Chips by The Docallisme - Amry Al Mursalaat",
	"Music",
	"Piano cover of Steamboat Bill - for easy piano by Samuel Stokes",
	"",
	"",
	"Divergica's Magical Mushroom Melodies",
	"",
	"Code and sounds by Kosina Zoltán.",
	"Art",
	"Adapted and extended version of the below",
	"Craftpix asset pack by Kosina Zoltán:",
	"KIDS FANTASY GAME – FREE GUI",
	"FREE CARTOON FOREST GAME BACKGROUNDS",
	"Font",
	"Candy Paint by Eifetstype",
	"",
	"",
	"Bastion of Entropy",
	"",
	"Code",
	"Kosina Zoltán",
	"Art",
	"Adapted version of 300+ Pixel Art Texture - 256x256",
	"by FlakDeau",
	"Font",
	"Cthulhu's Calling by Chequered Ink",
	"",
	"",
	"Sea of Fog",
	"",
	"Code",
	"Kosina Zoltán",
	"Art",
	"Tileset and UI by Kosina Zoltán",
	"Wanderer above the Sea of Fog by Caspar David Friedrich",
	"Music",
	"Acceptance by Kosina Zoltán",
	"Wandering Solitude by Kosina Zoltán",
	"Whispering Caverns by Tabletop Audio",
	"Voice",
	"Killian the Vampire by Typecast.ai",
	"Font",
	"Alagard by Hewett Tsoi",
	"Old London by Dieter Steffmann",
]

func _ready():
	initialize_word_pool()
	generate_initial_text()

func _process(delta):
	for word in get_children():
		if word.position.y < -60:
			recycle_word(word)
		else:
			word.position.y -= 50 * delta  # Adjust scrolling speed as needed

func recycle_word(word):
	word.hide()
	word_pool.append(word)

func initialize_word_pool():
	# Preload a pool of words for efficiency
	for _i in range(100):  # Adjust pool size as needed
		var word_instance = word_scene.instance()
		word_pool.append(word_instance)
		add_child(word_instance)
		word_instance.hide()

func spawn_word(text: String, position: Vector2):
	var word_instance = word_pool.pop_front()
	word_instance.set_text(text)
	word_instance.position = position

	# Refine the collision box
	var collision_shape = word_instance.get_node("CollisionShape2D")  # Adjust path to your CollisionShape2D
	if collision_shape:
		var shape = collision_shape.shape as RectangleShape2D
		if shape:
			# Calculate the word's actual width
			var word_width = dynamic_font.get_string_size(text).x
			var word_height = dynamic_font.get_height()

			# Set the size of the collision box based on word size
			shape.extents = Vector2(word_width / 2, word_height / 2)

			# Reduce size for finer collisions
			shape.extents.x -= 0  # Adjust right side reduction
			shape.extents.y -= 14  # Adjust top/bottom reduction

			# Optional: Recenter collision box if needed
			collision_shape.position = Vector2(shape.extents.x, shape.extents.y) + Vector2(0, 20)

	word_instance.show()
	word_pool.append(word_instance)



func generate_initial_text():
	for i in range(10):
		generate_line(i)

func generate_line(i):
		var line = text_lines[i]
		var words = line.split(" ")
		var line_width = 0

		# Calculate the total width of the line
		for word in words:
			line_width += calculate_word_width(word) + 10  # Add word spacing

		line_width -= 10  # Remove trailing spacing after the last word

		# Center the line by adjusting x_offset
		var x_offset = (get_viewport_rect().size.x - line_width) / 2

		for word in words:
			spawn_word(word, Vector2(x_offset, y_position))
			x_offset += calculate_word_width(word) + 20  # Add spacing between words

		y_position += 70  # Move to the next line


func calculate_word_width(word: String) -> float:
	# Measure the width of the word using the provided font
	return dynamic_font.get_string_size(word).x
