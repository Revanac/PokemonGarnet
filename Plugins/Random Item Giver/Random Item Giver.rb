#===============================================================================
# Random Item Giver - Plugin for Pokémon Essentials
# Allows giving random items from predefined tiers with random quantities
# call: pbItemTIER, ex: pbItemCommon, pbItemUncommon, pbItemRare, pbItemSuperrare, pbItemMythical, pbItemlegendary
#===============================================================================

module RandomItemGiver
  # Define your item tiers here
  ITEM_TIERS = {
  :common => [
    [:POTION, :ANTIDOTE, :BURNHEAL, :ICEHEAL, :PARALYZEHEAL, :AWAKENING,
     :REPEL, :ESCAPEROPE, :FLUFFYTAIL, :HONEY, :TINYMUSHROOM,
     :FRESHWATER, :BERRYJUICE, :POKEBALL], 1, 3
  ],

  :uncommon => [
    [:SUPERPOTION, :FULLHEAL, :ENERGYPOWDER, :SWEETHEART,
     :SODAPOP, :LEMONADE, :MOOMOOMILK, :ETHER,
     :SUPERREPEL, :POKEDOLL, :SMOKEBALL, :CLEANSETAG,
     :PEARL, :BIGPEARL, :SPORTBALL, :NETBALL, :DIVEBALL, :NESTBALL, :REPEATBALL, :TIMERBALL,
     :LUXURYBALL, :PREMIERBALL, :DUSKBALL, :HEALBALL, :QUICKBALL, :CHERISHBALL, :FASTBALL,
     :LEVELBALL, :LUREBALL, :HEAVYBALL, :LOVEBALL, :FRIENDBALL, :MOONBALL, :DREAMBALL, :BEASTBALL], 1, 2
  ],

  :rare => [
    [:HYPERPOTION, :MAXPOTION, :ENERGYROOT, :RAGECANDYBAR,
     :HEALPOWDER, :LAVACOOKIE, :OLDGATEAU, :CASTELIACONE,
     :LUMIOSEGALETTE, :SHALOURSABLE, :BIGMALASADA,
     :MAXETHER, :ELIXIR, :MAXELIXIR, :REVIVE, :MAXREVIVE,
     :SACREDASH, :REVIVALHERB, :MAXREPEL,
     :XATTACK, :XDEFENS, :XSPATK, :XSPDEF, :XSPEED, :XACCURACY,
     :GUARDSPEC, :DIREHIT, :CALCIUM, :CARBOS, :IRON, :PROTEIN,
     :ZINC, :HPUP, :PPUP, :PPMAX, :RARECANDY, :EXPSHARE,
     :LUCKYEGG, :MACHOBRACE,
     :KINGSROCK, :METALCOAT, :DRAGONSCALE, :DEEPSEATOOTH,
     :DEEPSEASCALE, :UPGRADE, :DUBIOUSDISC, :RAZORCLAW,
     :RAZORFANG, :ELECTIRIZER, :MAGMARIZER, :PROTECTOR,
     :REAPERCLOTH, :PRISMSCALE], 1, 1
  ],

  :superrare => [
    [:WISHINGSTAR, :DYNAMAXCANDY, :DYNAMAXCANDYXL, :MAXSOUP,
     :NORMALTERASHARD, :FIRETERASHARD, :WATERTERASHARD,
     :ELECTRICTERASHARD, :GRASSTERASHARD, :ICETERASHARD,
     :FIGHTINGTERASHARD, :POISONTERASHARD, :GROUNDTERASHARD,
     :FLYINGTERASHARD, :PSYCHICTERASHARD, :BUGTERASHARD,
     :ROCKTERASHARD, :GHOSTTERASHARD, :DRAGONTERASHARD,
     :DARKTERASHARD, :STEELTERASHARD, :FAIRYTERASHARD,
     :STELLARTERASHARD, :RADIANTTERAJEWEL, :GREATBALL], 1, 1
  ],

  :mythical => [
    [:MYSTERYTERAJEWEL, :ZBOOSTER, :NORMALIUMZ, :FIGHTINIUMZ,
     :FLYINIUMZ, :POISONIUMZ, :GROUNDIUMZ, :ROCKIUMZ,
     :BUGINIUMZ, :GHOSTIUMZ, :STEELIUMZ, :FIRIUMZ,
     :WATERIUMZ, :GRASSIUMZ, :ELECTRIUMZ, :PSYCHIUMZ,
     :ICIUMZ, :DRAGONIUMZ, :DARKINIUMZ, :FAIRIUMZ,
     :BLACKAUGURITE, :PEATBLOCK, :LINKINGCORD,
     :AUSPICIOUSARMOR, :MALICIOUSARMOR, :SYRUPYAPPLE,
     :UNREMARKABLETEACUP, :METALALLOY, :ULTRABALL], 1, 1
  ],

  :legendary => [
    [:MASTERTERAJEWEL, :GLIMMERINGCHARM, :ADAMANTCRYSTAL,
     :LUSTROUSGLOBE, :GRISEOUSCORE, :LEGENDPLATE,
     :PIKANIUMZ, :PIKASHUNIUMZ, :ALORAICHIUMZ,
     :EEVIUMZ, :SNORLIUMZ, :MEWNIUMZ, :DECIDIUMZ,
     :INCINIUMZ, :PRIMARIUMZ, :LYCANIUMZ, :MIMIKIUMZ,
     :KOMMONIUMZ, :TAPUNIUMZ, :SOLGANIUMZ, :LUNALIUMZ,
     :MARSHADIUMZ, :ULTRANECROZIUMZ, :ORIGINBALL,
     :WELLSPRINGMASK, :HEARTHFLAMEMASK, :CORNERSTONEMASK,
     :TEALMASK, :INDIGODISK, :METEORITE], 1, 1
  ]
}


  # Give random items from a specific tier
  def self.give_random_items(tier, quantity = 1)
    return false unless ITEM_TIERS.has_key?(tier)
    
    items_list, min_qty, max_qty = ITEM_TIERS[tier]
    quantity.times do
      item = items_list.sample
      qty = rand(min_qty..max_qty)
      
      # Use pbReceiveItem instead of directly accessing $PokemonBag
      pbReceiveItem(item, qty)
    end
    return true
  end
end

#===============================================================================
# * Script Commands
#===============================================================================
def pbItemCommon(quantity = 1)
  RandomItemGiver.give_random_items(:common, quantity)
end

def pbItemUncommon(quantity = 1)
  RandomItemGiver.give_random_items(:uncommon, quantity)
end

def pbItemRare(quantity = 1)
  RandomItemGiver.give_random_items(:rare, quantity)
end

def pbItemSuperRare(quantity = 1)
  RandomItemGiver.give_random_items(:superrare, quantity)
end

def pbItemMythical(quantity = 1)
  RandomItemGiver.give_random_items(:mythical, quantity)
end

def pbItemLegendary(quantity = 1)
  RandomItemGiver.give_random_items(:legendary, quantity)
end