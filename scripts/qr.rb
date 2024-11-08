# Author: Arr0nst0n3
# Date: 15-11-2023
# Describe : This code to generate a QR code with the user ID, making it easy to scan and run the simulation.
# Usage : run qr <user_id>
# 
require 'rqrcode'

class Qr < Sandbox::Script
  def main
    if @args[0].nil?
      @logger.log("Specify player ID")
      return
    end

    id = @args[0].to_i

    simlink = Trickster::Hackers::SimLink.new(id)
    url = simlink.generate

    # Create a QR code from the URL
    qrcode = RQRCode::QRCode.new(url.to_s)  # Ensure the URL is converted to a string

    # You can customize the size and other options if needed
    png = qrcode.as_png(size: 480)

    # Generate the output filename based on the input player ID
    output_filename = "qrcode_#{id}.png"

    # Save or display the QR code with the dynamically generated filename
    File.open(output_filename, 'w') { |f| f.write(png.to_s) }

    @logger.log("QR code generated and saved as #{output_filename}")
  end
end

