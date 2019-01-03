require_relative '../config/environment'
def authenticate
  RSpotify.authenticate("71c2cbbd78344649836922adbd59e972", "637ac67349b84fbf9d3adc089b146366")
end

def user
  puts "Please enter your stupid name"
  name = gets.chomp
  puts "....and stupid birthdate: yyyy-mm-dd"
  get_date(name)
end

def get_date(name)
  "-----------------"
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

def genre(user1)
  genre = user1.starsign.genre
  puts "You are a #{user1.starsign.name} " + Rainbow("#{user1.starsign.symbol}").red.bright + " and should like #{genre.name}. " + Rainbow("E-W-W-W-W-W-W-W").red.underline
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

def csvexport(user)
  puts "I guess you'd like a CSV copy of your playlist, you ungrateful wretch? Press " + Rainbow("1").yellow.underline + " for yes, and anything else to exit"
  puts "-----------------"
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
    puts "Well that's no fun!"
    puts "-----------------"
  end
end

def recommended_and_play(user1)
  puts "Here is your recommended playlist (it's going to be terrible, because " + Rainbow("YOU'RE").red.underline + " terrible):"
  return_playlist(user1)
  puts "Press " + Rainbow("1").yellow.bright.underline + " to play the first song"
  if gets.chomp == "1" then
      play_first_song(user1)
      puts "-----------------"
      csvexport(user1)
      puts "That's it, now bugger off. Your ID is #{user1.id} if you want to come again. We won't blame you if you don't."
      puts "-----------------"
  else
      puts "-----------------"
      csvexport(user1)
      puts "That's all folks, your ID is #{user1.id} if you want to come again. We won't blame you if you don't."
      puts "-----------------"
  end
end

def runner
  authenticate
  puts "Have you been here before? We really hope you haven't, because that's " + Rainbow("BORING").red.underline + ". If you have, please enter your ID, if not, say NO"
  puts "-----------------"
  id = gets.chomp
  returnuser = nil
  if id == "NO" then
    user1 = user
    #binding.pry
      genrechoice = genre(user1)
      make_songs(getRecommendations(genrechoice),user1)
      recommended_and_play(user1)
  elsif id.to_i == 0
    puts "I don't understand! Please enter an ID or the word NO."
    puts "-----------------"
    runner
  elsif !(User.exists?(:id => id))
    puts "I don't recognize that ID! Please try again"
    puts "-----------------"
    runner
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
      puts "-----------------"
    elsif choice == "2"
      returnuser.songs.delete_all
      genrechoice = genre(returnuser)
      make_songs(getRecommendations(genrechoice),returnuser)
      recommended_and_play(returnuser)
    else
      puts "BAD CHOICE YOU NAUGHTY PERSON"
      puts "-----------------"
      exit
    end
  end
end


runner
