require_relative "../res/hang_man_frames"
require 'yaml'

class GameFrame

    attr_accessor :index

    def initialize(index = 0)
        puts "init run in GF"
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

    def encode_with(coder)
        coder["index"] = @index    
        coder["frames"] = @frames
    end

    def self.init_with(coder)
        index = coder["index"]
        frames = coder["frames"]
    end

end #class end


class Game

    attr_accessor :gf, :word, :guessed_letters, :win

    def initialize(
                    gf,
                    word = File.open("./res/hangman_words.txt").readlines.sample.chomp.split(''),
                    guessed_letters = []
                    )
         
        @gf = gf
        @word = word
        @guessed_letters = guessed_letters
        @win = false
        display

    end

    def display
        system("clear")
        @gf.display
        @answer = @word.map {|letter| @guessed_letters.any?(letter) ? letter : "_" }.join
        puts @answer
        puts "Used letters: #{@guessed_letters.map(&:upcase).join(' ')}"
        #puts "Ans:\t #{@word.join}" 
        add_guess
        
    end

    def add_guess
        check_win
        adv = false
        puts "Type \"save\" to save game\nAdd a guess:\n"
        letter = gets.chomp.downcase
        if @guessed_letters.any?(letter)
            puts "You've used that letter already. Try another one."
            add_guess
    
        elsif letter == "" or letter == " "
            puts "Invalid selection"
            add_guess
        elsif letter.length > 1 and letter != "save"
            puts "One letter at a time, please"
            add_guess            
        elsif letter == "save"
            save
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

    def encode_with(coder)
        coder["gf"] = @gf   
        coder["word"] = @word
        coder["guessed_letters"] = @guessed_letters
    end

    def self.init_with(coder)
        gf = coder["gf"]
        word = coder["word"]
        guessed_letters = coder["guessed_letters"]
    end
    
    def save
        file_name = 'hg.sav'
        File.open(file_name, 'w') {|f| f.write(self.to_yaml)}
        puts "Saved as #{file_name}"
        exit
    end

    private

    def check_win
        if @answer.split('').any?("_") == false
            system("clear")
            puts "Congratulations!\nGame Over"            
            exit

        elsif @gf.index >= 6
            system("clear")
            puts "Sorry, You lose. Answer was #{@word.join}\nGame Over"
            exit
        end
    end

end #class end
 
#

puts "Load a game? y\/n :"
ans = gets.chomp.downcase.to_s

if ans == "n"
    a = Game.new(GameFrame.new)
    while !a.win do
        a.display
    end
else
    a = YAML.load(File.open('hg.sav'))
    while !a.win do
        a.display
    end
end


    

    
