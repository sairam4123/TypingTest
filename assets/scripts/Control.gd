extends Control

var _key_presses = ""

var regex = RegEx.new()

onready var starting_wait_time = $Timer.wait_time
onready var intro_text = $Intro.text

func _input(event):
	if event is InputEventKey:
		_key_presses += char(event.unicode)
		if $Timer.is_stopped():
			$Timer.start()
#	$Label.text = _key_presses

# Called when the node enters the scene tree for the first time.
func _ready():
	$Intro.text = intro_text.format([$Timer.wait_time])
	regex.compile("T: ([\\d]+[.]?[\\d]*)")
	$Timer.connect("timeout", self, "_timeout")
#	$Intro.text = $Intro.text.format($Timer.wait_time)

#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Intro.text = intro_text.format([$Timer.wait_time])
#	$Intro.text = $Intro.text.format([$Timer.wait_time])
	if _key_presses == "Wow it works!" or $Label.text == "You made it!":
		set_process_input(false)
		$Label.text = "You made it!"
	else:
		$Label.text = _key_presses
	if Input.is_key_pressed(KEY_ESCAPE):
		set_process_input(true)
		$Label.text = ""
		$Timer.wait_time = starting_wait_time
		_timeout()
		$Timer.stop()
	var result = regex.search(_key_presses)
	if result:
		$Timer.wait_time = float(result.get_string(1)) + float(float(result.get_string(1)) <= 0)
		prints("Changed the timer to", float(result.get_string(1)))
		_timeout()
		$Timer.stop()
		$Timer.start()
	

func _timeout():
	_key_presses = ""
