class ReportSender < ApplicationMailer
  def report_sender(email, title, filename, relatory_name, relatory_mime = 'pdf')

    @relatory_name = title

    attachments.inline["#{relatory_name}.#{relatory_mime}"] = File.read(filename)

    mail(to: email, subject: title)
  end
end
