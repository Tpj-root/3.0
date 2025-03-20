class Logsv2 < Sandbox::Script
  def main
    # TOP 50 IND status find
    id_list = [8008398, 4283975, 8387674, 13189744, 53795979, 5020217, 391467, 1483045, 1756867, 4354386, 4724850, 3519962, 8704324, 4240555, 3962693, 9501840, 9624507, 7908627, 42279, 1337807, 6109845, 4584424, 1699046, 2238404, 4168612, 4337962, 1477825, 3660116, 4977958, 2327387, 3894640, 1553520, 7964968, 2927996, 3753936, 1780509, 4708715, 4354332, 1574222, 1040221, 8870132, 3711473, 1785691, 5012315, 843640, 3213762, 1239167, 1323855, 6719932, 8257842] # Replace with your list or read from file
    
    File.open("output.log", "w") do |file|
      id_list.each do |id|
        if @game.sid.empty?
          @logger.log("No session ID")
          return
        end
        
        begin
          logs = @game.cmdFightByFBFriend(id)
        rescue Trickster::Hackers::RequestError => e
          @logger.error(e)
          next
        end
        
        hacks = logs.select { |_, v| v["attacker"]["id"] == id }
        hacks = hacks.to_a.reverse.to_h
        
        if hacks.any?
          file.puts("#{id}, ✅")
        else
          file.puts("#{id}, ❌")
        end
      end
    end
  end
end