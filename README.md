# FeedYourTerminal

## What is this thing?

It's an rss feed reader for you terminal. It looks like ruby code.

## Why is this thing?

Why not?

## Usage

clone the gem, cd into directory.
run in the directory:

```
# to see all commands
bundle exec bin/feed.rb

# to add link to your rss feed
bundle exec bin/feed.rb add_link https://my-feed.com/rss

# to remove_link from your rss feed
bundle exec bin/feed.rb remove_link https://my-feed.com/rss

# to get all your unread feeds
bundle exec bin/feed.rb unread

# to mark all your unread feeds as read
bundle exec bin/feed.rb mark_all_as_read
```
