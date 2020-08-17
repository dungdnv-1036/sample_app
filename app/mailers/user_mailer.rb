class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t(".subject_account_activate")
  end

  def password_reset
    @greeting = t ".mailer.hi"
    mail to: ENV["mail_to"]
  end
end
