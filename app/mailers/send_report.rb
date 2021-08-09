class SendReport < ApplicationMailer
  def send_report(email, title, filename, relatory_name, relatory_mime = 'odt')

    @relatory_name = title

    attachments.inline["#{relatory_name}.#{relatory_mime}"] = File.read(filename)

    mail(to: email, subject: title)
  end
end
