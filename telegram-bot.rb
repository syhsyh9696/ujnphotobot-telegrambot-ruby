# encoding: utf-8

require 'telegram/bot'
require_relative 'Kernel'

base_url = "http://iplat.ujn.edu.cn/photo/"
TOKEN = "299913435:AAH0acebPnG2CuaXNU9mv2jwaKgprDbGzuQ"

Telegram::Bot::Client.run(TOKEN) do |bot|
    bot.listen do |message|
        substr = message.text.split(" ")
        if substr[0] == nil
            next
        end
        case substr[0]
        when '/start'
            if message.from.first_name != nil
                bot.api.send_message(chat_id: message.chat.id, text: "Hello,#{message.from.first_name}")
            else
                bot.api.send_message(chat_id: message.chat.id, text: "Hello,welcome to use @ujnphotobot")
            end
        when '/stop'
            if message.from.first_name != nil
                bot.api.send_message(chat_id: message.chat.id, text: "Bye,#{message.from.first_name}")
            else
                bot.api.send_message(chat_id: message.chat.id, text: "Bye,maybe see you next time")
            end
        when '/random'
            line = Unicorn::randomnum()
            fn = "#{line[0].to_s}.jpg"
            url = base_url + "#{line[0][1..4]}/" + fn[1..15]
            bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
            bot.api.send_photo(chat_id: message.chat.id, photo: "#{url}", caption: "#{line[0]}>>#{line[1]}>>#{line[2]}>>#{line[3]}")
        when '/random@ujnphotobot'
            line = Unicorn::randomnum()
            fn = "#{line[0].to_s}.jpg"
            url = base_url + "#{line[0][1..4]}/" + fn[1..15]
            #bot.api.send_message(chat_id: message.chat.id, text: "#{line}")
            bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
            bot.api.send_photo(chat_id: message.chat.id, photo: "#{url}", caption: "#{line[0]}>>#{line[1]}>>#{line[2]}>>#{line[3]}")
        when '/randomgirl'
            line = Unicorn::randomgirl()
            fn = "#{line.to_s}.jpg"
            url = base_url + "#{line[1..4]}/" + fn[1..15]
            bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
            bot.api.send_photo(chat_id: message.chat.id, photo: "#{url}")
        when '/randomgirl@ujnphotobot'
            line = Unicorn::randomgirl()
            fn = "#{line.to_s}.jpg"
            url = base_url + "#{line[1..4]}/" + fn[1..15]
            bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
            bot.api.send_photo(chat_id: message.chat.id, photo: "#{url}")
        when '/num'
            if substr[1] == nil
                bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                bot.api.send_message(chat_id: message.chat.id, text: "Can't find the student number")
                next
            end
            if Unicorn::checknumber(substr[1])
                stunum = substr[1].to_s
                url = base_url + "#{stunum[0..3]}/#{stunum}.jpg"
                bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                bot.api.send_photo(chat_id: message.chat.id, photo: "#{url}")
                Unicorn::numberlog(substr[1], message.from.username, message.from.first_name, message.from.last_name)
            else
                bot.api.send_chat_action(chat_id: message.chat.id, action: "typing")
                bot.api.send_message(chat_id: message.chat.id, text: "Can't find the student number")
                next
            end
        when '/help'
            bot.api.send_message(chat_id: message.chat.id, text: "#{Unicorn::help()}")
        when '/doge'
            url = base_url + "2014/20141222216.jpg"
            bot.api.send_photo(chat_id: message.chat.id, photo: "#{url}")
        when '/ha'
            bot.api.send_chat_action(chat_id: message.chat.id, action: "typing")
            bot.api.send_sticker(chat_id: message.chat.id, sticker: "BQADBQADBgADqno2BgFR4Dylw9eQAg")
            bot.api.send_message(chat_id: message.chat.id, text: "不要总想搞个大新闻")
        when '/ha@ujnphotobot'
            bot.api.send_chat_action(chat_id: message.chat.id, action: "typing")
            bot.api.send_sticker(chat_id: message.chat.id, sticker: "BQADBQADBgADqno2BgFR4Dylw9eQAg")
            bot.api.send_message(chat_id: message.chat.id, text: "不要总想搞个大新闻")
        when '/name'
            if substr[1] == nil
                bot.api.send_message(chat_id: message.chat.id, text: "Can't find the student name")
                next
            end
            line = Unicorn::checkname(substr[1])
            if line == nil
                bot.api.send_message(chat_id: message.chat.id, text: "Can't find the student name")
            elsif line.size == 1
                fn = "#{line[0][0].to_s}.jpg"
                url = base_url + "#{line[0][0][1..4]}/" + fn[1..15]
                bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                bot.api.send_photo(chat_id: message.chat.id, photo: "#{url}")
                Unicorn::namelog(substr[1], message.from.username, message.from.first_name, message.from.last_name)
            elsif line.size > 1
                bot.api.send_chat_action(chat_id: message.chat.id, action: "typing")
                bot.api.send_message(chat_id: message.chat.id, text: "一共有#{line.size}个名字为<<#{substr[1]}>>的人")
                line.size.times do |i|
                    fn = "#{line[i][0].to_s}.jpg"
                    url = base_url + "#{line[i][0][1..4]}/" + fn[1..15]
                    bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                    bot.api.send_photo(chat_id: message.chat.id, photo: "#{url}")
                end
                Unicorn::namelog(substr[1], message.from.username, message.from.first_name, message.from.last_name)
            end
        end
    end
end
