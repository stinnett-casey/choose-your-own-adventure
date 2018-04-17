class Character
	attr_accessor :name
	attr_accessor :type
	attr_accessor :weapon
	attr_accessor :hp
	attr_accessor :mp
	attr_accessor :defense
	attr_accessor :melee_attack
	attr_accessor :magic_attack
	attr_accessor :dexterity # for dodging

	def initialize
		@type = self.to_s[self.to_s.index("<") + 1, self.to_s.index(":") - 2]
	end

	def stats
		# return instance_variables.map {|var| "#{var}: #{instance_variable_get(var)}"}
		stats_string = "#{@type} HP: #{@hp} MP: #{@mp}\n"
		stats_string += "Weapon: #{@weapon}\n"
		stats_string += "\n"
		return stats_string
	end

	def attack(opponent, attack_type)
		damage = 0
		o_def = opponent.defense

		if attack_type.to_i == 1 # melee
			damage = @melee_attack - o_def unless @melee_attack - o_def < 0
		else # magic
			damage = @magic_attack - o_def unless @magic_attack - o_def < 0
		end

		if damage > 0
			opponent.hp -= damage	
		end

		damage		
	end

	def defend
		
	end

	def run
		
	end

	def is_alive
		@hp > 0
	end
	
end # end character

class Player < Character
	attr_accessor :dungeon
	attr_accessor :currRow
	attr_accessor :currCol
	attr_accessor :in_boss_room

	def initialize
		super
		@dungeon = Dungeon.new
		@currRow = 0
		@currCol = 0
		@in_boss_room = false
	end
	
	def move(direction)

		case direction
		when "u"
			if !hitthewall(@currRow - 1)
				@currRow -= 1
			end
		when "d"
			if !hitthewall(@currRow + 1)
				@currRow += 1
			end
		when "l"
			if !hitthewall(@currCol - 1)
				@currCol -= 1
			end
		when "r"
			if !hitthewall(@currCol + 1)
				@currCol += 1
			end
		else 
			puts "That is not an option"
		end
		@in_boss_room = true if @currRow == @dungeon.dungeon_length - 1 && @currCol == @dungeon.dungeon_length - 1
		@dungeon.print(@currRow, @currCol)
	end

	def hitthewall(movement)
		if movement < 0 || movement > @dungeon.dungeon_length - 1
			puts "Ouch! You ran into the wall."
			return true
		end
		return false
	end
	
end

# Defense max: 100
# Attack max: 200
# Dexterity max: 100 
class Wizard < Player
	def initialize
		super
		@hp = 70
		@mp = 100
		@defense = 40
		@melee_attack = 80
		@magic_attack = 150
		@dexterity = 60
		@weapon = "Basic Staff"
	end
	
	
end # end Wizard

class Barbarian < Player
	def initialize
		super
		@hp = 200
		@mp = 20
		@defense = 65
		@melee_attack = 150
		@magic_attack = 20
		@dexterity = 25
		@weapon = "Double-Handed Sword"
	end
	
	
end #end Barbarian

class Dwarf < Player
	def initialize
		super
		@hp = 180
		@mp = 50
		@defense = 80
		@melee_attack = 125
		@magic_attack = 30
		@dexterity = 20
		@weapon = "Hammer"
	end
	
	
end # end Dwarf


class Dungeon
	attr_accessor :dungeon_length
	attr_accessor :cleared

	def initialize
		@cleared = false
		@dungeon_arr = []
		@dungeon_length = 5

		@dungeon_length.times {|i|
			rowArr = []

			@dungeon_length.times do 
				rowArr << "   |"
			end

			@dungeon_arr << rowArr
		}
	end

	# prints this
	#		  0   1   2   3   4
	#		 --- --- --- --- ---
	#	0	|   |   |   |   |   |
	#		 --- --- --- --- ---
	#	1	|   |   |   |   |   |
	#		 --- --- --- --- ---
	#	2	|   |   | x |   |   |
	#		 --- --- --- --- ---
	#	3	|   |   |   |   |   |
	#		 --- --- --- --- ---
	#	4	|   |   |   |   |   |
	#		 --- --- --- --- ---
	
	def print(currRow = 0, currCol = 0)
		dungeon_string = ""

		@dungeon_arr.each_with_index {|row, rowIndex|
			@dungeon_length.times do 
				dungeon_string += " ---"
			end
			if rowIndex == 0
				dungeon_string += "\n "
			else
				dungeon_string += "\n|"
			end
			 

			row.each_with_index {|room, colIndex|
				if rowIndex == currRow && colIndex == currCol
					dungeon_string += room.gsub(/\s{3}/, " x ")
				else
					dungeon_string += room
				end

			}

			puts dungeon_string
			dungeon_string = ""			
		}

		@dungeon_length.times do 
			dungeon_string += " ---"
		end

		puts dungeon_string
	end # end def print

end # end Dungeon

# Tells you if there is an enemy, which one 
# If there is treasure, what kind
class Room
	attr_accessor :fight_enemy
	attr_accessor :enemy
	attr_accessor :find_treasure
	attr_accessor :treasure

	def initialize(currRow, currCol, dungeon_length, boss = false)
		dec_likelihood = (dungeon_length*2 - (currRow + currCol))
		inc_likelihood = (currRow + currCol)*2

		if boss
			@fight_enemy = true	
			@find_treasure = true
		else
			@fight_enemy = choose_weighted({true => dec_likelihood, false => inc_likelihood})
			@find_treasure = choose_weighted({true => inc_likelihood, false => dec_likelihood})
		end
		
		@enemy = "" if @fight_enemy

		@treasure = "" if @find_treasure
	end

	def choose_weighted(weighted)
	  sum = weighted.inject(0) do |sum, item_and_weight|
	    sum += item_and_weight[1]
	  end
	  target = rand(sum)
	  weighted.each do |item, weight|
	    return item if target <= weight
	    target -= weight
	  end
	end

end # end Room

class Enemy < Character
	def initialize
		super
		@hp = 30
		@mp = 15
		@defense = 25
		@melee_attack = 25
		@magic_attack = 40
		@dexterity = 30
		@weapon = "Teeth"
	end
	
	
end

# Run the game!

puts "Welcome to the Dark Elven Dungeon!"
puts "It's been said that the spirit of King Älv still lives here."
puts "The Human, King Crest, has asked you to dispel King Älv's spirit\nso there will be peace in his kingdom again."
puts "What is your name, worthy Champion?"
name = gets.chomp

print %x{clear}
puts "Ho, #{name}! Welcome. And what character will you be?"
puts "Hint: Type the first letter of character type you want to be."
puts " "#For readability

puts Wizard.new.stats
puts Barbarian.new.stats
puts Dwarf.new.stats

char_choice = gets.chomp

while char_choice != "w" && char_choice != "b" && char_choice != "d"
	puts "That's not an option. Try again."
	Wizard.new.stats
	Barbarian.new.stats
	Dwarf.new.stats
	char_choice = gets.chomp
end

character = Character.new;

case char_choice
when "w"
	character = Wizard.new

when "b"
	character = Barbarian.new

when "d"
	character = Dwarf.new
else
	puts 
end
character.name = name

print %x{clear}
puts "Ok, #{character.name} the #{character.type}! Let's do this."
puts "You have entered the dungeon."
puts character.stats

character.dungeon.print(character.currRow, character.currCol)

# Move through the dungeon
while !character.dungeon.cleared
	puts "Move which direction? (Up = 'u', Down = 'd', etc.)"
	direction = gets.chomp
	character.move(direction)

	room = Room.new(character.currRow, character.currCol, character.dungeon.dungeon_length, character.in_boss_room)
		
	if room.fight_enemy
		puts "You met an enemy! Time to fight."
		enemy = Enemy.new
		puts enemy.stats

		while enemy.hp > 0 && character.hp > 0
			puts "Choose your attack (1:melee, 2:magic)"
			attack_type = gets.chomp

			damage = character.attack(enemy, attack_type)

			if enemy.is_alive
				puts "Nice hit! You did #{damage}!\n"
				puts enemy.stats
				puts "Enemy attacks. It does #{enemy.attack(character, 1)} damage!\n"
			else
				print %x{clear}
				puts "You killed #{enemy.type}! Nice one!\n"
				puts character.dungeon.print
			end

			if character.is_alive
				puts character.stats
			else
				puts "Dude, you died."
				abort
			end
		end

	else
		puts "Whew! There were no enemies in here. Keep moving."
	end
	if character.currRow == character.dungeon.dungeon_length - 1 && character.currCol == character.dungeon.dungeon_length - 1
		character.dungeon.cleared = true 
	end
end






