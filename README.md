# Telegram bot - @ujnphotobot
My simple ruby telegram bot for return UJN-students photo

# Requirements
You must have ruby 2.2.0 or 2.3.0 to launch server. Also you have to install requirements via 'gem':
```bash
gem install daemons
gem install telegram-bot-ruby
```
You also have to create token.ini to store you telegram-bot TOKEN

# Launching
To launch telegram bot
```bash
ruby telegram-bot-daemon.rb start
```
If this script deployed in PRC[People's Republic of China] you should use 'proxychains'

# Motivation
I find a API in my school websites but it has always really hard to look. So I decided to solve this problem by developing @ujnphotobot

# Contact Me
You can write me via telegram @syhsyh9696 if you have some questions.

# How wo use
In dialog box @ujnphotobot
```
/start                  #To start this bot
/stop                   #To stop this bot
/help                   #Get bot helper
/random                 #Get random individual image
/randomgirl             #Get random girl photo
/name + 'student name'  #Use name to find the photo
/num + 'student number' #Use number to find the photo
/doge                   #Extra command
/ha                     #Extra command
```
