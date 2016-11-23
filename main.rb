require "optparse"
require "./export_skype_chat_log_to_html.rb"

if $0 == __FILE__

  options = {
    :mode => :list,
    :exportfile => nil,
    :chatname => nil,
  }

  OptionParser.new do |opts|
    opts.banner = "Usage: bundle exec ./#{$0} [options] path/to/main.db" 

    opts.on("-l", "--list", "Show chat rooms") do
      options[:mode] = :list
    end
    opts.on("-x", "--export=FILE", "Export to file") do |v|
      options[:mode] = :export
      options[:exportfile] = v
    end
    opts.on("-c", "--chatname=CHATNAME", "Filter with chatname") do |v|
      options[:chatname] = v
    end

    opts.on("-h", "--help", "Prints this help") do
      puts opts
      exit
    end
  end.parse!

  if ARGV[0].nil?
    $stderr << "No argument. Type bundle exec ./#{$0} -h\n"
    exit 1
  end
  unless File.exist?(ARGV[0])
    $stderr << "Could not open file: #{ARGV[0]}\n"
    exit 1
  end

  exporter = ExportSkypeChatLogToHTML.new(ARGV[0])
  if options[:mode] == :list
    exporter.chats.each do |v|
      $stdout << "\"#{v.name}\": #{v.friendlyname}\n"
    end
  elsif options[:mode] == :export
    File.open(options[:exportfile], "w") do |f|
      f.flock(File::LOCK_EX)
      exporter.export(options[:chatname], f)
    end
  end
end

