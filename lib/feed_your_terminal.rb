require "feed_your_terminal/version"
require "feed_your_terminal/feed_methods"
require "feed_your_terminal/db"
require "feed_your_terminal/text_methods"
require "feed_your_terminal/presenters/ruby_presenter"
require "core_extensions/string/snake"

module FeedYourTerminal
  class Error < StandardError; end
end

String.include CoreExtensions::String::Snake
