require 'colorize'
require 'rainbow'

class ComputerCode
    attr_reader :code
    def initialize
        @code = self.generate_code
    end

    def generate_code
        code = Array.new(4) { rand(1..6) }
    end
end

class User
    def initialize
        @codes = []
    end
end

def compare_code(comp_code, guess)
    if comp_code == guess
        p "You won"
    else
        #algorythm for clues
        # 0 == right number + right position
        # X == right number + wrong position
        # loop through both codes
        clues =[]
        guess.each_with_index do |g_num, index_g|
            # check two conditions 0 and X
            if comp_code.include?(g_num)
                if comp_code[index_g] == g_num
                    clues.push("0")
                else
                    clues.push("X")
                end
            end

        end
        p comp_code
        p clues
    end
end

def user_guess
    puts "Guess code"
    guess = gets.chomp.split('').map {|item| item.to_i}
    # Error handling: number not between 1 and 6
    # Error handling: too many numbers
end

#start game
## User is codebreaker
#computer generates code
comp_code = ComputerCode.new
#loops 12 times
12.times do
    #prompt user for guess
    puts "Guess code"
    guess = gets.chomp.split('').map {|item| item.to_i}
    #computer compares to its code return clues if incorrect else return victory
    compare_code(comp_code.code, guess)
    #prints clues and prompts user for guess
    #end loop
    
end


puts Rainbow("I am red").background(:red)



