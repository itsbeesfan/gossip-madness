extends Control

var confidence = 50
var reputation = 50
var current_node = "sleepover_intro"

@onready var background = $background
@onready var location = $location
@onready var speaker_label = $dialoguePanel/speaker
@onready var story_text = $dialoguePanel/story
@onready var choices = $dialoguePanel/choices
@onready var confidence_label = $stats/VBoxContainer/confidence
@onready var reputation_label = $stats/VBoxContainer/reputation
@onready var avatar_animation = $avatar
@onready var speaker_animation = $speaker



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
