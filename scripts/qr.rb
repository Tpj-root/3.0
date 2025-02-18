# Author: Arr0nst0n3
# Date: 15-11-2023
# Describe : This code to generate a QR code with the user ID, making it easy to scan and run the simulation.
# Usage : run qr <user_id>
# 
require 'rubygems'
begin
  require 'rqrcode'
rescue LoadError
  puts "rqrcode gem not found. Installing..."
  system('sudo gem install rqrcode')
  require 'rqrcode'
end

class Qr < Sandbox::Script
  def main
    if @args[0].nil?
      @logger.log("Specify player ID")
      return
    end

    id = @args[0].to_i

    simlink = Trickster::Hackers::SimLink.new(id)
    url = simlink.generate

    qrcode = RQRCode::QRCode.new(url.to_s)
    png = qrcode.as_png(size: 480)

    output_filename = "qrcode_#{id}.png"
    File.open(output_filename, 'wb') { |f| f.write(png.to_s) }

    @logger.log("QR code generated and saved as #{output_filename}")
  end
end

