extends Node

var did_the_game_load_yet_also_big_boobs: bool = false

var health: float = 100.0
var magic: float = 100.0
var exp: float = 0.0
var gems: int = 0
var highest_completed_level: int = 0
var active_status_effects: Array[Effect] = []

var sounds_enabled: bool = true
var haptics_enabled: bool = false

var temp_exp_gained: float = 0.0
var temp_drops_gained = []
var items_crafted: int = 0
var enemies_killed: int = 0

var game_level: Level
var cached_enemy_list = []
var live_enemy_list = []

var _rewarded_ad : RewardedAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()

func apply_status_effect(effect: Effect) -> void:
	effect.on_apply.call(effect)
	active_status_effects.append(effect)

func update_status_effects() -> void:
	for effect in active_status_effects:
		if effect.on_update:
			effect.on_update.call(effect)
		effect.duration -= 1.0
		if effect.duration <= 0:
			effect.on_expire.call(effect)
			active_status_effects.erase(effect)

func number_to_roman(num: int) -> String:
	var roman_numerals = {
		1000: "M", 
		900: "CM", 
		500: "D", 
		400: "CD",
		100: "C", 
		90: "XC", 
		50: "L", 
		40: "XL",
		10: "X", 
		9: "IX", 
		5: "V", 
		4: "IV", 
		1: "I"
	}
	var result = ""
	for value in roman_numerals.keys():
		while num >= value:
			result += roman_numerals[value]
			num -= value
	return result



func load_game():
	if did_the_game_load_yet_also_big_boobs == true:
		return
	if not FileAccess.file_exists("user://game.april"):
		did_the_game_load_yet_also_big_boobs = true
		return
	var save_file = FileAccess.open("user://game.april", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var data = json.get_data()
		if data.has("exp"):
			exp = data["exp"]
		if data.has("highest_completed_level"):
			highest_completed_level = data["highest_completed_level"]
		if data.has("equipment"):
			Inventories.equipment.set_list_from_save(data["equipment"])
		if data.has("drops"):
			Inventories.drops.set_list_from_save(data["drops"])
		if data.has("equipped_weapon"):
			Inventories.equipment.weapon = Items.get_item_by_id(data["equipped_weapon"])
		if data.has("equipped_armor"):
			Inventories.equipment.armor = Items.get_item_by_id(data["equipped_armor"])
		if data.has("items_crafted"):
			items_crafted = data["items_crafted"]
		if data.has("enemies_killed"):
			enemies_killed = data["enemies_killed"]
		if data.has("gems"):
			gems = data["gems"]
		else:
			gems = highest_completed_level
		if data.has("equipped_consumable"):
			if data["equipped_consumable"] != null:
				Inventories.equipment.consumable = Items.get_item_by_id(data["equipped_consumable"])
		if data.has("sounds_enabled"):
			sounds_enabled = data["sounds_enabled"]
		if data.has("haptics_enabled"):
			haptics_enabled = data["haptics_enabled"]
	print("Loaded the game.")
	did_the_game_load_yet_also_big_boobs = true
	
func get_consumable_id():
	if Inventories.equipment.consumable != null:
		return Inventories.equipment.consumable.id
	else:
		return null
	
func get_game_save_data() -> Dictionary:
	if Inventories.equipment.list.is_empty():
		var wooden_sword = ItemStack.new()
		wooden_sword.type = Items.get_item_by_id(0)
		wooden_sword.amount = 1
		var hoodie = ItemStack.new()
		hoodie.type = Items.get_item_by_id(1)
		hoodie.amount = 1
		Inventories.equipment.list.append(wooden_sword)
		Inventories.equipment.list.append(hoodie)
	
	return {
		"highest_completed_level": highest_completed_level,
		"gems": gems,
		"exp": exp,
		"equipment": Inventories.equipment.to_list(),
		"drops": Inventories.drops.to_list(),
		"equipped_weapon": Inventories.equipment.weapon.id,
		"equipped_armor": Inventories.equipment.armor.id,
		"equipped_consumable": get_consumable_id(),
		"items_crafted": items_crafted,
		"enemies_killed": enemies_killed,
		"haptics_enabled": haptics_enabled,
		"sounds_enabled": sounds_enabled
	}
	
func save_game(_data: Dictionary, reason: String):
	if GameCenter.game_center != null:
		GameCenter.game_center.post_score({
			"score": enemies_killed,
			"category": "enemies_killed"
		})
		GameCenter.game_center.post_score({
			"score": get_level(),
			"category": "highest_level"
		})
		GameCenter.game_center.post_score({
			"score": highest_completed_level,
			"category": "stages_progressed"
		})
		GameCenter.game_center.post_score({
			"score": items_crafted,
			"category": "items_crafted"
		})
		print("Updated Game Center scores.")
	var save_file = FileAccess.open("user://game.april", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(get_game_save_data()))
	print("Saved the game. " + "(" + reason + ")")

func _notification(what: int) -> void:
	if not did_the_game_load_yet_also_big_boobs:
		return
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		save_game(get_game_save_data(), "went to background")

func _ready() -> void:
	load_game()
	MobileAds.initialize()
	MobileAds.set_ios_app_pause_on_background(true)
	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
		print("on_user_earned_reward, rewarded_item: rewarded", rewarded_item.amount, rewarded_item.type)
		if (rewarded_item.type == "Gem"):
			Game.gems += rewarded_item.amount
			ToastParty.show({
				"text": "You were rewarded x" + str(rewarded_item.amount) + " gems for watching an ad!",
				"bgcolor": Color(0, 0, 0, 0.7),
				"color": Color(1, 1, 1, 1),
				"gravity": "bottom",
				"direction": "center",
				"text_size": 16
			})
		if (rewarded_item.type == "DoubledReward"):
			exp += Game.temp_exp_gained
			for item in Game.temp_drops_gained:
				var item_stack = ItemStack.new()
				item_stack.amount = 1
				item_stack.type = item
				Inventories.drops.add_item(item_stack)
			ToastParty.show({
				"text": "Doubled your rewards for watching an ad!",
				"bgcolor": Color(0, 0, 0, 0.7),
				"color": Color(1, 1, 1, 1),
				"gravity": "bottom",
				"direction": "center",
				"text_size": 16
			})
			get_tree().change_scene_to_file("res://scenes/menu.tscn")
	#var request_configuration := RequestConfiguration.new()
	#request_configuration.test_device_ids = ["7c96d4dc73546e0de5dce56d0aac74e9"]
	#MobileAds.set_request_configuration(request_configuration)

func load_rewarded_ad(unit_id: String = "ca-app-pub-4596716586585952/7903370356") -> void:
	if _rewarded_ad:
		_rewarded_ad.destroy()
		_rewarded_ad = null

	var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
	rewarded_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)
		ToastParty.show({
			"text": "Failed to load ad!",
			"bgcolor": Color(0, 0, 0, 0.7),
			"color": Color(1, 1, 1, 1),
			"gravity": "bottom",
			"direction": "center",
			"text_size": 24
		})

	rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
		print("rewarded ad loaded" + str(rewarded_ad._uid))
		_rewarded_ad = rewarded_ad
		_rewarded_ad.show(on_user_earned_reward_listener)

	RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_ad_load_callback)
	
func get_current_weapon_level() -> int:
	if Inventories.equipment.get_item_stack(Inventories.equipment.weapon).data.has("level"):
		return Inventories.equipment.get_item_stack(Inventories.equipment.weapon).data["level"]
	else:
		return 0

func get_attack_speed() -> float:
	var attack_speed = 1.0
	if Inventories.equipment.weapon != null:
		attack_speed += Inventories.equipment.weapon.attack_speed.call()
	return attack_speed

func get_attack() -> float:
	var attack = 20.0
	if Inventories.equipment.weapon != null:
		attack += Inventories.equipment.weapon.damage.call()
	return attack
	
func get_max_health() -> float:
	var max_health = 100.0
	max_health += 5 * get_level()
	if Inventories.equipment.armor != null:
		max_health += Inventories.equipment.armor.health 
	return max_health

func get_max_magic() -> float:
	var max_magic = 100.0
	max_magic += 0.5 * get_level()
	return max_magic

func get_defense() -> float:
	var defense = 10.0
	defense += 2 * get_level()
	if Inventories.equipment.armor != null:
		defense += Inventories.equipment.armor.defense 
	return defense

func get_level() -> int: 
	var file = FileAccess.open("res://scripts/levels.json", FileAccess.READ)
	if not file:
		push_error("Failed to load levels.json")
		return -1
	var levels_data = JSON.parse_string(file.get_as_text())
	file.close()
	var current_level = 0
	for level in levels_data["levels"].keys():
		if int(levels_data["levels"][level]) <= exp:
			current_level = int(level)
		else:
			break
	return current_level

func get_progress() -> int:
	var file = FileAccess.open("res://scripts/levels.json", FileAccess.READ)
	if not file:
		push_error("Failed to load levels.json")
		return -1 
	var levels_data = JSON.parse_string(file.get_as_text())
	file.close()
	var current_level = 0
	for level in levels_data["levels"].keys():
		if int(levels_data["levels"][level]) <= exp:
			current_level = int(level)
		else:
			break
	var current_xp = levels_data["levels"][str(current_level)]
	var next_xp = levels_data["levels"].get(str(current_level + 1), current_xp)  # Handle max level case
	var progress = 0
	if next_xp > current_xp:
		progress = float(exp - current_xp) / float(next_xp - current_xp) * 100

	return int(clamp(progress, 0, 100))
