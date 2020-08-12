extends Node


var play_game


func _ready() -> void:
	if Engine.has_singleton("GodotPlayGamesServices"):
		play_game = Engine.get_singleton("GodotPlayGamesServices")

		var show_popups := true
		play_game.init(show_popups)


  # For enabling saved games functionality use below initialization instead
  # play_games_services.initWithSavedGames(show_popups, "SavedGamesName")
  
  # Connect callbacks (Use only those that you need)
#  play_games_services.connect("_on_sign_in_success", self, "_on_sign_in_success") # account_id: String
#  play_games_services.connect("_on_sign_in_failed", self, "_on_sign_in_failed") # error_code: int
#  play_games_services.connect("_on_sign_out_success", self, "_on_sign_out_success") # no params
#  play_games_services.connect("_on_sign_out_failed", self, "_on_sign_out_failed") # no params
#  play_games_services.connect("_on_achievement_unlocked", self, "_on_achievement_unlocked") # achievement: String
#  play_games_services.connect("_on_achievement_unlocking_failed", self, "_on_achievement_unlocking_failed") # achievement: String
#  play_games_services.connect("_on_achievement_revealed", self, "_on_achievement_revealed") # achievement: String
#  play_games_services.connect("_on_achievement_revealing_failed", self, "_on_achievement_revealing_failed") # achievement: String
#  play_games_services.connect("_on_achievement_incremented", self, "_on_achievement_incremented") # achievement: String
#  play_games_services.connect("_on_achievement_incrementing_failed", self, "_on_achievement_incrementing_failed") # achievement: String
#  play_games_services.connect("_on_leaderboard_score_submitted", self, "_on_leaderboard_score_submitted") # leaderboard_id: String
#  play_games_services.connect("_on_leaderboard_score_submitting_failed", self, "_on_leaderboard_score_submitting_failed") # leaderboard_id: String
#  play_games_services.connect("_on_game_saved_success", self, "_on_game_saved_success") # no params
#  play_games_services.connect("_on_game_saved_fail", self, "_on_game_saved_fail") # no params
#  play_games_services.connect("_on_game_load_success", self, "_on_game_load_success") # data: String
#  play_games_services.connect("_on_game_load_fail", self, "_on_game_load_fail") # no params
#  play_games_services.connect("_on_create_new_snapshot", self, "_on_create_new_snapshot") # name: String
