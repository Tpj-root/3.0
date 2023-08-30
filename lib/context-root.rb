module Sandbox
  class ContextRoot < ContextBase
    def initialize(game, shell)
      super(game, shell)
      @commands.merge!({
        "query"       => ["[query]", "Analyze queries and data dumps"],
        "net"         => ["[net]", "Network"],
        "prog"        => ["[prog]", "Programs"],
        "mission"     => ["[mission]", "Mission"],
        "world"       => ["[world]", "World"],
        "script"      => ["[script]", "Scripts"],
        "chat"        => ["[chat]", "Internal chat"],
        "buy"         => ["[buy]", "The buys"],
        "connect"     => ["connect", "Connect to the server"],
        "sid"         => ["sid", "Show session ID"],
        "trans"       => ["trans", "Language translations"],
        "settings"    => ["settings", "Application settings"],
        "nodes"       => ["nodes [id]", "Node types"],
        "progs"       => ["progs [id]", "Program types"],
        "missions"    => ["missions [id]", "Missions list"],
        "skins"       => ["skins", "Skin types"],
        "news"        => ["news", "News"],
        "hints"       => ["hints", "Hints list"],
        "experience"  => ["experience", "Experience list"],
        "builders"    => ["builders", "Builders list"],
        "goals"       => ["goals", "Goals types"],
        "shields"     => ["shields", "Shield types"],
        "ranks"       => ["ranks", "Rank list"],
        "countries"   => ["countries", "Contries list"],
        "new"         => ["new", "Create new account"],
        "rename"      => ["rename <name>", "Set new name"],
        "info"        => ["info <id>", "Get player info"],
        "detail"      => ["detail <id>", "Get detail player network"],
        "hq"          => ["hq <x> <y> <country>", "Set player HQ"],
        "skin"        => ["skin <skin>", "Set player skin"],
        "tutorial"    => ["tutorial <id>", "Set tutorial"],
        "email"       => ["email <email>", "Email subscribe"],
        "top"         => ["top <country>", "Show top ranking"],
        "cpgen"       => ["cpgen", "Cp generate code"],
        "cpuse"       => ["cpuse <code>", "Cp use code"],
        "stats"       => ["stats", "Show player statistics"],
      })
    end
    
    def exec(words)
      cmd = words[0].downcase
      case cmd

      when "query", "net", "prog", 
           "mission", "world", "script", 
           "chat", "buy"
        @shell.context = "/#{cmd}"
        return

      when "trans"
        if @game.transLang.empty?
          @shell.custom_puts "#{cmd}: No language translations"
          return
        end

        @shell.custom_puts "Language translations:"
        @game.transLang.each do |k, v|
          @shell.custom_puts " %-32s .. %s" % [k, v]
        end
        return
        
      when "settings"
        if @game.appSettings.empty?
          @shell.custom_puts "#{cmd}: No application settings"
          return
        end

        @shell.custom_puts "Application settings:"
        @game.appSettings.each do |k, v|
          @shell.custom_puts " %-32s .. %s" % [k, v]
        end
        return

      when "nodes"
        if @game.nodeTypes.empty?
          @shell.custom_puts "#{cmd}: No node types"
          return
        end

        unless words[1].nil?
          id = words[1].to_i
          unless @game.nodeTypes.key?(id)
            @shell.custom_puts "#{cmd}: No such node type"
            return
          end

          @shell.custom_puts "#{@game.nodeTypes[id]["name"]}:"
          @shell.custom_puts " %-5s %-10s %-4s %-5s %-7s %-5s %-5s %-5s %-5s" % [
            "Level",
            "Cost",
            "Core",
            "Exp",
            "Upgrade",
            "Conns",
            "Slots",
            "Firewall",
            "Limit",
          ]
          @game.nodeTypes[id]["levels"].each do |k, v|
            limit = @game.nodeTypes[id]["limits"].dig(k)
            if limit.nil?
              limits = @game.nodeTypes[id]["limits"].sort_by {|k, v| v}
              limit = limits.dig(-1, 1) || "-"
            end
            @shell.custom_puts " %-5d %-10d %-4d %-5d %-7d %-5d %-5d %-8d %-5s" % [
              k,
              v["cost"],
              v["core"],
              v["experience"],
              v["upgrade"],
              v["connections"],
              v["slots"],
              v["firewall"],
              limit,
            ]
          end
          return
        end

        @shell.custom_puts "Node types:"
        @game.nodeTypes.each do |k, v|
          @shell.custom_puts " %-2s .. %s" % [k, v["name"]]
        end
        return

      when "progs"
        if @game.programTypes.empty?
          @shell.custom_puts "#{cmd}: No program types"
          return
        end

        unless words[1].nil?
          id = words[1].to_i
          unless @game.programTypes.key?(id)
            @shell.custom_puts "#{cmd}: No such program type"
            return
          end

          @shell.custom_puts "#{@game.programTypes[id]["name"]}:"
          @shell.custom_puts " %-5s %-6s %-4s %-5s %-7s %-4s %-7s %-7s %-4s %-8s %-7s" % [
            "Level",
            "Cost",
            "Exp",
            "Price",
            "Compile",
            "Disk",
            "Install",
            "Upgrade",
            "Rate",
            "Strength",
            "Evolver",
          ]
          @game.programTypes[id]["levels"].each do |k, v|
            @shell.custom_puts " %-5d %-6d %-4d %-5d %-7d %-4d %-7d %-7d %-4d %-8d %-7d" % [
              k,
              v["cost"],
              v["experience"],
              v["price"],
              v["compile"],
              v["disk"],
              v["install"],
              v["upgrade"],
              v["rate"],
              v["strength"],
              v["evolver"],
            ]
          end
          return
        end

        @shell.custom_puts "Program types:"
        @game.programTypes.each do |k, v|
          @shell.custom_puts " %-2s .. %s" % [k, v["name"]]
        end
        return

      when "missions"
        if @game.missionsList.empty?
          @shell.custom_puts "#{cmd}: No missions list"
          return
        end

        unless words[1].nil?
          id = words[1].to_i
          unless @game.missionsList.key?(id)
            @shell.custom_puts "#{cmd}: No such mission"
            return
          end

          @shell.custom_puts "%-20s %d" % ["ID", id]
          @shell.custom_puts "%-20s %s" % ["Group", @game.missionsList[id]["group"]]
          @shell.custom_puts "%-20s %s" % ["Name", @game.missionsList[id]["name"]]
          @shell.custom_puts "%-20s %s" % ["Target", @game.missionsList[id]["target"]]
          @shell.custom_puts "%-20s %d, %d" % ["Coordinates", @game.missionsList[id]["x"], @game.missionsList[id]["y"]]
          @shell.custom_puts "%-20s %d (%s)" % ["Country", @game.missionsList[id]["country"], @game.countriesList.fetch(@game.missionsList[id]["country"].to_s), "Unknown"]
          @shell.custom_puts "%-20s %d" % ["Money", @game.missionsList[id]["money"]]
          @shell.custom_puts "%-20s %d" % ["Bitcoins", @game.missionsList[id]["bitcoins"]]
          @shell.custom_puts "Requirements"
          @shell.custom_puts " %-20s %s" % ["Mission", @game.missionsList[id]["requirements"]["mission"]]
          @shell.custom_puts " %-20s %d" % ["Core", @game.missionsList[id]["requirements"]["core"]]
          @shell.custom_puts "%-20s %s" % ["Goals", @game.missionsList[id]["goals"].join(", ")]
          @shell.custom_puts "Reward"
          @shell.custom_puts " %-20s %d" % ["Money", @game.missionsList[id]["reward"]["money"]]
          @shell.custom_puts " %-20s %d" % ["Bitcoins", @game.missionsList[id]["reward"]["bitcoins"]]
          @shell.custom_puts "Messages"
          @shell.custom_puts " %-20s %s" % ["Begin", @game.missionsList[id]["messages"]["begin"]]
          @shell.custom_puts " %-20s %s" % ["End", @game.missionsList[id]["messages"]["end"]]
          @shell.custom_puts " %-20s %s" % ["News", @game.missionsList[id]["messages"]["news"]]
          return
        end

        @shell.custom_puts "Missions list:"
        @game.missionsList.each do |k, v|
          @shell.custom_puts " %-4d .. %-15s %-15s %s" % [
                        k,
                        v["group"],
                        v["name"],
                        v["target"],
                      ]
        end
        return

      when "skins"
        if @game.skinTypes.empty?
          @shell.custom_puts "#{cmd}: No skin types"
          return
        end

        @shell.custom_puts "Skin types:"
        @game.skinTypes.each do |k, v|
          @shell.custom_puts " %-7d .. %s, %d, %d" % [
                        k,
                        v["name"],
                        v["price"],
                        v["rank"],
                      ]
        end
        return

      when "news"
        msg = "News"
        begin
          news = @game.cmdNewsGetList
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        news.each do |k, v|
          @shell.custom_puts "\e[34m%s \e[33m%s\e[0m" % [
                        v["date"],
                        v["title"],
                      ]
          @shell.custom_puts "\e[35m%s\e[0m" % [
                        v["body"],
                      ]
          @shell.custom_puts
        end
        return

      when "hints"
        if @game.hintsList.empty?
          @shell.custom_puts "#{cmd}: No hints list"
          return
        end

        @game.hintsList.each do |k, v|
          @shell.custom_puts " %-7d .. %s" % [
                        k,
                        v["description"],
                      ]
        end
        return

      when "experience"
        if @game.experienceList.empty?
          @shell.custom_puts "#{cmd}: No experience list"
          return
        end

        @game.experienceList.each do |k, v|
          @shell.custom_puts " %-7d .. %s" % [
                        k,
                        v["experience"],
                      ]
        end
        return

      when "builders"
        if @game.buildersList.empty?
          @shell.custom_puts "#{cmd}: No builders list"
          return
        end

        @game.buildersList.each do |k, v|
          @shell.custom_puts " %-7d .. %s" % [
                        k,
                        v["price"],
                      ]
        end
        return

      when "goals"
        if @game.goalsTypes.empty?
          @shell.custom_puts "#{cmd}: No goals types"
          return
        end

        @shell.custom_puts " %-4s %-20s %-6s %-7s %s" % [
          "Type",
          "Name",
          "Amount",
          "Credits",
          "Title",
        ]
        @game.goalsTypes.each do |type, goal|
          @shell.custom_puts " %-4d %-20s %-6d %-7d %s" % [
            type,
            goal["name"],
            goal["amount"],
            goal["credits"],
            goal["title"],
          ]
        end
        return

      when "shields"
        if @game.shieldTypes.empty?
          @shell.custom_puts "#{cmd}: No shield types"
          return
        end

        @game.shieldTypes.each do |k, v|
          @shell.custom_puts " %-7d .. %d, %s, %s" % [
                        k,
                        v["price"],
                        v["name"],
                        v["description"],
                      ]
        end
        return

      when "ranks"
        if @game.rankList.empty?
          @shell.custom_puts "#{cmd}: No rank list"
          return
        end

        @game.rankList.each do |k, v|
          @shell.custom_puts " %-7d .. %d" % [
                        k,
                        v["rank"],
                      ]
        end
        return

      when "countries"
        if @game.countriesList.empty?
          @shell.custom_puts "#{cmd}: No countries list"
          return
        end

        @game.countriesList.each do |k, v|
          @shell.custom_puts " %-3d .. %s" % [
                        k,
                        v,
                      ]
        end
        return

      when "connect"
        msg = "Language translations"
        begin
          @game.transLang = @game.cmdTransLang
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)
 
        msg = "Application settings"
        begin
          @game.appSettings = @game.cmdAppSettings
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        msg = "Node types and levels"
        begin
          @game.nodeTypes = @game.cmdGetNodeTypes
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        msg = "Program types and levels"
        begin
          @game.programTypes = @game.cmdGetProgramTypes
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        msg = "Missions list"
        begin
          @game.missionsList = @game.cmdGetMissionsList
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        msg = "Skin types"
        begin
          @game.skinTypes = @game.cmdSkinTypesGetList
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)
        
        msg = "Hints list"
        begin
          @game.hintsList = @game.cmdHintsGetList
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        msg = "Experience list"
        begin
          @game.experienceList = @game.cmdGetExperienceList
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        msg = "Builders list"
        begin
          @game.buildersList = @game.cmdBuildersCountGetList
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        msg = "Goals types"
        begin
          @game.goalsTypes = @game.cmdGoalTypesGetList
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        msg = "Shield types"
        begin
          @game.shieldTypes = @game.cmdShieldTypesGetList
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)
        
        msg = "Rank list"
        begin
          @game.rankList = @game.cmdRankGetList
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        msg = "Authenticate"
        begin
          auth = @game.cmdAuthIdPassword
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        @game.sid = auth["sid"]        
        return

      when "sid"
        if @game.sid.empty?
          @shell.custom_puts("#{cmd}: No session ID")
          return
        end
        @shell.custom_puts("SID: #{@game.sid}")
        return

      when "new"
        msg = "Player create"
        begin
          player = @game.cmdPlayerCreate
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        @shell.custom_puts("\e[1;35m\u2022 New account\e[0m")
        @shell.custom_puts("  ID: #{player["id"]}")
        @shell.custom_puts("  Password: #{player["password"]}")
        @shell.custom_puts("  Session ID: #{player["sid"]}")
        return

      when "rename"
        name = words[1]
        if name.nil?
          @shell.custom_puts("#{cmd}: Specify name")
          return
        end

        msg = "Player set name"
        begin
          @game.cmdPlayerSetName(@game.config["id"], name)
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)
        return

      when "info"
        id = words[1]
        if id.nil?
          @shell.custom_puts("#{cmd}: Specify ID")
          return
        end

        if @game.sid.empty?
          @shell.custom_puts("#{cmd}: No session ID")
          return
        end
        
        msg = "Player get info"
        begin
          profile = @game.cmdPlayerGetInfo(id)
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        @shell.custom_puts("\e[1;35m\u2022 Player info\e[0m")
        @shell.custom_puts("  %-15s %d" % ["ID", profile.id])
        @shell.custom_puts("  %-15s %s" % ["Name", profile.name])
        @shell.custom_puts("  %-15s \e[33m$ %d\e[0m" % ["Money", profile.money])
        @shell.custom_puts("  %-15s \e[31m\u20bf %d\e[0m" % ["Bitcoins", profile.bitcoins])
        @shell.custom_puts("  %-15s %d" % ["Credits", profile.credits])
        @shell.custom_puts("  %-15s %d" % ["Experience", profile.experience])
        @shell.custom_puts("  %-15s %d" % ["Rank", profile.rank])
        @shell.custom_puts("  %-15s %s" % ["Builders", "\e[37m" + "\u25b0" * profile.builders + "\e[0m"])
        @shell.custom_puts("  %-15s %d" % ["X", profile.x])
        @shell.custom_puts("  %-15s %d" % ["Y", profile.y])
        @shell.custom_puts("  %-15s %d" % ["Country", profile.country])
        @shell.custom_puts("  %-15s %d" % ["Skin", profile.skin])
        @shell.custom_puts("  %-15s %d" % ["Level", @game.getLevelByExp(profile.experience)])
        return

      when "detail"
        id = words[1]
        if id.nil?
          @shell.custom_puts("#{cmd}: Specify ID")
          return
        end

        if @game.sid.empty?
          @shell.custom_puts("#{cmd}: No session ID")
          return
        end
        
        msg = "Get net details world"
        begin
          detail = @game.cmdGetNetDetailsWorld(id)
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        @shell.custom_puts("\e[1;35m\u2022 Detail player network\e[0m")
        @shell.custom_puts("  %-15s %d" % ["ID", detail["profile"].id])
        @shell.custom_puts("  %-15s %s" % ["Name", detail["profile"].name])
        @shell.custom_puts("  %-15s \e[33m$ %d\e[0m" % ["Money", detail["profile"].money])
        @shell.custom_puts("  %-15s \e[31m\u20bf %d\e[0m" % ["Bitcoins", detail["profile"].bitcoins])
        @shell.custom_puts("  %-15s %d" % ["Credits", detail["profile"].credits])
        @shell.custom_puts("  %-15s %d" % ["Experience", detail["profile"].experience])
        @shell.custom_puts("  %-15s %d" % ["Rank", detail["profile"].rank])
        @shell.custom_puts("  %-15s %s" % ["Builders", "\e[37m" + "\u25b0" * detail["profile"].builders + "\e[0m"])
        @shell.custom_puts("  %-15s %d" % ["X", detail["profile"].x])
        @shell.custom_puts("  %-15s %d" % ["Y", detail["profile"].y])
        @shell.custom_puts("  %-15s %d" % ["Country", detail["profile"].country])
        @shell.custom_puts("  %-15s %d" % ["Skin", detail["profile"].skin])
        @shell.custom_puts("  %-15s %d" % ["Level", @game.getLevelByExp(detail["profile"].experience)])

        @shell.custom_puts
        @shell.custom_puts(
          "  \e[35m%-12s %-4s %-5s %-12s %-12s\e[0m" % [
            "ID",
            "Type",
            "Level",
            "Timer",
            "Name",
          ]
        )
        detail["nodes"].each do |k, v|
          @shell.custom_puts(
            "  %-12d %-4d %-5d %-12d %-12s" % [
              k,
              v["type"],
              v["level"],
              v["timer"],
              @game.nodeTypes[v["type"]]["name"],
            ]
          )
        end
        return

      when "hq"
        x = words[1]
        y = words[2]
        country = words[3]
        if x.nil? || y.nil? || country.nil?
          @shell.custom_puts("#{cmd}: Specify x, y, country")
          return
        end

        if @game.sid.empty?
          @shell.custom_puts("#{cmd}: No session ID")
          return
        end
        
        msg = "Set player HQ"
        begin
          @game.cmdSetPlayerHqCountry(@game.config["id"], x, y, country)
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)
        return

      when "skin"
        skin = words[1]
        if skin.nil?
          @shell.custom_puts("#{cmd}: Specify skin")
          return
        end

        if @game.sid.empty?
          @shell.custom_puts("#{cmd}: No session ID")
          return
        end
        
        msg = "Player set skin"
        begin
          response = @game.cmdPlayerSetSkin(skin)
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)
        return

      when "tutorial"
        tutorial = words[1]
        if tutorial.nil?
          @shell.custom_puts("#{cmd}: Specify tutorial")
          return
        end

        if @game.sid.empty?
          @shell.custom_puts("#{cmd}: No session ID")
          return
        end

        msg = "Player set tutorial"
        begin
          response = @game.cmdPlayerSetTutorial(tutorial)
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)
        return

      when "email"
        email = words[1]
        if email.nil?
          @shell.custom_puts("#{cmd}: Specify email")
          return
        end

        if @game.sid.empty?
          @shell.custom_puts("#{cmd}: No session ID")
          return
        end

        msg = "Email subscribe"
        begin
          response = @game.cmdEmailSubscribe(email)
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)
        return

      when "top"
        country = words[1]
        if country.nil?
          @shell.custom_puts("#{cmd}: Specify country")
          return
        end

        if @game.sid.empty?
          @shell.custom_puts("#{cmd}: No session ID")
          return
        end
        
        msg = "Ranking get all"
        begin
          top = @game.cmdRankingGetAll(country)
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        types = {
          "nearby" => "Players nearby",
          "country" => "Top country players",
          "world" => "Top world players",
        }

        types.each do |type, title|
          @shell.custom_puts("\e[1;35m\u2022 #{title}\e[0m")
          @shell.custom_puts(
            "  \e[35m%-12s %-25s %-12s %-7s %-12s\e[0m" % [
              "ID",
              "Name",
              "Experience",
              "Country",
              "Rank",
            ]
          )
          top[type].each do |player|
            @shell.custom_puts(
              "  %-12s %-25s %-12s %-7s %-12s" % [
                player["id"],
                player["name"],
                player["experience"],
                player["country"],
                player["rank"],
              ]
            )
          end
          @shell.custom_puts()
        end

        @shell.custom_puts("\e[1;35m\u2022 Top countries\e[0m")
        @shell.custom_puts(
          "  \e[35m%-7s %-12s\e[0m" % [
            "Country",
            "Rank",
          ]
        )
        top["countries"].each do |player|
          @shell.custom_puts(
            "  %-7s %-12s" % [
              player["country"],
              player["rank"],
            ]
          )
        end
        return

      when "cpgen"
        if @game.sid.empty?
          @shell.custom_puts("#{cmd}: No session ID")
          return
        end
        
        msg = "Cp generate code"
        begin
          code = @game.cmdCpGenerateCode(@game.config["id"], @game.config["platform"])
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        @shell.custom_puts("\e[1;35m\u2022 Generated code\e[0m")
        @shell.custom_puts("  Code: #{code}")
        return

      when "cpuse"
        code = words[1]
        if code.nil?
          @shell.custom_puts("#{cmd}: Specify code")
          return
        end

        if @game.sid.empty?
          @shell.custom_puts("#{cmd}: No session ID")
          return
        end
        
        msg = "Cp use code"
        begin
          data = @game.cmdCpUseCode(@game.config["id"], code, @game.config["platform"])
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        @shell.custom_puts("\e[1;35m\u2022 Account credentials\e[0m")
        @shell.custom_puts("  ID: #{data["id"]}")
        @shell.custom_puts("  Password: #{data["password"]}")
        return

      when "stats"
        if @game.sid.empty?
          @shell.custom_puts("#{cmd}: No session ID")
          return
        end

        msg = "Player stats"
        begin
          stats = @game.cmdPlayerGetStats
        rescue Trickster::Hackers::RequestError => e
          @shell.logger.error("#{msg} (#{e})")
          return
        end
        @shell.logger.log(msg)

        @shell.custom_puts("\e[1;35m\u2022 Player statistics\e[0m")
        @shell.custom_puts("  Rank: #{stats["rank"]}")
        @shell.custom_puts("  Experience: #{stats["experience"]}")
        @shell.custom_puts("  Level: #{@game.getLevelByExp(stats["experience"])}")
        @shell.custom_puts("  Hacks:")
        @shell.custom_puts("   Successful: #{stats["hacks"]["success"]}")
        @shell.custom_puts("   Failed: #{stats["hacks"]["fail"]}")
        @shell.custom_puts("   Win rate: #{(stats["hacks"]["success"].to_f / (stats["hacks"]["success"] + stats["hacks"]["fail"]) * 100).to_i}%")
        @shell.custom_puts("  Defenses:")
        @shell.custom_puts("   Successful: #{stats["defense"]["success"]}")
        @shell.custom_puts("   Failed: #{stats["defense"]["fail"]}")
        @shell.custom_puts("   Win rate: #{(stats["defense"]["success"].to_f / (stats["defense"]["success"] + stats["defense"]["fail"]) * 100).to_i}%")
        @shell.custom_puts("  Looted:")
        @shell.custom_puts("   Money: #{stats["loot"]["money"]}")
        @shell.custom_puts("   Bitcoins: #{stats["loot"]["bitcoins"]}")
        @shell.custom_puts("  Collected:")
        @shell.custom_puts("   Money: #{stats["collect"]["money"]}")
        @shell.custom_puts("   Bitcoins: #{stats["collect"]["bitcoins"]}")
        return
        
      end
      
      super(words)
    end
  end
end

