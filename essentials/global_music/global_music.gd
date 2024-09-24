class_name GlobalMusic
extends Node

enum GlobalMusicState {
	ERROR, ## [GlobalMusic] has encountered an error and can't be used.
	READY, ## [GlobalMusic] is ready to change its stream.
	TRANSITIONING ## [GlobalMusic] is changing its stream, all other transitions are cancelled.
}

signal transitioned

## An array of [SubStream] to determine the streams that the instance of GlobalMusic will work with.
@export var streams : Array[SubStream]
@export var restart_on_transition : bool = false # TODO: Implement
@export var transition_duration : float = 1.0
@export_category("AudioStream")
@export var volume_db : float = 0.0
@export var bus : String = "Master"

var _main_audio_stream_player : AudioStreamPlayer
var _complementary_audio_stream_player : AudioStreamPlayer
var _current_stream_key : String
var _global_music_state : GlobalMusicState
var _queued_stream : String

func _ready() -> void:
	if(streams.size() == 0):
		_global_music_state = GlobalMusicState.ERROR
		push_error("No streams supplied! This instance of GlobalMusic won't play music.")
		return
	_main_audio_stream_player = AudioStreamPlayer.new()
	_complementary_audio_stream_player = AudioStreamPlayer.new()
	
	add_child(_main_audio_stream_player)
	add_child(_complementary_audio_stream_player)
	
	_main_audio_stream_player.volume_db = volume_db
	_complementary_audio_stream_player.volume_db = volume_db
	_main_audio_stream_player.bus = bus
	_complementary_audio_stream_player.bus = bus
	
	_current_stream_key = streams[0].key
	_main_audio_stream_player.stream = streams[0].stream
	_global_music_state = GlobalMusicState.READY
	
## Transitions from the previous stream to a new one, given its key.
## All transitions will be blocked for the duration. Use [method queue_transition_to_scene] to launch a transition after the current one finishes.
func transition_to_stream(key : String) -> void:
	if(_global_music_state != GlobalMusicState.READY):
		return
	if(key == _current_stream_key):
		return
		
	_global_music_state = GlobalMusicState.TRANSITIONING
	var main_tween : Tween = create_tween()
	var complementary_tween : Tween = create_tween()
	main_tween.tween_property(_complementary_audio_stream_player, "volume_db", -80.0, transition_duration)
	complementary_tween.tween_property(_complementary_audio_stream_player, "volume_db", volume_db, transition_duration)
	_complementary_audio_stream_player.stream = get_stream(key)
	if(restart_on_transition):
		_complementary_audio_stream_player.seek(0.0)
		
	main_tween.finished.connect(Callable(func() -> void:
		_current_stream_key = key
		_main_audio_stream_player = _complementary_audio_stream_player
		remove_child(_complementary_audio_stream_player)
		_complementary_audio_stream_player = AudioStreamPlayer.new()
		add_child(_complementary_audio_stream_player)
		_global_music_state = GlobalMusicState.READY
		transitioned.emit()
		if(_queued_stream != ""):
			transition_to_stream(_queued_stream)
			_queued_stream = ""
	))
	
## Queue a transition to another stream, given its key. If ready to transition, this method will trigger a transition instead.
## It is heavily advised to always use this method instead of [method transition_to_stream], as the queue guarantees that there will be a transition even if it is blocked at first.
func queue_transition_to_stream(key : String) -> void:
	if(_global_music_state != GlobalMusicState.READY):
		_queued_stream = key
		return
		
	transition_to_stream(key)
	_queued_stream = ""
		
# Finds the [SubStream] with the same key and returns its [SubStream.stream]. If no [SubStream] is found with the same key, returns null.
func get_stream(key : String) -> AudioStream:
	if(_global_music_state == GlobalMusicState.ERROR):
		return null
		
	for stream in streams:
		if(stream.key == key):
			return stream.stream
			
	return null
	
