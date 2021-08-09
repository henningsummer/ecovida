class ApplicationMailer < ActionMailer::Base
  default from: Rails.env.production? ? ENV['SMTP_DEFAULT_FROM'] : 'ecovida@ecovida.com'
end
