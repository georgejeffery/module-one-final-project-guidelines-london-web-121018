require_relative '../config/environment'


require 'pry'
require 'rspotify'

def authenticate
  RSpotify.authenticate("71c2cbbd78344649836922adbd59e972", "637ac67349b84fbf9d3adc089b146366")
end

def user
  puts "Please enter your name"
  name = gets.chomp
  puts "....and birthdate: yyyy/mm/dd"
  birthdate = gets.chomp
  puts "-----------------"
  year,month,day = birthdate.split('/')
  date = Date.new(year.to_i,month.to_i,day.to_i)
  user1 = User.create(name:name, birthdate:date, starsign_id: Starsign.find_by(name:date.zodiac_sign).id )
  user1

end
def genre(user1)
  genre = user1.starsign.genre
  puts "You are a #{user1.starsign.name} " + Rainbow("#{user1.starsign.symbol}").red.bright + " and should like #{genre.name}"
  puts "-----------------"
  genre
end

def getRecommendations(genre)
  recommendations = RSpotify::Recommendations.generate(seed_genres: ["#{genre.name}"], limit:10)
end

def make_songs(getRecommendations,user)

  getRecommendations.tracks.each do |tracks|

        song = Song.create(name:tracks.name, artist_name: tracks.artists[0].name, preview_link: tracks.preview_url, spotify_link: tracks.external_urls["spotify"])
        UserSong.create(user_id:user.id, song_id:song.id)
    end
end

def return_playlist(user)
  
  user.songs.each do |song|
    puts Rainbow("♪ #{song.name}").red + " ----- " + Rainbow("#{song.artist_name} ♪").blue
  end
end

def play_first_song(user)

  if user.songs[0].preview_link != nil then
  filename = 'track1'
  url = user.songs[0].preview_link
  file = PullTempfile.pull_tempfile(url: url, original_filename: filename)

  system "afplay -t 7 #{file.path}"
  file.unlink
  else
  puts "NO SONG FOR YOU! Even the internet thinks you're terrible"
  end
end

def csvexport(user)
  puts "Would you like a csv of your playlist? Press " + Rainbow("1").yellow.underline + " for yes, and anything else to exit"

  if gets.chomp == "1" then
    CSV.open("playlist.csv", 'w') do |csv|
    csv << Song.column_names
      user.songs.each do |m|
        csv << m.attributes.values
      end
    end
    puts "Here you go!"
    system %{open 'playlist.csv'}
    puts "-----------------"
  else
    puts "Wrong choice!"
    puts "-----------------"
  end
end

def runner
  authenticate
  puts "Have you been here before? If so, please enter your ID, if not, say NO"
  puts "-----------------"
  id = gets.chomp
  returnuser = nil
  if id == "NO" then
    user1 = user
    #binding.pry
    make_songs(getRecommendations(genre(user1)),user1)
    puts "Here is your recommended playlist:"
    return_playlist(user1)
    puts "Press " + Rainbow("1").yellow.bright.underline + " to play the first song"
    if gets.chomp == "1" then
      play_first_song(user1)
      puts "-----------------"
      csvexport(user1)
      puts "That's it, now bugger off. Your ID is #{user1.id} if you want to come again. We won't blame you if you don't."
    else
      puts "-----------------"
      csvexport(user1)
      puts "Well, that's all folks, your ID is #{user1.id} if you want to come again. We won't blame you if you don't."
    end

  else
    returnuser = User.find(id)
    puts "Great! Please choose an option"
    puts "-----------------"
    puts "Press " + Rainbow("1").yellow.bright.underline + " to display your songs"
    puts "Press " + Rainbow("2").green.bright.underline + " to delete your songs and choose some more"
    choice = gets.chomp
    puts "-----------------"
    if choice == "1"
      return_playlist(returnuser)
      puts "-----------------"
      csvexport(returnuser)
      puts "That's it, now bugger off. Your ID is #{returnuser.id} if you want to come again. We won't blame you if you don't."
    elsif choice == "2"
      returnuser.songs.delete_all
      make_songs(getRecommendations(genre(returnuser)),returnuser)
      puts "Here is your recommended playlist:"
      return_playlist(returnuser)
      puts "Press 1 to play the first song"
      if gets.chomp == "1" then
        play_first_song(returnuser)
        puts "-----------------"
        csvexport(returnuser)
        puts "That's it, now bugger off. Your ID is #{returnuser.id} if you want to come again. We won't blame you if you don't."
      else
        puts "-----------------"
        csvexport(returnuser)
        puts "Well, that's all folks, your ID is #{returnuser.id} if you want to come again. We won't blame you if you don't."
      end
    else
      puts "BAD CHOICE YOU NAUGHTY PERSON"
      exit
    end
  end
end


runner
