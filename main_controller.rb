require 'sinatra'
require 'pry'

##from stack overflow
def getInfo(text)
  output = []
  r, io = IO.pipe
  fork do
    system(text, out: io, err: :out)
  end
  io.close
  r.each_line{|l|  output << l.chomp}
  output
end

####GETS
get '/' do
  erb :index
end

get '/search' do
  @success = true
  erb :search
end

get '/command_line' do
    @term_commands = {
          '1' => {name: "copy", command: "cp", example: "cp path/to/file path/to/destination"},
          '2' => {name: "move", command: "mv",  example: "cp path/to/file path/to/destination"},
          '3' => {name: "list directory contents", command:"ls", example: "ls directory"}
      }
    erb :command_line
end

get '/command_line/:name' do
  text = "man #{params[:name]}"
  @output = getInfo(text)
  @success = @output.any?
  erb :command_line_info
end

#####POST
post '/search_for_command' do
  @text = "man #{params[:command]}"
  @output = getInfo(@text)
  @success = @output.any?
  if @success
    erb :command_line_info
  else
    erb :search
  end

end

post '/redirect' do
  redirect "https://www.google.com/#q=#{params[:command]}"
end










