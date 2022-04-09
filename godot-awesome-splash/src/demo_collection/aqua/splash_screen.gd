extends AweSplashScreen

onready var title_node := $AspectNode/LogoContainer/TitleNode
onready var info_node := $AspectNode/LogoContainer/InfoNode
onready var logo := $AspectNode/LogoContainer/Logo

onready var background := $CanvasLayer/ColorRect
onready var logo_container := $AspectNode/LogoContainer
onready var sponges := $AspectNode/Sponges

onready var wave1 := $AspectNode/Wave1
onready var wave2 := $AspectNode/Wave2

export(String, FILE) var LOGO_PATH = "res://src/demo_collection/aqua/assets/logo.png"
export(String) var TITLE := "GODOT"
export(String) var DESCRIPTION := "Game engine"

export (float) var duration := 4.0

const LOGO_COLOR = Color8(255, 255, 255, 255)
const TITLE_COLOR = Color8(255, 255, 255, 255)
const DESCRIPTION_COLOR = Color8(255, 255, 255, 255)

const TITLE_FONT_SIZE = 230
const DESCRIPT_FONT_SIZE = 120

const COLOR_WAVE1 = Color8(0, 132, 222, 255)
const COLOR_WAVE2 = Color8(255, 255, 255, 255)
const BACKGROUND_COLOR = Color8(255, 255, 255, 255)

var wave1_move_up_time = 2.0
var wave2_move_up_time = 2.0
const PREPARE_MOVE_OTHER_SCREEN = 0.2 # time prepare move to other screen after animation finished

const SPONGE_MOVE_X_RANGE = Vector2(-450, 450)
const SPONGE_MOVE_HORIZONTAL_TIME_RANGE = Vector2(5.0, 10.0)
const SPONGE_MOVE_UP_TIME_RANGE = Vector2(5.0, 10.0)

func get_name() -> String:
	return "Aqua"

func _ready():
	config()

func play():
	start_main_animation()


func config():
	wave1_move_up_time = duration * 0.5
	wave2_move_up_time = duration * 0.4
	
	
	var center_point = self.origin_size / 2.0
	logo_container.position = center_point + Vector2(0, 300)
	logo_container.scale = Vector2(1, 1)
	logo_container.modulate = BACKGROUND_COLOR
	
	logo.texture = load_texture(LOGO_PATH)
	logo.modulate = LOGO_COLOR
	
	background.color = BACKGROUND_COLOR
	wave1.modulate = COLOR_WAVE1
	wave2.modulate = COLOR_WAVE2
	
	sponges.position = Vector2(center_point.x, self.origin_size.y + 1500.0)
	
	title_node.font.size = TITLE_FONT_SIZE
	title_node.modulate = TITLE_COLOR
	title_node.text = TITLE
	
	info_node.font.size = DESCRIPT_FONT_SIZE
	info_node.text = DESCRIPTION
	info_node.modulate = DESCRIPTION_COLOR
	


func start_main_animation():
	# move up wave 1
	gd.move_by(Vector2(1500, -6000), wave1_move_up_time).start(wave1)
	
	
	# move up all sponges
	for sponge in sponges.get_children():
		spoges_move_up(sponge)
	
	
	# wait and move up wave 2
	gd.sequence([
		gd.wait(wave1_move_up_time + 0.3),
		gd.move_by(Vector2(1500, -6000), 2.0),
	]).start(wave2)
	
	
	# move up all logo and all sponges in wave2
	var action_move_up = gd.move_by(Vector2(0, -3000), wave2_move_up_time).with_easing(0.8)
	gd.sequence([
		gd.wait(wave1_move_up_time + 0.7),
		gd.group([
			gd.run(action_move_up, sponges),
			gd.scale_to(0.5, wave2_move_up_time * 0.85),
			action_move_up,
		])
	]).start(logo_container)
	
	gd.sequence([
		gd.wait(wave1_move_up_time + wave2_move_up_time * 0.8 + PREPARE_MOVE_OTHER_SCREEN),
		gd.perform("finished_animation", self)
	]).start(self)


func spoges_move_up(sponge: Node2D):
	var range_move = get_random_value(SPONGE_MOVE_X_RANGE)
	var duration_move_sponge = get_random_value(SPONGE_MOVE_HORIZONTAL_TIME_RANGE)
	var duration_up = get_random_value(SPONGE_MOVE_UP_TIME_RANGE)

	gd.move_by_y(-4500, duration_up ).with_easing(0.4).start(sponge)
	gd.move_by_x(range_move, duration_move_sponge).with_easing(0.3).start(sponge.get_child(0))


func get_random_value(ran: Vector2) -> float:
	return (ran.y - ran.x) * randf() + ran.x
