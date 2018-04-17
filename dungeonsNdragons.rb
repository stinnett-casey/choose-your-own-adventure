class Game
	attr_accessor :whos_turn
	attr_accessor :winner
	attr_accessor :players

	def initialize
		@whos_turn = 1
		@winner = 0
		@players = Hash.new

		for i 1..3
			puts "What is your name, Player #{@whos_turn}?"
			name = gets
			puts "#{name}, which character will you be: 1 - Wizard, 2 - Warrior"
			player1Selection = gets
			
			if player1Selection == 1
				player1 = Wizard.new player1Name
			else
				player1 = Warrior.new player1Name
			end
		end
	end

	def add_player(player)
		@players << player
	end

	def change_player
		@whos_turn = (@whos_turn == 1 ? 2 : 1)
	end

	def setWinner(player)
		@winner = player
		@winner
	end
end

class Character
	attr_accessor :name
	attr_accessor :hp #75 is max
	attr_accessor :attack #30 is max
	attr_accessor :defense #300 is max

	def initialize(name)
		@name = name
	end

	def attackOpp(opponent)
		damage = @attack - opponent.defense
		opponent.hp -= damage
		damage
	end

	def printHP
		puts "#{@name}'s hp is now #{self.hp}"
	end
end

class Warrior < Character
	def initialize(name)
		super
		@hp = 75
		@attack = 25
		@defense = 15
	end
end

class Wizard < Character
	def initialize(name)
		super
		@hp = 70
		@attack = 15
		@defense = 10
	end
end

game = Game.new

puts "Let the battle begin!"
puts "#{player1Name} starts."

puts "1 - Attack Opponent\n2 - Run Away"
choice = gets
while choice !== 2

end