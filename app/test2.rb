require 'pry'
require 'rspotify'

client_id = '6b7c62e4b1904346ab660fcb4441e22b'
client_secret = 'ba4ff394571c488b9bedbdb511503c13'



binding.pry

recommendations.tracks.each do |tracks|
  puts tracks.name
  puts tracks.preview_url
  puts tracks.artists[0].name
end

gehlkjls