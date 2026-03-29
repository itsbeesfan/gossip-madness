extends Control

var confidence = 50
var reputation = 50
var current_node = "scene_1"


#ui element load or something
@onready var background = $background
@onready var location_label = $location
@onready var speaker_label = $dialoguePanel/speaker
@onready var story_text = $dialoguePanel/story
@onready var choices_box = $dialoguePanel/choices
@onready var confidence_label = $stats/VBoxContainer/confidence
@onready var reputation_label = $stats/VBoxContainer/reputation
@onready var avatar_animation = $avatar
@onready var speaker_animation = $speaker

# assets load i guess

#BACKGROUNDS!!!
@onready var bg_sleepover = preload("res://backgrounds/sleepover-bg.png")
@onready var bg_bathroom = preload("res://backgrounds/bathroom-bg.png")
@onready var bg_backyard = preload("res://backgrounds/backyard-bg.png")

@onready var noelle_happy = preload("res://avatars/girl-happy.png")
@onready var noelle_neutral = preload("res://avatars/girl-normal.png")
@onready var noelle_upset = preload("res://avatars/girl-upset.png")

@onready var isabella_sprite = preload("res://avatars/npc1.png")
#add more in a bit!!!!!

var story = {
	"scene_1": {
		"location": "sleepover",
		"speaker": "noelle",
		"text": "everyone is having a great time during the sleepover. suddenly, you hear your name being whispered from under the blankets. 'wait does she really have smelly feet?' someone says. a few girls laugh.",
		"choices": [
			{"label": "laugh it off and make a joke about it", "confidence": 5, "reputation": 9, "next": "sleepover_joke"},
			{"label": "confront them and ask who said that", "confidence": 2, "reputation": 2, "next": "sleepover_confrontation"},
			{"label": "pretend you heard nothing", "confidence": -5, "reputation": -5, "next": "sleepover_silence"}
		]
	},
	
	"sleepover_joke": {
		"location": "sleepover",
		"speaker": "you",
		"text": "you grin and get closer to the group. 'OH NO YOU EXPOSED ME.' a few people laugh with you instead of at you. it seems to be over, until you hear more whispering across the room.",
		"choices": [
			{"label": "ignore it and redirect attention with a crazy story", "confidence": 8, "reputation": 10, "next": "sleepover_change"},
			{"label": "watch and see who is whispering", "confidence": 2, "reputation": 4, "next": "sleepover_change"},
		]
	},

	"sleepover_confrontation": {
		"location": "sleepover",
		"speaker": "isabella",
		"text": "you stare at the group and ask who said that, with a hint of panic in your tone. 'relax, we were just playing,' isabella says. no one makes eye contact with you.",
		"choices": [
			{"label": "say it didn't feel like a joke", "confidence": 8, "reputation": 6, "next": "sleepover_change"},
			{"label": "go quiet.", "confidence": -5, "reputation": -2, "next": "sleepover_change"},
		]
	},
	
	"sleepover_silence": {
		"location": "sleepover",
		"speaker": "you",
		"text": "you don't say anything, and somehow, the rumor evolves into 'she never showers.' well damn.",
		"choices": [
			{"label": "call your bestie for backup", "confidence": 6, "reputation": 5, "next": "sleepover_change"},
			{"label": "act nonchalant, and hope they forget later.", "confidence": -8, "reputation": -7, "next": "sleepover_change"},
		]
	},
	
	"sleepover_change": {
		"location": "sleepover",
		"speaker": "jules",
		"text": "jules signs for you to go to the bathroom, while standing up and waiting for you to follow her. she's an acquaintance, you don't know her well.",
		"choices": [
			{"label": "go with jules", "confidence": 5, "reputation": 0, "next": "bathroom_one"},
			{"label": "ask her 'what for?'", "confidence": -5, "reputation": 0, "next": "bathroom_one"}
		]
	},
	
	"bathroom_one": {
		"location": "bathroom",
		"speaker": "narrator",
		"text": "the bathroom is bright, and yet, quiet. people have left their makeup, toiletries. you look in the mirror, and you're pale as a ghost.",
		"choices": [
			{"label": "breathe in and steady yourself", "confidence": 8, "reputation": 0, "next": "bathroom_talk"},
			{"label": "avoid looking at yourself", "confidence": -5, "reputation": 0, "next": "bathroom_talk"}
		]
	},
	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_ui()
	
	
func update_ui():
	clear_choices()
	update_stats()
	update_avatar()
	
	if current_node == "ending":
		show_ending()
		return
	
	var node = story[current_node]
	
	update_background(node["location"])
	update_location_label(node["location"])
	update_speaker(node["speaker"])
	story_text.text = node["text"]
	
	for choice in node["choices"]:
		create_choice_button(choice)
		
	
func clear_choices():
	for child in choices_box.get_children():
		child.queue_free()
		
func create_choice_button(choice_data):
	var button = Button.new()
	button.text = choice_data["label"]
	button.custom_minimum_size = Vector2(0,30)
	
	var local_choice = choice_data
	button.pressed.connect(func(): choose_option(local_choice))
	choices_box.add_child(button)
	
func choose_option(choice_data):
	confidence += choice_data["confidence"]
	reputation += choice_data["reputation"]
	
	confidence = clamp(confidence, 0, 100)
	reputation = clamp(reputation, 0, 100)
		
	current_node = choice_data["next"]
	update_ui()

func update_background(location):
	match location:
		"sleepover":
			background.texture = bg_sleepover
		"bathroom":
			background.texture = bg_bathroom
		"backyard":
			background.texture = bg_backyard
			
func update_location_label(location):
	match location:
		"sleepover":
			location_label.text = "sleepover"
		"bathroom":
			location_label.text = "bathroom"
		"backyard":
			location_label.text = "backyard"

func update_speaker(speaker_name):
	speaker_label.text = speaker_name
	
	match speaker_name:
		"isabella":
			speaker_animation.texture = isabella_sprite
			speaker_animation.visible = true
		#ADD MORE LATER PAPU
		
func update_avatar():
	if confidence >= 50:
		avatar_animation.texture = noelle_happy
	elif confidence >= 20:
		avatar_animation.texture = noelle_neutral
	else:
		avatar_animation.texture = noelle_upset
		
func update_stats():
	
	confidence_label.text = "confidence: " + str(confidence) #add other stuff later
	reputation_label.text = "reputation: " + str(reputation) #add other stuff later
	
func show_ending():
	clear_choices()
	update_background("backyard")
	update_location_label("backyard")
	speaker_label.text = "sunrise"
	speaker_animation.visible = false
	
	if reputation >= 70:
		if confidence >= 60:
			story_text.text = "good ending: the whispers are gone by now. you're charisma royalty, and you took back the night."
		else:
			story_text.text = "bittersweet ending: the rumor is gone, but you still haven't move on... it keeps bugging you, really."
			
	elif reputation >= 40:
		if confidence >= 60:
			story_text.text = "meh ending: the rumor doesn't disappear, but you stop caring. nonchalant ahh."
		else:
			story_text.text = "meh ending: morning comes, but it doesn't feel like the night is over. you don't say goodbye to most people. you're outta there."
			
	else:
		if confidence >= 60:
			story_text.text = "'bad' ending: the rumor spreads like crazy. but you don't let that define you. you are so confident that, even if the entire school calls you smelly, you still wouldn't care."
			
		else:
			story_text.text = "bad ending: the rumor has spread. you go home, but it's never over. that night tortures your for the rest of your high school life."
	
	update_stats()
	update_avatar()
	
	var restart_button = Button.new()
	restart_button.text = "play again?"
	restart_button.custom_minimum_size = Vector2(0, 45)
	restart_button.pressed.connect(restart_game)
	choices_box.add_child(restart_button)
	
func restart_game():
	confidence = 50
	reputation = 50
	current_node = "scene_1"
	update_ui()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
