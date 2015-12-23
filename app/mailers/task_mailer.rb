class TaskMailer < MandrillMailer::MessageMailer
  default from: 'no-reply@fluvip.com'

  def task_email(email, url)
    mandrill_mail(
      subject: "Ha sido mencionado en una tarea",
      to: email,
      text: "Example text content",
      html: "<p>Haga click en el siguiente enlace #{url}</p>",
      important: true,
      inline_css: true,
    )
  end
end
