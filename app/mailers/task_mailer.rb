class TaskMailer < MandrillMailer::MessageMailer
  default from: 'mariavelandia@fluvip.com'

  def welcome_email(user)
    @user = user
    mandrill_mail(
      subject: "buajaaaj",
      to: "mariavelandia@fluvip.com",
      text: "Example text content",
      html: "<p>Example HTML content</p>",
      important: true,
      inline_css: true,
    )
  end
end
