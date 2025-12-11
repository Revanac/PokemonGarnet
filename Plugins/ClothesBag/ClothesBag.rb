#===============================================================================
#  Clothes Bag System – Pokémon Essentials v21.1
#  Features:
#    - Change outfits using a Key Item
#    - $player.outfit = outfit ID (0 = default)
#    - Outfit preview window
#    - Unlockable outfits (hide until unlocked)
#    - Separate male/female trainer sprites
#    - Trainer & battle sprites use POKEMONTRAINER_Garth/Amy
#    - Overworld sprites handled elsewhere (GTA_Garth/GTA_Amy)
#    - Catch bonuses and money bonuses using battle handlers (safe)
#===============================================================================

#===========================================================================
#  CLOTHESBAG OUTFITS
#  Format:
#  [ DisplayName, OutfitNumber, UnlockSwitch, CatchBonus%, MoneyBonus% ]
#  UnlockSwitch = 0 → always unlocked
#===========================================================================

CLOTHES_BAG_OUTFITS = [
  ["Default Outfit", 0, 0, 0, 0],
  ["Warm Weather",   1, 0, 0, 0],
  ["Cold Weather",   2, 0, 0, 0],
  ["Beach Outfit",   3, 0, 0, 0],
  ["Fancy Digs",     4, 0, 0, 20],   # +20% money
  ["School Uniform", 5, 0, 5, 5],
  ["Pro Duds",       6, 0, 10, 0],   # +10% catch rate
  ["Victory Suit",   7, 125, 10, 10],
  ["Champion Crown", 8, 130, 20, 20]
]

#===========================================================================
#  GET TRAINER SPRITE FOR PREVIEW/BATTLE
#===========================================================================

def get_trainer_sprite(outfit)
  base = $player.female? ? "POKEMONTRAINER_Amy" : "POKEMONTRAINER_Garth"
  return base if outfit == 0
  return "#{base}_#{outfit}"
end

#===========================================================================
#  APPLY OUTFIT
#===========================================================================

def apply_player_outfit(outfit)
  $player.outfit = outfit
end

#===========================================================================
#  PREVIEW WINDOW
#===========================================================================

class Window_ClothesPreview < Window_AdvancedTextPokemon
  def initialize(filename)
    super("")
    @sprite = filename
    self.width = 256
    self.height = 256
    self.x = Graphics.width - self.width - 16
    self.y = 16
    refresh
  end

  def refresh
    self.contents.clear
    return unless @sprite
    begin
      bmp = RPG::Cache.load_bitmap("Graphics/Trainers/", @sprite)
      x = (self.contents.width - bmp.width) / 2
      y = (self.contents.height - bmp.height) / 2
      self.contents.blt(x, y, bmp, bmp.rect)
    rescue
      self.contents.draw_text(0, 0, self.width, 32, "Missing sprite: #{@sprite}")
    end
  end

  def set_sprite(name)
    @sprite = name
    refresh
  end
end

#===========================================================================
#  ITEM HANDLER – CLOTHESBAG
#===========================================================================

ItemHandlers::UseInField.add(:CLOTHESBAG, proc { |item|
  names   = []
  numbers = []

  # Build list of *visible* unlocked outfits
  CLOTHES_BAG_OUTFITS.each do |name, id, sw, catch, money|
    next unless sw == 0 || $game_switches[sw]
    names   << name
    numbers << id
  end

  if names.empty?
    pbMessage("You haven't unlocked any outfits yet.")
    next 0
  end

  preview = Window_ClothesPreview.new(get_trainer_sprite(numbers.first))
  index = 0

  loop do
    index = pbMessage("Choose an outfit:", names, -1, nil, index)

    if index < 0
      preview.dispose
      pbMessage("\\se[Cancel]You decided not to change clothes.")
      next 0
    end

    outfit_id = numbers[index]
    outfit_name = names[index]

    preview.set_sprite(get_trainer_sprite(outfit_id))

    if pbConfirmMessage("Wear the #{outfit_name}?")
      apply_player_outfit(outfit_id)
      pbMessage("You changed into the #{outfit_name} outfit!")
      preview.dispose
      next 1
    end
  end
})

#===========================================================================
#  BATTLE HANDLER – CATCH RATE BONUS (SAFE)
#===========================================================================

BattleHandlers::ModifyCatchRate.add(:OUTFIT_BONUS,
  proc { |battle, battler, catch_rate|
    outfit = $player.outfit
    bonus = 0

    CLOTHES_BAG_OUTFITS.each do |name, id, sw, catch_bonus, money_bonus|
      bonus = catch_bonus if id == outfit
    end

    catch_rate = (catch_rate * (1 + bonus / 100.0)).to_i if bonus > 0
    next catch_rate
  }
)

#===========================================================================
#  BATTLE HANDLER – MONEY BONUS (SAFE)
#===========================================================================

BattleHandlers::MoneyGained.add(:OUTFIT_BONUS,
  proc { |battle, money|
    outfit = $player.outfit
    bonus = 0

    CLOTHES_BAG_OUTFITS.each do |name, id, sw, catch_bonus, money_bonus|
      bonus = money_bonus if id == outfit
    end

    money = (money * (1 + bonus / 100.0)).to_i if bonus > 0
    next money
  }
)
