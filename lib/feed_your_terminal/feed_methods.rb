require 'rss'
class FeedMethods

  def urls
    @urls ||= Db.all_links
  end

  def feed
    @feed ||= begin
      urls.each_with_object([]) do |url, array|
        parsed = RSS::Parser.parse(url)
        next if invalid_feed?(parsed)

        rss_items = parsed.channel.items
        array.push(*rss_items)
      end
    end
  end

  def invalid_feed?(items)
    items.nil? ||
      !items.respond_to?(:channel) ||
      items&.channel.nil? ||
      !items.channel.respond_to?(:items) ||
      items.channel&.items.nil? ||
      items.channel.items.empty?
  end

  def links
    @links ||= feed.map { |item| item.link }
  end

  def not_read
    Db.seed_feed(links)
    feed.reject { |item| read_links.include?(item.link) }
  end

  def read_links
    @read_links ||= Db.read_link_array
  end

end
