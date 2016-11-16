require 'base64'
require 'sendgrid-ruby'
require 'pdfkit'
require 'tempfile'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'
include SendGrid

class Resend < ApplicationRecord

  def self.generate_barcode_img(numtoCode)
    barcode = Barby::Code128B.new(numtoCode)
    png = Barby::PngOutputter.new(barcode).to_png #Raw PNG data
    return png
  end

  def self.generate_ticket_pdf(personid)
    @person=Person.find(personid)
    @tournament=@person.tournament

    ticket_num= @person.ticket_number
    barcodepng= Resend.generate_barcode_img(ticket_num)
    tempbarcode=Tempfile.new([ticket_num.to_s, '.png'], "#{Rails.root.to_s}/tmp/")

    begin
      File.open(tempbarcode.path, 'wb') { |f| f.write barcodepng }
      # do something with image
      ac = ActionController::Base.new()
      html = ac.render_to_string('/signup/display_ticket', :locals => {:person => @person, :barcode => tempbarcode.path, :tournament => @tournament}, :layout => false)
      PDFKit.new(html).to_file('./ticket.pdf')
    ensure
      tempbarcode.close
      tempbarcode.unlink
    end
  end

  def self.send_email email_to, body, id
    @player = Person.find(id)

    @tournament = Tournament.where(id: @player.tournament_id).first

    @string = @tournament.name

    if body == ""
      @body = "Attached is your replacement ticket.\n\nThanks,\nTournament Management"
    else
      @body = body
    end

    @subject = "Replacement ticket for #{@string}"

    @string.downcase.gsub(/[^a-z0-9]/, '')

    from = Email.new(email: "admin@#{@string}.com")
    to = Email.new(email: email_to)
    subject = @subject
    content = Content.new(type: 'text/plain', value: @body)
    mail = SendGrid::Mail.new(from, subject, to, content)

    Resend.generate_ticket_pdf(id)

    attachment = SendGrid::Attachment.new()
    attachment.content = Base64.strict_encode64(File.open('./ticket.pdf', "rb").read)
    attachment.filename = "ticket.pdf"

    mail.attachments = attachment

    sg = SendGrid::API.new(api_key: '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')
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

  def self.send_password email_to, t_id

    @tournament = Tournament.find(t_id)

    @string = @tournament.name

    @subject = "Password for #{@string}"

    @password = @tournament.private_event_password

    @body = "The password for #{@string} is #{@password}.\n\nThanks,\nTournament Management"

    @string.downcase.gsub(/[^a-z0-9]/, '')

    from = Email.new(email: "admin@#{@string}.com")
    to = Email.new(email: email_to)
    subject = @subject
    content = Content.new(type: 'text/plain', value: @body)
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: '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')
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers

  end

end