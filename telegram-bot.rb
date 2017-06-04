# encoding: utf-8

require 'telegram/bot'
require 'mysql2'

base_url = "http://iplat.ujn.edu.cn/photo/"
TOKEN = "299913435:AAH0acebPnG2CuaXNU9mv2jwaKgprDbGzuQ"


def name_selector(str)
    client = Mysql2::Client.new(:host => '127.0.0.1',
                                :username => 'root',
                                :password => 'XuHefeng',
                                :database => 'student')

    select_sql = "SELECT stu_num,stu_name FROM info_old WHERE stu_name LIKE \'#{str}\'"
    result = client.query(select_sql)
    client.close
    result
end

Telegram::Bot::Client.run(TOKEN) do |bot|
    handle_thread = Thread.new do
        bot.listen do |message|
            begin
                substr = message.text.split(" ")
                next if substr[0] == nil
                command = substr[0].upcase
                case command
                when '/START'
                    if message.from.first_name != nil
                        bot.api.send_message(chat_id: message.chat.id, text: "Hello,#{message.from.first_name}SiJi")
                    else
                        bot.api.send_message(chat_id: message.chat.id, text: "Hello,welcome to use @ujnlaosijibot")
                    end
                when '/STOP'
                    if message.from.first_name != nil
                        bot.api.send_message(chat_id: message.chat.id, text: "Bye,#{message.from.first_name}")
                    else
                        bot.api.send_message(chat_id: message.chat.id, text: "Bye,maybe see you next time")
                    end
                when '/NAME'
                    if substr[1] == nil
                        bot.api.send_message(chat_id: message.chat.id, text: "你输入的Name是tan90")
                        next
                    end
                    result = name_selector(substr[1])
                    if result == nil
                        bot.api.send_message(chat_id: message.chat.id, text: "你输入的ID是tan90")
                        next
                    end
                    result.each do |elements|
                        e = elements["stu_num"]
                        t = elements["stu_name"]
                        bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                        bot.api.send_photo(chat_id: message.chat.id,
                            photo: "iplat.ujn.edu.cn/photo/#{e[1..4]}/#{e[1..-1]}.jpg",
                            caption: "#{t}")
                    end
                when '/NUM'
                    if substr[1] == nil
                        bot.api.send_message(chat_id: message.chat.id, text: "你输入的ID是tan90")
                        next
                    end
                    e = substr[1]
                    if e == "220141222124" || e == "20141222124"
                        bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                        bot.api.send_photo(chat_id: message.chat.id,
                            photo: "http://iplat.ujn.edu.cn/photo/2014/20141222100.jpg")
                        next
                    end

                    bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                    bot.api.send_photo(chat_id: message.chat.id, photo: "http://iplat.ujn.edu.cn/photo/#{e[1..4]}/#{e[1..-1]}.jpg") if e.size == 12
                    bot.api.send_photo(chat_id: message.chat.id, photo: "http://iplat.ujn.edu.cn/photo/#{e[0..3]}/#{e[0..-1]}.jpg") if e.size == 11
                when '/NAME@UJNPHOTOBOT'
                    if substr[1] == nil
                        bot.api.send_message(chat_id: message.chat.id, text: "你输入的Name是tan90")
                        next
                    end
                    result = name_selector(substr[1])
                    if result == nil
                        bot.api.send_message(chat_id: message.chat.id, text: "你输入的ID是tan90")
                        next
                    end
                    result.each do |elements|
                        e = elements["stu_num"]
                        t = elements["stu_name"]
                        bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                        bot.api.send_photo(chat_id: message.chat.id,
                            photo: "iplat.ujn.edu.cn/photo/#{e[1..4]}/#{e[1..-1]}.jpg",
                            caption: "#{t}")
                    end
                when '/NUM@UJNPHOTOBOT'
                    if substr[1] == nil
                        bot.api.send_message(chat_id: message.chat.id, text: "你输入的ID是tan90")
                        next
                    end
                    e = substr[1]
                    if e == "220141222124" || e == "20141222124"
                        bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                        bot.api.send_photo(chat_id: message.chat.id,
                            photo: "http://iplat.ujn.edu.cn/photo/2014/20141222100.jpg")
                        next
                    end

                    bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                    bot.api.send_photo(chat_id: message.chat.id, photo: "http://iplat.ujn.edu.cn/photo/#{e[1..4]}/#{e[1..-1]}.jpg") if e.size == 12
                    bot.api.send_photo(chat_id: message.chat.id, photo: "http://iplat.ujn.edu.cn/photo/#{e[0..3]}/#{e[0..-1]}.jpg") if e.size == 11
                end
            rescue Exception => e
                next
            end
        end
    end

    begin
        handle_thread.join
    rescue
        GC.start
        retry
    end
end
