# encoding: utf-8

module Unicorn
    Version = "1.1"
    Author = "syhsyh9696"

    def randomnum()
        seed = Random.rand(24370) + 1
        File.open("student.ini", "r") do |io|
            while line = io.gets
                line.chomp!
                column = line.split()
                if io.lineno == seed
                    return column
                end
            end
        end
        return nil
    end

    def randomgirl()
        seed = Random.rand(12923) + 1
        File.open("student_girl.ini", "r") do |io|
            while line = io.gets
                line.chomp!
                if io.lineno == seed
                    return line
                end
            end
        end
        return nil
    end

    def help()
        temp = ("/start - Start this bot\n" +
                "/stop - Stop this bot\n" +
                "/random - Get random picture and profile\n" +
                "/randomgirl - Get random girl picture\n" +
                "/num - Get specify picture (/num 20130000000)\n" +
                "/name - Get specift picture ")
    end

    def checkname(name)
        array = Array.new
        File.open("student.ini", "r") do |io|
            while line = io.gets
                line.chomp!
                column = line.split()
                if name == column[1]
                    array << column
                end
            end
        end
        if array.size != 0
            return array
        else
            return nil
        end
    end

    def checknumber(num)
        File.open("student.ini", "r") do |io|
            while line = io.gets
                line.chomp!
                temp = line.split()
                if num == temp[0][1..11]
                    return true
                end
            end
        end
        return false
    end

    def namelog(line, username, first_name, last_name)
        time = Time.now
        io = File.open("slectedname.log", "a")
        io << "#{time.year}-#{time.month}-#{time.day} #{time.hour}:#{time.min}:#{time.sec}"
        io << " /#{username} #{first_name}_#{last_name}/" << " #{line}\n"
        io.close()
    end

    def numberlog(line, username, first_name, last_name)
        time = Time.now
        io = File.open("slectednumber.log", "a")
        io << "#{time.year}-#{time.month}-#{time.day} #{time.hour}:#{time.min}:#{time.sec}"
        io << " /#{username} #{first_name}_#{last_name}/" << " #{line}\n"
        io.close()
    end

    module_function :randomnum
    module_function :randomgirl
    module_function :help
    module_function :checkname
    module_function :checknumber
    module_function :namelog
    module_function :numberlog

end
