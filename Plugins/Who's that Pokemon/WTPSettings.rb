#===============================================================================
# Who's That Pokemon!
# By Dr.Doom76
#===============================================================================
module WTPSettings
# =============== Who's That Pokemon Settings =============== #
# This setting is for defaulting the value of the generation of possible Pokemon.
# If you're not using arguments (I.E. pbWTP(1,2), where (1,2) are the arguments, 
# these are the generations that will be chosen from, by default.

GENERATIONS_TO_CHOOSE_FROM = [1,2,3,4,5,6,7,8,9]


# ------------------- Sound Effects ------------------- #
# If you wish to change these, simply put them in your Audio/SE folder and change the name of the file here.

# The "Who's That Pokemon sound from the OG anime.
WHOS_THAT_POKEMON = "WhosThatPokemon"

# Ding sound when Player guesses answer right.
RIGHT_ANSWER = "Correct"

# Buzzer sound when Player guesses answer wrong.
WRONG_ANSWER = "Incorrect"


# ------------------- Milestones ------------------- #
# Milestones, benchmark, goal, whatever you want to call it.
# Settings here will turn off rewards, change the level of milestones the rewards are given.
# And change the rewards given.


# ------------- Total Correct Milestone Settings ------------- #
# This setting will award rewards based on milestones in the following setting.
# True = use rewards / False = no rewards (Both for total correct count)
USE_TOTAL_CORRECT_MILESTONES = true


# This is a table of rewards that will be given based on milestones.
# The number is the milestone that the Player will have to reach to get the reward.
# The reward is an item in symbol format you want the Player to receive at the given milestone.
# Rewards for total correct guesses.
# Format: total correct guesses => [item(s) given]
# Keep in array [] format
TOTAL_CORRECT_MILESTONE_REWARDS = {
  5  => [:POTION],
  10 => [:SUPERPOTION, :GREATBALL],
  15 => [:GREATBALL, :REVIVE],
  20 => [:GREATBALL, :ULTRABALL, :HYPERPOTION],
  25 => [:ULTRABALL, :RARECANDY, :FULLHEAL],
  30 => [:REVIVE, :FULLRESTORE, :PPUP],
  35 => [:HYPERPOTION, :MAXPOTION, :PPMAX],
  40 => [:FULLRESTORE, :MAXELIXIR, :RARECANDY],
  45 => [:MAXREVIVE, :RARECANDY, :RARECANDY],
  50 => [:MAXREVIVE, :RARECANDY, :ABILITYCAPSULE]
  
# Continue as needed
}


# ------------- Total Correct Milestone Settings ------------- #
# This setting will award rewards based on milestones in the following setting.
# True = use rewards / False = no rewards (Both for highest streak count)
USE_HIGHEST_STREAK_MILESTONES = true

# This is a table of rewards that will be given based on milestones.
# The number is the milestone that the Player will have to reach to get the reward.
# The reward is an item in symbol format you want the Player to receive at the given milestone.
# Rewards for highest correct streak.
# Format : highest streak => [item(s) given]
# Keep in array [] format
HIGHEST_STREAK_MILESTONE_REWARDS = {
  5  => [:POTION],
  10 => [:SUPERPOTION, :GREATBALL],
  15 => [:GREATBALL, :REVIVE],
  20 => [:GREATBALL, :ULTRABALL, :HYPERPOTION],
  25 => [:ULTRABALL, :RARECANDY, :FULLHEAL],
  30 => [:REVIVE, :FULLRESTORE, :PPUP],
  35 => [:HYPERPOTION, :MAXPOTION, :PPMAX],
  40 => [:FULLRESTORE, :MAXELIXIR, :RARECANDY],
  45 => [:MAXREVIVE, :RARECANDY, :RARECANDY],
  50 => [:MAXREVIVE, :RARECANDY, :ABILITYCAPSULE]
  
# Continue as needed
}
end	