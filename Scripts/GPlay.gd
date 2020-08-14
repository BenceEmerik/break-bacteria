extends Node


var play_game

#liderboard id CgkIzqrC9pwQEAIQAQ
func _ready() -> void:
	if Engine.has_singleton("GodotPlayGamesServices"):
		play_game = Engine.get_singleton("GodotPlayGamesServices")

		var show_popups := false
		play_game.init(show_popups)
		#play_game.initWithSavedGames(show_popups, "SavedGamesName")
		play_game.connect("_on_sign_in_success", self, "_on_sign_in_success") # account_id: String
		play_game.connect("_on_sign_in_failed", self, "_on_sign_in_failed") # error_code: int
		play_game.connect("_on_sign_out_success", self, "_on_sign_out_success") # no params
		play_game.connect("_on_sign_out_failed", self, "_on_sign_out_failed") # no params
		play_game.connect("_on_leaderboard_score_submitted", self, "_on_leaderboard_score_submitted") # leaderboard_id: String
		play_game.connect("_on_leaderboard_score_submitting_failed", self, "_on_leaderboard_score_submitting_failed") # leaderboard_id: String
		play_game.connect("_on_game_saved_success", self, "_on_game_saved_success") # no params
		play_game.connect("_on_game_saved_fail", self, "_on_game_saved_fail") # no params
		play_game.connect("_on_game_load_success", self, "_on_game_load_success") # data: String
		play_game.connect("_on_game_load_fail", self, "_on_game_load_fail") # no params

#  play_games_services.connect("_on_achievement_unlocked", self, "_on_achievement_unlocked") # achievement: String
#  play_games_services.connect("_on_achievement_unlocking_failed", self, "_on_achievement_unlocking_failed") # achievement: String
#  play_games_services.connect("_on_achievement_revealed", self, "_on_achievement_revealed") # achievement: String
#  play_games_services.connect("_on_achievement_revealing_failed", self, "_on_achievement_revealing_failed") # achievement: String
#  play_games_services.connect("_on_achievement_incremented", self, "_on_achievement_incremented") # achievement: String
#  play_games_services.connect("_on_achievement_incrementing_failed", self, "_on_achievement_incrementing_failed") # achievement: String
#  play_games_services.connect("_on_create_new_snapshot", self, "_on_create_new_snapshot") # name: String

func _on_sign_in_success(id:String) -> void:
	print("sign in id " + id)

func _on_sign_in_failed(err_code:int) -> void:
	print("sign in fail: "+str(err_code))

func _on_sign_out_success() -> void:
	print("sign out success")
	
func _on_sign_out_failed() -> void:
	print("sign out failed")

func _on_leaderboard_score_submitted(leaderboard_id:String) -> void:
	print("leader board sub: "+leaderboard_id)
	#print("leader board list: ", play_game.showLeaderBoard(leaderboard_id))

func _on_leaderboard_score_submitting_failed(leaderboard_id:String) -> void:
	print("leader board sub failed: "+leaderboard_id)
