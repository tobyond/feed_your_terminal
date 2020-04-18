# FeedYourTerminal

## What is this thing?

It's an rss feed reader for you terminal. It looks like ruby code.

## Why is this thing?

Why not?

## Usage

Certain assumptions, you have git, and ruby 2.3+ on your system.
The following instructions work for a unix based operating system, Mac OS, linux etc. May work in windows YMMV.


clone the gem:

```
git clone git@github.com:tobyond/feed_your_terminal.git
```

cd into the gem directory:

```
cd feed_your_terminal/
```

install the gem in your system:

```
bundle exec rake install:local

```

then you'll have the following commands:

```

# to see all commands
feed

# to add link to your rss feed (this must be done first after above installation, before all other feed commands)
feed add_link https://my-feed.com/rss

# to remove_link from your rss feed
feed remove_link https://my-feed.com/rss

# to get all your unread feeds
feed unread

# to mark all your unread feeds as read
feed mark_all_as_read
```
