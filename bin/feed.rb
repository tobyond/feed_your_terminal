#!/usr/bin/env ruby -wU

require 'feed_your_terminal'
require 'thor'
class Feed < Thor
  package_name "Feed"

  desc "unread", "Unread items in feed"
  def unread
    not_read = FeedMethods.new.not_read
    return puts set_color("***** feed is empty *****", :red, :on_white) if not_read.empty?

    system("clear")
    line_number = 0
    puts (line_number+=1).to_s.ljust(6) + set_color("class", :magenta, :bold) + " " + set_color("RSSFeed", :cyan, :bold)
    not_read.map do |rss|
      puts (line_number+=1).to_s.ljust(8)
      puts (line_number+=1).to_s.ljust(8) + "#{set_color("def", :yellow, :bold)} #{set_color(snake(rss.title), :white, :bold)}"
      puts (line_number+=1).to_s.ljust(10) + "\"#{set_color(rss.link, :blue)}\""
      puts (line_number+=1).to_s.ljust(8) + "#{set_color("end", :yellow, :bold)}"
    end
    puts line_number+=1
    puts (line_number+=1).to_s.ljust(6) + set_color("end", :cyan, :bold)
  end

  desc "mark_all_as_read", "Mark all viewed items as read"
  def mark_all_as_read
    unread_count = Db.unread_guid_count
    puts set_color("#{unread_count} items have been marked read", :yellow) if Db.mark_feed_read
  end

  desc "db_all_links", "all links added to the db"
  def db_all_links
    print_table(Db.all_links)
  end

  desc "add_link URL", "add link added to the to your feed one at a time"
  def add_link(link)
    puts "++#{set_color(link, :blue)} added to you feeds" if Db.add_link(link)
  end

  desc "remove_link URL", "remove link added to the to your feed one at a time"
  def remove_link(link)
    puts "--#{set_color(link, :red)} removed from your feeds" if Db.remove_link(link)
  end

  no_commands do
    def snake(str)
      str.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr('-', '_').gsub(/\s/, '_').gsub(/__+/, '_').downcase.gsub(/[^0-9a-z _]/i, '')
    end
  end

end

Feed.start(ARGV)
