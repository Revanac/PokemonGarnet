class WTP_Scene
	# initialize starting values
  def initialize(allowed_generations)
	@allowed_generations = allowed_generations
	@play_wtp_sound = true
	@sound_settings = {
		wtp_start: WTPSettings::WHOS_THAT_POKEMON,
		correct: WTPSettings::RIGHT_ANSWER,
		incorrect: WTPSettings::WRONG_ANSWER
	 }
	$stats.wtp_correct_count ||= 0
	$stats.wtp_streak ||= 0
	$stats.wtp_highest_streak ||= 0
  end
  
  # Sets the Scene
	def pbStartScene
	  @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
	  @viewport.z = 99999
	  @sprites = {}
	  @sprites["background"] = IconSprite.new(0, 0, @viewport)
	  @sprites["background"].setBitmap("Graphics/UI/Mini Games/WhosThatPokemon")
	  @sprites["icon"] = PokemonSprite.new(@viewport)
	  @sprites["icon"].x = 145
	  @sprites["icon"].y = Graphics.height - 210
	  pbDeactivateWindows(@sprites)
	  pbRefresh
	  Graphics.frame_reset
	  pbFadeInAndShow(@sprites) { pbUpdate }

	  loop do
		choice = pbMessage(_INTL("Welcome to Who's That Pokémon! What would you like to do?"), 
						  [_INTL("Play"), _INTL("Explanation"), _INTL("Toggle Sound Effects"), _INTL("Exit")], 4)

		case choice
		when 0  # Play
		  $stats.wtp_streak = 0
		  choosePokemon
		  break
		when 1  # Explanation
		  pbMessage(_INTL("You'll see a Pokémon's silhouette. Type its name to guess. Get it right and earn points!"))
		  pbMessage(_INTL("Your Total Correct guesses, Highest Streak, and Current Streak will be displayed on the screen."))
		  pbMessage(_INTL("Get high enough streaks and you just might get some special rewards!"))
		when 2  # Options (Placeholder for future settings)
		  toggleAllSoundEffects
		when 3  # Exit
		  pbEndScene
		  return
		end
	  end
	end

	def toggleAllSoundEffects
	  @play_wtp_sound = !@play_wtp_sound  # Toggle value
	  status = @play_wtp_sound ? "ON" : "OFF"
	  pbMessage(_INTL("All Sound Effects are now {1}.", status))
	end
	
  def pbRefresh
    pbUpdateSpriteHash(@sprites)
  end
  
def choosePokemon
  list = []
  drawStreakCounter
  # Filter Pokémon based on allowed generations
  GameData::Species.each do |species|
    if @allowed_generations.include?(species.generation)
      list.push(species.id)
    end
  end

  if list.empty?
    pbMessage(_INTL("No Pokémon found for the selected generations!"))
    pbEndScene
    return
  end

  loop do  # Keep looping if player wants to continue
    chosenPokemon = list.sample  # Ensure a valid Pokémon is chosen

    pbSEPlay(@sound_settings[:wtp_start]) if @play_wtp_sound

    # Displays Pokémon as a silhouette
    @sprites["icon"].setSpeciesBitmap(chosenPokemon, 0, 0, false)
    if @sprites["icon"].bitmap.nil?
      pbMessage(_INTL("Error loading Pokémon sprite."))
      next  # Retry with another Pokémon
    end
    @sprites["icon"].tone = Tone.new(-255, -255, -255, 255)
    @sprites["icon"].visible = true

    # Player enters their guess
    enteredPkmn = pbWTFText("Who's that Pokémon?", "", 140, Graphics.width)
    if enteredPkmn
      @sprites["icon"].tone = Tone.new(0, 0, 0, 0)
      base_species = GameData::Species.get(chosenPokemon).real_name.downcase.strip
	  if enteredPkmn.downcase.strip == base_species

        pbSEPlay(@sound_settings[:correct]) if @play_wtp_sound
        pbMessage(_INTL("Correct! It's {1}!", GameData::Species.get(chosenPokemon).name))
        $stats.wtp_correct_count += 1
        $stats.wtp_streak += 1
		if $stats.wtp_streak > $stats.wtp_highest_streak
		  $stats.wtp_highest_streak = $stats.wtp_streak
		end
		drawStreakCounter  
		checkRewardStatus
		checkStreakRewardStatus
      else
		pbSEPlay(@sound_settings[:incorrect]) if @play_wtp_sound
        pbMessage(_INTL("Incorrect! The correct answer was {1}.", GameData::Species.get(chosenPokemon).name))
		if $stats.wtp_streak > $stats.wtp_highest_streak
		  $stats.wtp_highest_streak = $stats.wtp_streak 
		end
        $stats.wtp_streak = 0
      end
    else
      pbMessage(_INTL("Come back if you change your mind."))
      pbEndScene
      return
    end

    break unless pbConfirmMessage(_INTL("Would you like to play again?"))
  end

  pbEndScene
end

 
   def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end
  
  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
  
      # Modified text entry
  def pbWTFText(text, initialtext, maxlength, width = 70)
	window = Window_TextEntry_Keyboard.new(initialtext, 0, 0, 400, 96, text, true)
    ret = ""
    window.maxlength = maxlength
    window.visible = true
    window.z = 99999
    window.text = initialtext
	
	#@helper = CharacterEntryHelper.new(text)
	
    Input.text_input = true
    loop do
      Graphics.update
      Input.update
      if Input.triggerex?(:ESCAPE)
        ret = nil
        break
      elsif Input.triggerex?(:RETURN)
        ret = window.text
        break
      end
      window.update
      yield if block_given?
    end
    Input.text_input = false
    window.dispose
    Input.update
    return ret
  end

  def drawStreakCounter
	@sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport) if !@sprites["overlay"]
	overlay = @sprites["overlay"].bitmap
	overlay.clear
  
	text_positions = [
	  [_INTL("Total Correct: #{$stats.wtp_correct_count}"), Graphics.width - 120, 10, 2, Color.new(255, 255, 255), Color.new(0, 0, 0)],
	  [_INTL("Highest Streak: #{$stats.wtp_highest_streak}"), Graphics.width - 120, 30, 2, Color.new(255, 255, 255), Color.new(0, 0, 0)],
	  [_INTL("Current Streak: #{$stats.wtp_streak}"), Graphics.width - 120, 50, 2, Color.new(255, 255, 255), Color.new(0, 0, 0)]
	]

	pbDrawTextPositions(overlay, text_positions)
  end

	def checkRewardStatus
	  return unless WTPSettings::USE_TOTAL_CORRECT_MILESTONES
	  
	  # Get the rewards for the current milestone
	  rewards = WTPSettings::TOTAL_CORRECT_MILESTONE_REWARDS[$stats.wtp_correct_count]
	  return if rewards.nil? || rewards.empty?

	  # Give each item to the player
	  rewards.each { |reward| pbReceiveItem(reward) }

	  # Convert the reward symbols into item names
	  reward_names = rewards.map { |item| GameData::Item.get(item).name }.join(", ")

	  # Display a message once with all rewards
	  pbMessage(_INTL("Congratulations! You've earned {1} for reaching Total Correct Milestone {2}!", 
					  reward_names, $stats.wtp_correct_count))
	end

	def checkStreakRewardStatus
	  return unless WTPSettings::USE_HIGHEST_STREAK_MILESTONES

	  # Get the rewards for the current streak milestone
	  rewards = WTPSettings::HIGHEST_STREAK_MILESTONE_REWARDS[$stats.wtp_highest_streak]
	  return if rewards.nil? || rewards.empty?

	  # Give each item to the player
	  rewards.each { |reward| pbReceiveItem(reward) }

	  # Convert the reward symbols into item names
	  reward_names = rewards.map { |item| GameData::Item.get(item).name }.join(", ")

	  # Display a message once with all rewards
	  pbMessage(_INTL("Congratulations! You've earned {1} for reaching a Streak Milestone of {2}!", 
					  reward_names, $stats.wtp_highest_streak))
	end

end

	def pbWTP(*allowed_generations)
	  # If no generations are passed, use the default from WTPSettings
	  allowed_generations = WTPSettings::GENERATIONS_TO_CHOOSE_FROM if allowed_generations.empty?

	  wtp_scene = WTP_Scene.new(allowed_generations)
	  wtp_scene.pbStartScene
	end

  
  
  # Added Game Stats to keep a count of times correctly guessed
  class GameStats
    attr_accessor :wtp_correct_count
	attr_accessor :wtp_streak
	attr_accessor :wtp_highest_streak
  end

