require 'sinatra'
searchss = -> (input) {puts `man #{input}`}
@menus = {
    main: {
        '1' => {title: "Command Line", method: Proc.new { print_command_options }},
        '2' => {title: "Vim", method: Proc.new { print_command_options }},
        '3' => {title: "Search", method: Proc.new { search_commands }},
        '4' => {title: "Exit", method: Proc.new { puts "goodbye"; exit(0) }}
    },
    term_commands:{
        '1' => {name: "copy", command: "cp", example: "cp path/to/file path/to/destination"},
        '2' => {name: "move", command: "mv",  example: "cp path/to/file path/to/destination"},
        '3' => {name: "list directory contents", command:"ls", example: "ls directory"}
    }
}


get '/' do
  erb :index
end

get '/search' do
  erb :search
end

get '/command_line' do
  erb :command_line
end


searchss = -> (input) {puts `man #{input}`}

# #Array of hashes, can be added and program will adjust so long as it matches others
# @vim_options = [
#     {command: ':q[uit]', explanation: 'Quit Vim. This fails when changes have been made.' },
#     {command: ':wq', explanation: 'Write the current file and exit.' },
#     {command: ':wq {file}', explanation: 'Write to {file}. Exit if not editing the last' },
#     {command: ':e[dit]', explanation: 'Edit the current file. This is useful to re-edit the current file, when it has been changed outside of Vim.' }
# ]
# @menus = {
#     main: {
#         '1' => {title: "Command Line", method: Proc.new { print_command_options }},
#         '2' => {title: "Vim", method: Proc.new { print_command_options }},
#         '3' => {title: "Search", method: Proc.new { search_commands }},
#         '4' => {title: "Exit", method: Proc.new { puts "goodbye"; exit(0) }}
#     },
#     term_commands:{
#         '1' => {name: "copy", command: "cp", example: "cp path/to/file path/to/destination"},
#         '2' => {name: "move", command: "mv",  example: "cp path/to/file path/to/destination"},
#         '3' => {name: "list directory contents", command:"ls", example: "ls directory"}
#     }
# }

#main method is used to start program
#and to continue program until user
#quits
def main
  print_menu
  choice = gets.strip.downcase
  #puts @menus[:main][choice][:title]
  (1..@menus[:main].size).include?(choice.to_i) ?
      @menus[:main][choice][:method].call : invalid_input_message(choice)
  main
end

####CASE 1 -Command Line #####

#prints all terminal commands information
def print_command_options
  puts "#{"*"* 10}\nCommand Line\n"
  @menus[:term_commands].each do |index, cmd|
    puts "#{index}. #{cmd[:name]} - #{cmd[:command]} - #{cmd[:example]}"
  end
  puts "#{@menus[:term_commands].size + 1}. Main menu"
  print "make a selection:"
  get_command_option
end

#prints detailed command options if given than returns to main
#if command is not found displays not found message and return
#to main
def get_command_option
  command_index = nil
  #make sure input is integer > 0 and <= commands option + 1(Main Menu option)
  #raise and rescue error if not.
  while(command_index == nil)
    begin
      command_index = Integer gets.strip.to_i
      raise ArgumentError if command_index <= 0 || command_index > @menus[:term_commands].size + 1
    rescue
      puts "you did not enter valid input please enter 1-#{@menus[:term_commands].size + 1}"
      command_index = nil
    end
  end
  get_command_deatails(command_index)
end

#gets `man command` text
def get_command_deatails(command_index)
  #simply return if Main Menu option (@command_options.length+1)
  return nil if command_index == @menus[:term_commands].size + 1

  #print the `man cmd`
  puts command_index
  cmd = @menus[:term_commands][command_index.to_s][:command]
  puts `man #{cmd}`
end

####CASE 2 -Vim #####

#Prints vim commands and explanations
def print_vim_options
  puts "\nVIM COMMANDS\n"
  str = sprintf("%-25s", "COMMAND")
  puts "#{str} EXPLANATION"
  @vim_options.each do |opt|
    str = sprintf("%-25s", "#{opt[:command]}")
    puts "#{str} #{opt[:explanation]}"
  end
end

####CASE 3 -Search #####

#returns either man command info page or
#a not found message if command was not in
#the @xommand_options
def search_commands
  puts "Enter a command to search for"
  user_input = gets.strip
  #return `man command` if command is in @command_options
  @menus[:term_commands].each do |index, cmd|
    if(cmd[:name] == user_input || cmd[:command] == user_input)
      puts `man #{cmd[:command]}`
    end
  end
  "\n#{user_input} was not found try google".upcase
end

##### HELPERS ######
#print opening menu with selection prompt
def print_menu
  puts "\n#{"*"* 10}\nCheatSheet\n"
  @menus[:main].each do |index, option|
    puts"#{index}. #{option[:title]}"
  end
  print "make a selection:"
end

def invalid_input_message(input)
  puts "#{'!' * 20}"
  puts"#{input} is an incorrect option, try agian".upcase
  puts "#{'!' * 20}"
end

puts "#{key} #{value}"
#start program
main
#################

