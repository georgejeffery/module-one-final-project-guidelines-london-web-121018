require_relative '../config/environment'


require 'pry'
require 'rspotify'

def authenticate
  RSpotify.authenticate("71c2cbbd78344649836922adbd59e972", "637ac67349b84fbf9d3adc089b146366")
end

def get_date(name)
  birthdate = gets.chomp
  if (/([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/).match(birthdate)
    year,month,day = birthdate.split('-')
    if Date.valid_date?(year.to_i,month.to_i,day.to_i)
      date = Date.new(year.to_i,month.to_i,day.to_i)
      starsignid = Starsign.find_by(name:date.zodiac_sign).id
      user1 = User.create(name:name, birthdate:date, starsign_id: starsignid )

    else
      puts "Please enter a valid date"
      get_date(name)
    end
  else
    puts "Please enter a valid date"
    get_date(name)
  end
  #binding.pry

end

def user
  puts "Please enter your name"
  name = gets.chomp
  puts "....and birthdate: yyyy-mm-dd"
  get_date(name)

end

def genre(user1)
  genre = user1.starsign.genre
  puts "You are a #{user1.starsign.symbol} and should like #{genre.name}"
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
  user.songs.map{|song| song.name}
end

def play_first_song(user)

  if user.songs[0].preview_link != nil then
  filename = 'track1'
  url = user.songs[0].preview_link
  file = PullTempfile.pull_tempfile(url: url, original_filename: filename)
  Whirly.start do
    Whirly.status = "♫	♫	♫	"
      sleep 1
sleep 1
end

  system "afplay -t 7 #{file.path}"
  file.unlink
  else
  puts "NO SONG FOR YOU! Even the internet thinks you're terrible"
  end
end

def recommended_and_play(user1)
  puts "Here is your recommended playlist:"
  puts return_playlist(user1)
  puts "Press 1 to play the first song"
  if gets.chomp == "1" then
    play_first_song(user1)

    puts "That's it, now bugger off. Your ID is #{user1.id} if you wanna come again"
  else
    puts "Well, that's all folks, your ID is #{user1.id} if you wanna come again"
  end
end

def runner
  authenticate
  puts "Have you been here before? If so, please enter your ID, if not, say NO"
  id = gets.chomp
  returnuser = nil
  if id == "NO" then
    user1 = user
    # binding.pry
    genrechoice = genre(user1)

    make_songs(getRecommendations(genrechoice),user1)
    recommended_and_play(user1)
  elsif id.to_i == 0

    puts "I don't understand! Please enter an ID or the word NO."
    runner
  elsif !(User.exists?(:id => id))
    puts "I don't recognize that ID! Please try again"
    runner
  else
    returnuser = User.find(id)
    puts "Great! Nice to have you back, please choose an option"
    puts "Press 1 to display your songs"
    puts "Press 2 to delete your songs and choose some more"
    choice = gets.chomp
    if choice == "1"
      puts return_playlist(returnuser)
      puts "That's it, now bugger off. Your ID is #{returnuser.id} if you wanna come again"
    elsif choice == "2"
      returnuser.songs.delete_all
      genrechoice = genre(returnuser)
      make_songs(getRecommendations(genrechoice),returnuser)
      recommended_and_play(returnuser)
    else
      puts "BAD CHOICE YOU NAUGHTY PERSON"
      exit
    end
  end
end





runner
