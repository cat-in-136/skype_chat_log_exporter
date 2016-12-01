# Skype Chat Log Exporter

Convert `~/.Skype/your_name/main.db` to a HTML file.

## How to use

How to install:

    % git clone https://github.com/cat-in-136/skype_chat_log_exporter.git
    % cd skype_chat_log_exporter
    % bundle install --path=vendor/bundle

How to convert:

    % bundle exec ruby main.rb -l '~/.Skype/alice/main.db'
    "#alice/$bob;112cf1c16c8bba58": alice | good evening!
    "#bob/$alice;21d79f257ac5b939": Cryptography Talking
    % bundle exec ruby main.rb -c %21d79f257ac5b939 -x ~/Desktop/Cryptography_Talking.html ~/.Skype/alice/main.db
    % firefox ~/Desktop/Cryptography_Talking.html

## Note

 * This project/app is just only a demonstration of showing the way to read a skype chat log file.
