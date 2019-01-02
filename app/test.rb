
require 'pull_tempfile'

url = "https://p.scdn.co/mp3-preview/ac0c6e28205e1cc4dbd8473f21431f4532120620?cid=774b29d4f13844c495f206cafdad9c86"
filename = "track1"

file = PullTempfile.pull_tempfile(url: url, original_filename: filename)

puts "♫...Playing your song now...♫"
system "afplay -t 7 #{file.path} "
puts "That's it!"
file.unlink 



hash = {
  "tracks": [
    {
      "album": {
        "album_type": "ALBUM",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/7sKxqpSqbIzphAKAhrqvlf"
            },
            "href": "https://api.spotify.com/v1/artists/7sKxqpSqbIzphAKAhrqvlf",
            "id": "7sKxqpSqbIzphAKAhrqvlf",
            "name": "Walker Hayes",
            "type": "artist",
            "uri": "spotify:artist:7sKxqpSqbIzphAKAhrqvlf"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/1MS0Fqde1LdgYnoxiUgLHe"
        },
        "href": "https://api.spotify.com/v1/albums/1MS0Fqde1LdgYnoxiUgLHe",
        "id": "1MS0Fqde1LdgYnoxiUgLHe",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/53d436397b533acf8b90b936da103415f8cea70a",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/fd6ff6ca325af8ed613b0c8dfa367cb6c8cd42da",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/9b8b33a9b5dc5e2f46154e4eb0ee7e15aced31cf",
            "width": 64
          }
        ],
        "name": "boom.",
        "type": "album",
        "uri": "spotify:album:1MS0Fqde1LdgYnoxiUgLHe"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/7sKxqpSqbIzphAKAhrqvlf"
          },
          "href": "https://api.spotify.com/v1/artists/7sKxqpSqbIzphAKAhrqvlf",
          "id": "7sKxqpSqbIzphAKAhrqvlf",
          "name": "Walker Hayes",
          "type": "artist",
          "uri": "spotify:artist:7sKxqpSqbIzphAKAhrqvlf"
        }
      ],
      "disc_number": 1,
      "duration_ms": 196666,
      "explicit": false,
      "external_ids": {
        "isrc": "QZ6U91600001"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/5jZF1nvKORdaHNjNNMRbFl"
      },
      "href": "https://api.spotify.com/v1/tracks/5jZF1nvKORdaHNjNNMRbFl",
      "id": "5jZF1nvKORdaHNjNNMRbFl",
      "is_playable": true,
      "name": "You Broke Up with Me",
      "popularity": 61,
      "preview_url": "https://p.scdn.co/mp3-preview/8657ebc6b66cc3b874446ddb562c5f764c1b501d?cid=774b29d4f13844c495f206cafdad9c86",
      "track_number": 3,
      "type": "track",
      "uri": "spotify:track:5jZF1nvKORdaHNjNNMRbFl"
    }
  ],
  "seeds": [
    {
      "initialPoolSize": 517,
      "afterFilteringSize": 517,
      "afterRelinkingSize": 511,
      "id": "classical",
      "type": "GENRE",
      "href": nil
    },
    {
      "initialPoolSize": 999,
      "afterFilteringSize": 626,
      "afterRelinkingSize": 611,
      "id": "country",
      "type": "GENRE",
      "href": nil
    }
  ]
}

hash[:"tracks"][0][:preview_url]
hash[:"tracks"][0][:artists][0][:name]
hash[:"tracks"][0][:name]

binding.pry

kfhlakjlskjdf