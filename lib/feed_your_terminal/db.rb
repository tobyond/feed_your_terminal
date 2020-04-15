require "sqlite3"
class Db
  class << self
    attr_accessor :current_env

    def db
      @db ||= SQLite3::Database.new("feeds.db")
    end

    def db=(database)
      @db = database
    end

    def create
      db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS feeds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        guid TEXT NOT NULL,
        read BOOLEAN DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(id, guid)
      );
      SQL
      db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS links (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url text NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(id, url)
      );
      SQL
      db.execute "CREATE UNIQUE INDEX IF NOT EXISTS idx_feeds_id ON feeds (id);"
      db.execute "CREATE UNIQUE INDEX IF NOT EXISTS idx_feeds_guid ON feeds (guid);"
      db.execute "CREATE UNIQUE INDEX IF NOT EXISTS idx_links_id ON links (id);"
      db.execute "CREATE UNIQUE INDEX IF NOT EXISTS idx_links_url ON links (url);"
    end

    def clean_db
      db.execute "DROP TABLE IF EXISTS feeds;"
      db.execute "DROP TABLE IF EXISTS links;"
    end

    def read_link_array
      sql = "SELECT guid FROM feeds WHERE read IS TRUE;"
      db.execute(sql).flatten
    end

    def unread_link_array
      sql = "SELECT guid FROM feeds WHERE read IS FALSE;"
      db.execute(sql).flatten
    end

    def unread_guid_count
      sql = "SELECT COUNT(guid) FROM feeds WHERE read IS FALSE;"
      db.execute(sql).flatten.first
    end

    def seed_feed(guids)
      guids.each do |guid|
        sql = "INSERT OR IGNORE INTO feeds (guid) VALUES (?);"
        statement = db.prepare(sql)
        statement.bind_params(guid)
        statement.execute!
      end
    end

    def mark_feed_read
      sql = "UPDATE feeds SET read = 1 WHERE read IS FALSE;"
      statement = db.prepare(sql)
      statement.execute!
    end

    def all_feeds
      sql = "SELECT * FROM feeds;"
      db.execute(sql)
    end

    def all_links
      sql = "SELECT url FROM links;"
      db.execute(sql).flatten
    end

    def add_link(link)
      create
      sql = "INSERT OR IGNORE INTO links (url) VALUES (?);"
      statement = db.prepare(sql)
      statement.bind_params(link)
      statement.execute!
    end

    def remove_link(link)
      sql = "DELETE FROM links WHERE url = ?;"
      statement = db.prepare(sql)
      statement.bind_params(link)
      statement.execute!
    end

  end
end
