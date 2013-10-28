#!/usr/bin/env ruby

require 'tweetstream'


require 'oauth'

require 'sentimental'

require 'mongo'

include Mongo

CONSUMER_KEY        = "wVNq8OD84WGCU4ly3wzeg"
CONSUMER_SECRET     = "mhJMASHpNvbQUco9vIB8Eo04fzR9nQ7LCf5nH4dcHw"

OAUTH_TOKEN         = "49917710-IXh5cRQuV3LnkrFrmWkbbYauDfuaFmyQqki6Unvsa"
OAUTH_TOKEN_SECRET  = "DjYMzdjxmjM8IgghHMkWAnBBi220mdF5KyXKaIQbd3hht"

TweetStream.configure do |config|
  config.consumer_key       = CONSUMER_KEY
  config.consumer_secret    = CONSUMER_SECRET
  config.oauth_token        = OAUTH_TOKEN
  config.oauth_token_secret = OAUTH_TOKEN_SECRET
  config.auth_method        = :oauth
end

client = MongoClient.new("localhost",27017)
 
db = client.db("sentinal")

mongo_tsla_tweets = db.collection("tsla_tweets")

# Load the default sentiment dictionaries
Sentimental.load_defaults

# Set a global threshold
Sentimental.threshold = 0.1

# Create an instance for usage:
analyzer = Sentimental.new

analyzed = 0
net_score = 0

mongo_tsla_tweets.remove
# Use 'track' to track a list of single-word keywords
#TweetStream::Client.new.sample { |status|
TweetStream::Client.new.track(
    'TSLA','tesla','electric car','hybrid car')  { |status|
    
  score = analyzer.get_score status.text
  if (status.lang == "en" and score != 0)

    net_score = (net_score*analyzed + score)/ (analyzed+1)
    analyzed = analyzed + 1

    mongo_tsla_tweets.insert(
            "tweet" => status.text, 
            "time" => Time.now,
            "analyzed" => analyzed,
            "net_score" => net_score
            )

    puts "Text:[#{status.text}]"
    puts "SCORE:[#{score}]"
#     puts "Lang:[#{status.lang}]"
#     puts "User.location:[#{status.user.location}]"
#     puts "User.tz:[#{status.user.time_zone}]"
#     puts "User.geo_enabled:[#{status.user.geo_enabled}]"
#     puts "Source:[#{status.source}]"
#     puts "MetaData:[#{status.metadata}]"
#     puts "Place:[#{status.place}]"
#     puts "Geo:[#{status.geo}]"

    puts "net_score:[#{net_score}]"
    puts "analyzed:[#{analyzed}]"
    puts "\n\n"
  end

}
