# encoding: utf-8

require 'telegram/bot'
require 'mechanize'
require 'mysql2'
require 'json'
require 'pp'

def region_generator
    client = Mysql2::Client.new(:host => '127.0.0.1',
                                :username => 'root',
                                :password => 'XuHefeng',
                                :database => 'stats')
    province = client.query("SELECT num, name FROM xzqhdm_province").collect{ |x| x}
    city = client.query("SELECT num, name FROM xzqhdm").collect{ |x| x }
    client.close; result = {}
    (province + city).each do |item|
      result[item['num']] = item['name']
    end

    result
end

def get_api_info params
    base_url = "http://localhost:8080/api/v1/#{params}"
    page = Mechanize.new
    JSON.parse(page.get(base_url).body)
end

TOKEN = "299913435:AAH0acebPnG2CuaXNU9mv2jwaKgprDbGzuQ"
REGION = region_generator

def locate id
    return '' if id == '' || id == nil
    province = REGION[id[0..1]]; city = REGION["#{id[0..-3]}00"]; district = REGION[id]

    return province + city if district == nil
    return province + city + district if district != nil
end


Telegram::Bot::Client.run(TOKEN) do |bot|
    handle_thread = Thread.new do
        bot.listen do |message|
            substr = message.text.split(" ")
            next if substr[0] == nil
            command = substr[0].upcase
            case command
            when '/START'
                if message.from.first_name != nil
                    bot.api.send_message(chat_id: message.chat.id, text: "Hello,#{message.from.first_name} SiJi")
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
                result = get_api_info("student/name/#{substr[1]}")
                if result == []
                    bot.api.send_message(chat_id: message.chat.id, text: "你要找的人名不存在哦")
                    next
                end
                result.each do |elements|
                    e = elements["stu_num"]
                    t = elements["stu_name"]
                    i = elements["stu_id"][0..5]
                    l = locate(i)
                    bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                    bot.api.send_photo(chat_id: message.chat.id,
                        photo: "http://iplat.ujn.edu.cn/photo/#{e[0..3]}/#{e[0..-1]}.jpg",
                        caption: "#{t} \n地区: #{l} \n学号: #{e}")
                end
            when '/NUM'
                if substr[1] == nil
                    bot.api.send_message(chat_id: message.chat.id, text: "你输入的ID是tan90")
                    next
                end
                e = substr[1]
                bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                bot.api.send_photo(chat_id: message.chat.id, photo: "http://iplat.ujn.edu.cn/photo/#{e[1..4]}/#{e[1..-1]}.jpg") if e.size == 12
                bot.api.send_photo(chat_id: message.chat.id, photo: "http://iplat.ujn.edu.cn/photo/#{e[0..3]}/#{e[0..-1]}.jpg") if e.size == 11
            when '/NAME@UJNPHOTOBOT'
                if substr[1] == nil
                    bot.api.send_message(chat_id: message.chat.id, text: "你输入的Name是tan90")
                    next
                end
                result = get_api_info("student/name/#{substr[1]}")
                if result == []
                    bot.api.send_message(chat_id: message.chat.id, text: "你要找的人名不存在哦")
                    next
                end
                result.each do |elements|
                    e = elements["stu_num"]
                    t = elements["stu_name"]
                    i = elements["stu_id"][0..5]
                    l = locate(i)
                    bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                    bot.api.send_photo(chat_id: message.chat.id,
                        photo: "http://iplat.ujn.edu.cn/photo/#{e[0..3]}/#{e[0..-1]}.jpg",
                        caption: "#{t} \n地区: #{l} \n学号: #{e}")
                end
            when '/NUM@UJNPHOTOBOT'
                if substr[1] == nil
                    bot.api.send_message(chat_id: message.chat.id, text: "你输入的ID是tan90")
                    next
                end
                e = substr[1]
                bot.api.send_chat_action(chat_id: message.chat.id, action: "upload_photo")
                bot.api.send_photo(chat_id: message.chat.id, photo: "http://iplat.ujn.edu.cn/photo/#{e[1..4]}/#{e[1..-1]}.jpg") if e.size == 12
                bot.api.send_photo(chat_id: message.chat.id, photo: "http://iplat.ujn.edu.cn/photo/#{e[0..3]}/#{e[0..-1]}.jpg") if e.size == 11
            end
        end
    end

    handle_thread.join
end
