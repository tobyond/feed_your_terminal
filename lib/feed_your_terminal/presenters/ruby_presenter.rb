require 'thor/shell/color'

module Presenters
  class RubyPresenter < ::Thor::Shell::Color

    class << self
      def present(feed)
        return unless feed.is_a?(Array)

        line_number = 0
        puts (line_number+=1).to_s.ljust(6) + color.set_color("class", :magenta, :bold) + " " + color.set_color("RSSFeed", :cyan, :bold)
        feed.map do |rss|
          puts (line_number+=1).to_s.ljust(8)
          puts (line_number+=1).to_s.ljust(8) + "#{color.set_color("def", :yellow, :bold)} #{color.set_color(rss.title.snake, :white, :bold)}"
          puts (line_number+=1).to_s.ljust(10) + "\"#{color.set_color(rss.link, :blue)}\""
          puts (line_number+=1).to_s.ljust(8) + "#{color.set_color("end", :yellow, :bold)}"
        end
        puts line_number+=1
        puts (line_number+=1).to_s.ljust(6) + color.set_color("end", :cyan, :bold)
      end

      def color
        @color ||= Thor::Shell::Color.new
      end
    end
  end
end
