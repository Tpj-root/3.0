require "readline"
require "thread"
require "json"
require "base64"
#require "colorize"
    
require "context"
require "context-root"
require "context-query"
require "context-script"
require "context-net"
require "context-prog"
require "context-mission"
require "context-world"
require "context-chat"
require "context-buy"

module Sandbox
  class Shell
    DATA_DIR = "data"

    attr_reader :logger
    attr_accessor :context, :reading

    def initialize(game)
      @game = game
      @context = "/"
      @contexts = {
        "/"         => ContextRoot.new(@game, self),
        "/query"    => ContextQuery.new(@game, self),
        "/net"      => ContextNet.new(@game, self),
        "/prog"     => ContextProg.new(@game, self),
        "/mission"  => ContextMission.new(@game, self),
        "/world"    => ContextWorld.new(@game, self),
        "/script"   => ContextScript.new(@game, self),
        "/chat"     => ContextChat.new(@game, self),
        "/buy"      => ContextBuy.new(@game, self),
      }

      @logger = Logger.new(self)
      @logger.logPrefix = "\e[1;32m\u2714\e[22;32m "
      @logger.logSuffix = "\e[0m"
      @logger.errorPrefix = "\e[1;31m\u2718\e[22;31m "
      @logger.errorSuffix = "\e[0m"
      @logger.infoPrefix = "\e[1;37m\u2759\e[22;37m "
      @logger.infoSuffix = "\e[0m"

      Readline.completion_proc = Proc.new do |text|
        @contexts[@context].completion(text)
      end

      @game.countriesList = Config.new("#{DATA_DIR}/countries.conf")
      @game.countriesList.load
    end
#######################################
## OLD
    # def puts(data = "")
    #   $stdout.puts("\e[0G\e[J#{data}")
    #   Readline.refresh_line if @reading
    # end
#######################################
# This code was modified by Arr0nst0n3 from India
# 1.0
# Under windows 11 testing process
# 
    def custom_puts(data = "")
      if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
        # Windows platform
        puts(data)
      else
        # Unix-like platform
        $stdout.puts("\e[0G\e[J#{data}")
#1.0
#        $stdout.puts("\e[0G\e[J#{data}".colorize(:default))
#        Readline.refresh_line if @reading
#
#
#2.0 try 
#        puts("\e[0G\e[J#{data}")
#        Readline.refresh_line if defined? Readline.refresh_line && @reading
#3.0 work perfect in all unix
        # Unix-like platform
        #puts("\e[0G\e[J#{data}")
        begin
            Readline.refresh_line if defined?(Readline.refresh_line) && @reading
        rescue NotImplementedError
        # Handle the case where refresh_line is not implemented
        #puts("\e[0G\e[J#{data}")
        end
##########
      end
    end
    

#######################################
    def readline
      loop do
        prompt = "#{@context} \e[1;35m\u25b8\e[0m "
        @reading = true
        line = Readline.readline(prompt, true)
        @reading = false
        exit if line.nil?
        line.strip!
        Readline::HISTORY.pop if line.empty?
        next if line.empty?
        exec(line)
      end
    end
    
    def exec(line)
      words = line.scan(/['"][^'"]*['"]|[^\s'"]+/)
      words.map! do |word|
        word.sub(/^['"]/, "").sub(/['"]$/, "")
      end
      @contexts[@context].exec(words)
    end
  end

  class Config < Hash
    attr_accessor :file

    def initialize(file)
      @file = file
    end

    def load
      data = JSON.parse(File.read(@file))
      return unless data.class == Hash
      self.merge!(data)
    end

    def save
      File.write(@file, JSON.pretty_generate(self))
    end
  end

  class Logger
    attr_accessor :logPrefix, :errorPrefix, :infoPrefix,
                  :logSuffix, :errorSuffix, :infoSuffix

    def initialize(shell)
      @shell = shell
      @logPrefix = String.new
      @logSuffix = String.new
      @errorPrefix = String.new
      @errorSuffix = String.new
      @infoPrefix = String.new
      @infoSuffix = String.new
    end

    def log(message)
      @shell.custom_puts(@logPrefix + message.to_s + @logSuffix)
    end

    def error(message)
      @shell.custom_puts(@errorPrefix + message.to_s + @errorSuffix)
    end

    def info(message)
      @shell.custom_puts(@infoPrefix + message.to_s + @infoSuffix)
    end
  end

  ##
  # Parent class for scripts
  class Script
    ##
    # Creates new script:
    #   game    = Game
    #   shell   = Shell
    #   logger  = Logger
    #   args    = Arguments
    def initialize(game, shell, logger, args)
      @game = game
      @shell = shell
      @logger = logger
      @args = args
    end

    ##
    # Script entry point
    def main
    end

    ##
    # Executes after the script finished
    def finish
    end
  end
end

