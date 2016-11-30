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

  def self.send_email_with_ticket email_to, body, id
    @player = Person.find(id)

    @tournament = Tournament.where(id: @player.tournament_id).first

    if body == ""
      @body = "Attached is your replacement ticket.\n\nThanks,\nTournament Management"
    else
      @body = body
    end

    @subject = "Replacement ticket for #{@tournament.name}"

    from = Email.new(email: "admin@golftournamentapp.com")
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

    @subject = "Password for #{@tournament.name}"

    @password = @tournament.private_event_password

    @body = "The password for #{@tournament.name} is #{@password}.\n\nThanks,\nTournament Management"

    from = Email.new(email: "admin@golftournamentapp.com")
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

  def self.send_email email_to, body, id
    @player = Person.find(id)

    @tournament = Tournament.where(id: @player.tournament_id).first

    @subject = "Message from #{@tournament.name}"

    if body == ""
      @body = ""
    else
      @body = "The following is a message from the organizer of the tournament named: #{@tournament.name}\n\n#{body}"
    end

    from = Email.new(email: "admin@golftournamentapp.com")
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

  def self.organizer_balance id
    @tournament = Tournament.find(id)
    @organizer = Person.where(sprintf("tournament_id = %s AND is_organizer = 1", id)).first
    @organizer_user = User.find(@organizer.user_id)

    @subject = "Outstanding Balance for #{@tournament.name}"

    @body = "Dear Organizer,\n\nThere is an outstanding balance for #{@tournament.name}, please go to the following link and make the required payment. Note you will not be able to pay until the tournament has started.\n\n
              https://www.http://golf-tournament-app.herokuapp.com/organizer_payment/#{@tournament.id}\n\n
            Thanks,\nXXX Administration"

    from = Email.new(email: "admin@golftournamentapp.com")
    to = Email.new(email: @organizer_user.email)
    subject = @subject
    content = Content.new(type: 'text/plain', value: @body)
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: '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')
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

  def self.organizer_blocked id
    @person = User.find(id)

    @subject = "Outstanding Balances Exist in Your Account}"

    @body = "Dear Organizer,\n\nYou have outstanding balances for previous tournaments, and as a result will not be able to create any new tournaments. Please pay these balances and retry tournament creation./n/n
            Thanks,\nXXX Administration"

    from = Email.new(email: "admin@golftournamentapp.com")
    to = Email.new(email: @person.email)
    subject = @subject
    content = Content.new(type: 'text/plain', value: @body)
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: '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')
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

  def self.send_refund_request_email organizer_email, player_email, tournament_name
    @subject = "Request refund request"

    @body = "Dear Organizer, \n\n User with email #{player_email} has requested a refund for your tournament
            \"#{tournament_name}\".\n Please contact the player through the organizer dashboard to continue discussions\n
            of this refund\n\n Thank You, Golf Team"

    from = Email.new(email: "admin@golftournamentapp.com")
    to = Email.new(email: organizer_email)
    subject = @subject
    content = Content.new(type: 'text/plain', value: @body)
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: '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')
    sg.client.mail._('send').post(request_body: mail.to_json)
  end
end