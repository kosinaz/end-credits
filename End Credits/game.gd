extends Node2D

var word_scene = preload("res://word.tscn")
var dynamic_font = preload("res://word_font.tres")
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
	"",
	"",
	"20 Parsecs",
	"",
	"Code and art",
	"Kosina Zoltán",
	"Planets art",
	"Pixel Planet Generator",
	"Font",
	"Nexa by Fontfabric",
	"",
	"",
	"Outage Protocol",
	"",
	"Code and art",
	"Kosina Zoltán",
	"Font",
	"Press Start 2P",
	"",
	"",
	"Fur Force 1",
	"",
	"Code",
	"Zoltan Kosina",
	"Character Art",
	"Layer AI",
	"Menu and Gameplay Art",
	"Kenney",
	"Toon Characters 1",
	"Isometric Vehicles #1",
	"Isometric Buildings #1",
	"Isometric City",
	"Music",
	"Udio",
	"",
	"",
	"Balloon Bot: Buzzin Bonanza",
	"",
	"Code and art",
	"Kosina Zoltán",
	"Font",
	"VT323",
	"",
	"",
	"Cosmic Conundrum",
	"",
	"Code and art",
	"Kosina Zoltán",
	"Font",
	"Kaushan Script",
	"",
	"",
	"Labyrinth.io",
	"",
	"Code",
	"Zoltan Kosina",
	"Art",
	"Tileset: Top-down Shooter by Kenney.nl",
	"Coin and Stairs: Mini Dungeon by Kenney.nl",
	"Peasant and Mino: Cube World Kit by Quaternius",
	"Font",
	"Rowdies Bold by Jaikishan Patel",
	"",
	"",
	"Walls of Quadraman",
	"",
	"Code",
	"Zoltan Kosina",
	"Art",
	"Castle: Castle Kit by Kenney",
	"Player: Mini Characters 1 by Kenney",
	"Title: 3D Font by TextStudio",
	"Font",
	"Lemon Milk Pro UltraBold by Marsne",
	"",
	"",
	"Loop Breakerz",
	"",
	"Code",
	"Zoltan Kosina",
	"ChatGPT",
	"Art",
	"Tileset and characters: Zoltan Kosina",
	"Title: Game Title Screen Generator enchanced with OpenArt",
	"Font",
	"Iceberg by Cyreal",
	"Music and Sound Effects by Jurij from Pixabay",
	"Neurobeat",
	"SFX Hit Ending",
	"SFX Connecting",
	"Boomerang",
	"Lazer Beamer",
	"60's SciFi",
	"Power UP",
	"Modular Madness",
	"Xylesizer",
	"Transition Signal 5",
	"Intro 3",
	"",
	"",
	"End Credits",
	"",
	"Code",
	"Zoltan Kosina",
	"ChatGPT",
	"Art",
	"Zoltan Kosina",
	"Music",
	"Game Music: Credits 2 by AlesiaDavina from Pixabay",
	"Font",
	"Oswald by Vernon Adams, Kalapi Gajjar, Cyreal",
	"",
	"",
	
]
var current_line_index = 0
var line_spacing = 70  # Spacing between lines
var line_timer = 0.0  # Timer to control line generation
var line_interval = 1.2  # Time (in seconds) between line generations
onready var player_1 = $Player
onready var player_2 = $Player2

func _ready():
	initialize_word_pool()
	generate_initial_text()
	current_line_index += 5

func _process(delta):
	if (player_1.position.y < - 17 or player_1.position.y > 700) and (player_2.position.y < - 17 or player_2.position.y > 700): 
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	if player_1.position.y < - 17 or player_1.position.y > 700:
		player_1.dead = true
		player_2.dead = true
	if player_2.position.y < - 17 or player_2.position.y > 700:
		player_1.dead = true
		player_2.dead = true
	for word in get_children():
		if word.name == "AudioStreamPlayer":
			continue
		word.position.y -= 50 * delta  # Adjust scrolling speed as needed
		if word.position.y < -60:
			recycle_word(word)
	
	line_timer += delta
	if line_timer >= line_interval:
		line_timer = 0.0
		add_next_line()

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
	word_instance.position = position - Vector2(60, 0)
	
	# Refine the collision box to match the word's actual size
	var collision_shape = word_instance.get_node("CollisionShape2D")  # Adjust path to your CollisionShape2D
	if collision_shape:
		var shape = collision_shape.shape as RectangleShape2D
		if shape:
			# Calculate the word's actual width using the dynamic font
			var word_width = dynamic_font.get_string_size(text).x
			var word_height = dynamic_font.get_height()

			# Set the size of the collision box based on word size
			shape.extents = Vector2(word_width / 2, word_height / 2)

			# Optionally, fine-tune the collision box for better precision
			shape.extents.x -= 0  # Adjust right side reduction, if needed
			shape.extents.y -= 12  # Adjust top/bottom reduction (to make it smaller vertically)

			# Optional: Recenter the collision box if needed (can also adjust y_offset to avoid misalignment)
			collision_shape.position = Vector2(shape.extents.x, shape.extents.y) + Vector2(0, 18)  # Adjust this offset if necessary

	word_instance.show()
	word_pool.append(word_instance)

func generate_initial_text():
	for i in range(5):
		generate_line(current_line_index + i, i * 70 - 280)

func generate_line(line_id, offset = 0):
	if line_id >= text_lines.size():
		current_line_index = 0
		line_id = 0
	var line = text_lines[line_id]
	if line.length() < 1:
		return
	var words = line.split(" ")
	var line_width = 0

	# Calculate the total width of the line
	for word in words:
		line_width += calculate_word_width(word) + 10  # Add word spacing
	line_width -= 10  # Remove trailing spacing after the last word

	# Center the line by adjusting x_offset
	var x_offset = (get_viewport_rect().size.x - line_width) / 2
	var y_position = get_viewport_rect().size.y  # Start just below the screen bottom

	for word in words:
		spawn_word(word, Vector2(x_offset, y_position + offset))
		x_offset += calculate_word_width(word) + 25  # Add spacing between words

func add_next_line():
	generate_line(current_line_index)
	current_line_index += 1

func calculate_word_width(word: String) -> float:
	# Measure the width of the word using the provided font
	return dynamic_font.get_string_size(word).x
