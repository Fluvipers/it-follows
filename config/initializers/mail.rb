ActionMailer::Base.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 587,
    :user_name => "vladimir@fluvip.com", 
    :password  => "XzqMKT7TlFd4R2C9hjNcLg",
    :domain    => 'heroku.com'
  }
ActionMailer::Base.delivery_method = :smtp

MandrillMailer.configure do |config|
  config.api_key = "XzqMKT7TlFd4R2C9hjNcLg"
end
