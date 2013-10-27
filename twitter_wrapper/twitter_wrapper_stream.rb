#!/usr/bin/env ruby

require 'tweetstream'

require 'oauth'

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

# Use 'track' to track a list of single-word keywords
TweetStream::Client.new.sample { |status|
#TweetStream::Client.new.track('usa') do |status|
  puts "Text:[#{status.text}]"
  puts "User.location:[#{status.user.location}]"
  puts "User.tz:[#{status.user.time_zone}]"
  puts "User.geo_enabled:[#{status.user.geo_enabled}]"
  puts "Source:[#{status.source}]"
  puts "MetaData:[#{status.metadata}]"
  puts "Place:[#{status.place}]"
  puts "Geo:[#{status.geo}]"
  puts "\n\n"
}
