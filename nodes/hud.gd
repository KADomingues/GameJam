extends CanvasLayer

var music_bus = AudioServer.get_bus_index("Music")
var master_bus = AudioServer.get_bus_index("Master")

#FMOD variables
@export var bus_asset: BusAsset
var bus: Bus

# Notifies `Main` node that the button has been pressed
signal start_game

func _ready():
	bus = FMODStudioModule.get_studio_system().get_bus(bus_asset.path)

func show_message(text):
	#$message.text = text
	#$message.show()
	$messageTimer.start()
	
func show_game_over():
	show_message("Game Over!")
	# Wait until the messageTimer has counted down
	await $messageTimer.timeout
	
	$logo.show()
	#$message.text = "Dodge the Creeps!"
	#$message.show()
	$movimentLabel.show()
	$volumeLabel.show()
	
	# Make a one-shot timer and wait for it to finish
	await get_tree().create_timer(1.0).timeout
	$startButton.show()
	
func update_score(score):
	$scoreLabel.text = str(score)

func _on_start_button_pressed():
	$startButton.hide()
	$movimentLabel.hide()
	$volumeLabel.hide()
	start_game.emit()

func _on_message_timer_timeout():
	#$message.hide()
	$logo.hide()

func _on_h_slider_value_changed(value):
	bus.set_volume(value)
	#AudioServer.set_bus_volume_db(master_bus, value)
	
	#if value <= -30:
		#AudioServer.set_bus_mute(music_bus, true)
	#if value <= 0:
	#	AudioServer.set_bus_mute(master_bus, true)
	#else:
	#	AudioServer.set_bus_mute(master_bus, false)
