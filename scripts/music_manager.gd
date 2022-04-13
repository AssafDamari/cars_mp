extends Node

onready var audio_stream_player = $audio_stream_player
var tracks = [
	"res://sound/Extreme-Sport-Trap-Music-PISTA.mp3",
	"res://sound/music1.wav",
	"res://sound/music2.wav",
	"res://sound/snow-field.mp3"
]

func _ready():
	SignalManager.connect("toggle_music", self, "_on_toggle_music")
	
func _on_toggle_music():
	if audio_stream_player.is_playing():
		audio_stream_player.stop()
	else:
		var random = RandomNumberGenerator.new()
		random.randomize()
		var track_index = random.randi_range(0, tracks.size() - 1 )
		var stream = load(tracks[track_index])
		audio_stream_player.volume_db = -10
		audio_stream_player.set_stream(stream)
		audio_stream_player.play()

