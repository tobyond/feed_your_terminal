RSpec.describe Db do
  let(:db) { Db.db }
  let(:skip_create?) { false }
  before do
    Db.create unless skip_create?
  end

  describe ".create" do
    subject { Db.create }
    let(:skip_create?) { false }
    let(:feeds) {
      [
        [0, "id", "INTEGER", 0, nil, 1],
        [1, "guid", "TEXT", 1, nil, 0],
        [2, "read", "BOOLEAN", 0, "0", 0],
        [3, "created_at", "DATETIME", 0, "CURRENT_TIMESTAMP", 0]
      ]
    }
    let(:feeds_index) {
      [
        [0, "idx_feeds_guid", 1, "c", 0],
        [1, "idx_feeds_id", 1, "c", 0],
        [2, "sqlite_autoindex_feeds_1", 1, "u", 0]
      ]
    }
    let(:links) {
      [
        [0, "id", "INTEGER", 0, nil, 1],
        [1, "url", "text", 1, nil, 0],
        [2, "created_at", "DATETIME", 0, "CURRENT_TIMESTAMP", 0]
      ]
    }
    let(:links_index) {
      [
        [0, "idx_links_url", 1, "c", 0],
        [1, "idx_links_id", 1, "c", 0],
        [2, "sqlite_autoindex_links_1", 1, "u", 0]
      ]
    }

    it "is expected to create the tables and indexes" do
      subject
      expect(db.execute("PRAGMA table_info(feeds);")).to eq(feeds)
      expect(db.execute("PRAGMA index_list(feeds);")).to eq(feeds_index)
      expect(db.execute("PRAGMA table_info(links);")).to eq(links)
      expect(db.execute("PRAGMA index_list(links);")).to eq(links_index)
    end
  end

  describe ".clean_db" do
    subject { Db.clean_db }
    let(:feeds) { [] }
    let(:feeds_index) { [] }
    let(:links) { [] }
    let(:links_index) { [] }

    it "is expected to create the tables and indexes" do
      subject
      expect(db.execute("PRAGMA table_info(feeds);")).to eq(feeds)
      expect(db.execute("PRAGMA index_list(feeds);")).to eq(feeds_index)
      expect(db.execute("PRAGMA table_info(links);")).to eq(links)
      expect(db.execute("PRAGMA index_list(links);")).to eq(links_index)
    end
  end

  describe ".read_link_array" do
    subject { Db.read_link_array }

    before do
      db.execute("INSERT INTO feeds (guid, read) VALUES ('this', 1), ('that', 1);")
    end

    it { is_expected.to eq(["this", "that"]) }
  end

  describe ".unread_link_array" do
    subject { Db.unread_link_array }

    before do
      db.execute("INSERT INTO feeds (guid, read) VALUES ('this', 0), ('that', 0);")
    end

    it { is_expected.to eq(["this", "that"]) }
  end

  describe ".unread_guid_count" do
    subject { Db.unread_guid_count }

    before do
      db.execute("INSERT INTO feeds (guid, read) VALUES ('this', 0), ('that', 0);")
    end

    it { is_expected.to eq(2) }
  end

  describe ".seed_feed" do
    subject { Db.seed_feed(["this"]) }

    it "is exepected to create a feed record" do
      subject
      expect(db.execute("SELECT COUNT(*) FROM feeds;").flatten.first).to eq(1)
    end
  end

  describe ".mark_feed_read" do
    subject { Db.mark_feed_read }
    before do
      db.execute("INSERT INTO feeds (guid, read) VALUES ('this', 0), ('that', 0);")
    end

    it "is exepected to mark all unread items read" do
      expect(db.execute("SELECT COUNT(*) FROM feeds WHERE read IS FALSE;").flatten.first).to eq(2)
      expect(db.execute("SELECT COUNT(*) FROM feeds WHERE read IS TRUE;").flatten.first).to eq(0)
      subject
      expect(db.execute("SELECT COUNT(*) FROM feeds WHERE read IS FALSE;").flatten.first).to eq(0)
      expect(db.execute("SELECT COUNT(*) FROM feeds WHERE read IS TRUE;").flatten.first).to eq(2)
    end 
  end

  describe ".all_links" do
    subject { Db.all_links }
    before do
      db.execute("INSERT INTO links (url) VALUES ('this'), ('that');")
    end

    it { is_expected.to contain_exactly("that", "this") }
  end

  describe "add_link" do
    subject { Db.add_link("this") }
    let(:skip_create?) { false }

    it "is expected to create the db and the link" do
      subject
      expect(db.execute("SELECT COUNT(*) FROM links;").flatten.first).to eq(1)
    end
  end

  describe "remove_link" do
    subject { Db.remove_link("this") }
    before do
      db.execute("INSERT INTO links (url) VALUES ('this'), ('that');")
    end

    it "is expected to remove the link" do
      expect(db.execute("SELECT COUNT(*) FROM links;").flatten.first).to eq(2)
      subject
      expect(db.execute("SELECT COUNT(*) FROM links;").flatten.first).to eq(1)
    end
  end
end
