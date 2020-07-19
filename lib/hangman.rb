require_relative "../res/hang_man_frames"


class GameFrame

    attr_reader :index
    def initialize(game,index = 0)
        @game = game
        @index = index
        @frames = Resources::HANGMANFRAMES        
    end

    def display
        puts @frames[@index].to_s
        
    end

    def advance
        @index = [@index + 1,@frames.length-1].min
        display 
    end
end


class Game

    attr_reader :win, :bad_guess_index

    def initialize(gf)
        @gf = gf
        @word = File.open("./res/hangman_words.txt").readlines.sample.chomp.split('')
        @guessed_letters = []
        @win = false
        display

    end

    def display
        system("clear")
        @gf.display
        @answer = @word.map {|letter| @guessed_letters.any?(letter) ? letter : "_" }.join
        puts @answer
        puts "Used letters: #{@guessed_letters.map(&:upcase).join(' ')}"
        puts "Ans:\t #{@word.join}" 
        add_guess
        
    end

    def add_guess
        check_win
        adv = false
        puts "Add a guess:\n"
        letter = gets.chomp.downcase
        if @guessed_letters.any?(letter)
            puts "You've used that letter already. Try another one."
            add_guess
    
        elsif letter == "" or letter == " "
            puts "Invalid selection"
            add_guess
    
        else
            @guessed_letters << letter
            adv = true
        end
        if @word.any?(letter) == false
            @gf.advance if adv
            adv = false
        end
        check_win
    end
   
    private

    def check_win
        if @answer.split('').any?("_") == false
            puts "Congratulations!\nGame Over"            
            exit

        elsif @gf.index >= 6
            puts "Sorry, You lose. Answer was #{@word.join}\nGame Over"
            exit
        end
    end
end
 
a = Game.new(GameFrame.new(self))

while !a.win do
    a.display
end
