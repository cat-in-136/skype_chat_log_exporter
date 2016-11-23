require 'sqlite3'
require 'cgi'

class ExportSkypeChatLogToHTML

  def initialize(path_to_main_db)
    @path_to_main_db = path_to_main_db
    @chats = []
    load_main_db
  end
  attr_reader :chats

  def export(chat_room=nil, output=$stdout)
    SQLite3::Database.new(@path_to_main_db) do |db|
      db.results_as_hash = true
      keys = "id,chatname,author,from_dispname,timestamp,type,body_xml,chatmsg_type"
      cursor = (chat_room.nil?)? db.execute("SELECT #{keys} FROM Messages ORDER BY timestamp ASC") :
                                 db.execute("SELECT #{keys} FROM Messages WHERE chatname LIKE ? ORDER BY timestamp ASC", [chat_room])
      p cursor.length

      cursor.each do |tuple|
        tuple_data_attrs = []
        tuple.each do |key,value|
          unless key.to_s == /^([0-9]*|body_xml)$/
            tuple_data_attrs << "data-#{key.to_s.gsub('_','-')}=\"#{CGI::escapeHTML(value.to_s)}\""
          end
        end

        output << "<div class=\"message\" #{tuple_data_attrs.join(' ')}>\n"
        output << "<div class=\"author\">#{CGI::escapeHTML(tuple['author'].to_s)}</div>\n"
        output << "<div class=\"timestamp\">#{Time.at(tuple['timestamp'].to_i)}</div>\n"
        output << "<p>\n"
        output << tuple["body_xml"]
        output << "</p>\n"
        output << "</div>\n\n"
      end
    end
  end

  private
  def load_main_db
    SQLite3::Database.new(@path_to_main_db) do |db|
      db.results_as_hash = true
      cursor = db.execute("SELECT name, friendlyname, participants FROM Chats")
      cursor.each do |tuple|
        @chats << ChatInfo.new(tuple["name"], tuple["friendlyname"], tuple["participants"])
      end

      @chats.each do |chat|
        cursor = db.execute("SELECT COUNT(*) FROM Messages WHERE chatname = ?", [chat.name])
        chat.num_message = cursor[0][0].to_i
      end
      @chats.freeze
    end
  end

  class ChatInfo
    def initialize(name, friendlyname, participants)
      @name = name
      @friendlyname = friendlyname
      @participants = participants
    end

    attr_accessor :name
    attr_accessor :friendlyname
    attr_accessor :participants
    attr_accessor :num_message
  end

end
