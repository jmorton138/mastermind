require 'colorize'
require 'rainbow'
require 'pry'

class ComputerCode
    attr_reader :code
    
    @@guess = []
    @@wrong_positions = []

    def initialize
        @code = self.generate_code
    end

    def self.guess_getter
        @@guess
    end

    def self.guess_setter=(guesses)
        @@guess = guesses
    end

    def self.wrong_positions
        @@wrong_positions
    end

    def self.wrong_positions=(array)
        @@wrong_positions = array
    end

    def generate_code
        #first guess random
        if @@guess == []
            @@guess = Array.new(4) { rand(1..6) }
        #next guesses based on previous guess
        else
            @@guess.each_with_index do |num, index| 
                if num == nil
                    if @@wrong_positions == []
                        @@guess[index] = rand(1..6)
                    else
                        @@guess[index] = @@wrong_positions.shuffle.first
                    end
                else
                    num = num
                end
            end
        end     
    end

    
end

class UserCode
    attr_accessor :code

    def initialize(code)
        @code = code
    end
end

class GameType
    attr_accessor :type

    def initialize(type)
        @type = type
    end
end


def start_game
    # Ask user if code maker or code breaker
    puts "Do you want to be code maker(press 1) or breaker(press 2)?"
        
    game_type = gets.chomp.to_i
    game_type = GameType.new(game_type)

    until game_type.type == 1 || game_type.type == 2 do
        puts "Please enter in valid option"
        game_type = gets.chomp.to_i
        game_type = GameType.new(game_type)
    end

    if game_type.type == 1 
        #user creates code to be broken
        puts "Please create a 4 digit code from 1-6"
        code = gets.chomp.split('').map {|item| item.to_i}
        code_length_error(code)
        code = UserCode.new(code)
    elsif game_type.type == 2
        #start game with user as codebreaker
        #computer generates code to broken
        code = ComputerCode.new   
    end

    #run game passing in code and game type
    run_game(code, game_type)
    play_again
end

def run_game(code, game_type)
    loss = true
    12.times do
        if game_type.type == 1
            #computer's guess, first time random
            # puts "before"
            # puts guess
            guess = ComputerCode.new.generate_code
        elsif game_type.type == 2  
            #prints clues and prompts user for guess
            puts "Make a guess."
            guess = gets.chomp.split('').map {|item| item.to_i}
            code_length_error(guess)
        end
        
        if !compare_code(code.code, guess, game_type)
            loss = false
            break 
        end
    end
    #handle no solutions wins
    if loss
        if game_type.type == 1
            p "Computer failed to crack your code. You won."
        # User wins
        elsif game_type.type == 2   
            p "You've run out of turns. The computer won."
        end
    end


end

def compare_code(code, guess, game_type)

    if code == guess
        #Computer wins
        if game_type.type == 1
            p "Computer won"
            ComputerCode.guess_setter=([])
        # User wins
        elsif game_type.type == 2   
            p "You won"
        end
        return false
    else
        #Give clues to user or computer
        # 0 == right number + right position, X == right number + wrong position
        clues = []
        comp_clues = []
        almost_correct = []
        guess.each_with_index do |g_num, index_g|
            # check two conditions 0 and X
            if code.include?(g_num)
                if code[index_g] == g_num
                    clues.push("0")
                    comp_clues[index_g] = g_num
                else
                     comp_clues[index_g] = nil
                end
            else
                comp_clues[index_g] = nil
            end
        end

        # after this loop is complete do new loop ignoring, indexes already solved for
        guess.each_with_index do |j_num, index_j|
            #disqualitfy correct guesses in comp_clues
            if code.include?(j_num) & !almost_correct.include?(j_num) 
                if comp_clues.include?(j_num)
                    # check item isn't a duplicate before pushing to array
                    if index_j != comp_clues.index(j_num) && comp_clues.count(j_num) < code.count(j_num)
                        # binding.pry
                        clues.push("X")
                        almost_correct.push(j_num) 
                    end
                else
                    clues.push("X")
                    almost_correct.push(j_num) 
                end
            end
        end
        correct_guesses = ComputerCode.guess_setter=(comp_clues)
        wrong_indexes = ComputerCode.wrong_positions=(almost_correct)
  
        # p wrong_indexes
        #p clues
        clues.each do |clue|
            if clue == "0" 
                print Rainbow("•").color(:green).bright + " "
            elsif clue == "X"
                print Rainbow("•").color(:yellow).bright + " "
            end
            # if clue == clues[clues.length]
            #     puts "/n"
            # end
        end
        puts ""
        puts code
        clues
    end
end

def play_again
    puts "Do you want to play another game (yes or no)?"
    answer = gets.chomp
    until answer == "yes" || answer == "no"
        puts "Please enter 'yes' or 'no'"
        answer = gets.chomp
    end
    if answer == "yes"
        start_game
    elsif answer == "no"
        return
    end
end

def how_to_play
    puts "How To Play Mastermind".underline #underline
    puts ""
    puts "Mastermind is a codebreaking game. You can either be the code maker or the code breaker. If you're the code maker, you choose a sequence of four numbers/colors that the computer will try to crack. If you're the code breaker, the computer will create a number/color sequence for you to crack."
    puts ""
    puts "Clues".underline
    puts ""
    puts "With each guess you'll get clues about the code. Every #{Rainbow("•").color(:green).bright} means you have 1 correct number/color in the correct place. Every #{Rainbow("•").color(:yellow).bright} means you have 1 correct number/color, but in the incorrect place."
    
end


def code_length_error(code)
    until code.length == 4 && code.all? {|item| item >=1 && item <=6 }
        puts "Please enter a valid code -- 4 digits between 1 and 6"
        code = gets.chomp.split('').map {|item| item.to_i}
    end
end

puts Rainbow("•").color(:red)

how_to_play
start_game





puts Rainbow("I am red").background(:red)



