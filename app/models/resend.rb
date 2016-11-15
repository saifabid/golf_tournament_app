require 'sendgrid-ruby'
include SendGrid

class Resend < ApplicationRecord

  def self.send_email email_from, email_to
    from = Email.new(email: email_from)
    to = Email.new(email: email_to)
    subject = 'Organiser dashboard test'
    content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end
end