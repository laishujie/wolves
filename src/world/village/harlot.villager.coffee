{Villager} = Wolves.Village

class Wolves.Village.Harlot extends Villager

  @population: (players)-> switch on
    when players in [8..20] then 1

  can: (time)->
    super time, if time is 'night' then ['visit']

  visit: (someone)->
