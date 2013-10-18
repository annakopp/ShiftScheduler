class UserMailer < ActionMailer::Base
  default from: "admin@example.com"

  def confirmation_email(user)
    @user = user
    @url = confirm_url(code: @user.session_token, host: 'shiftschedulerapp.herokuapp.com')

    mail(to: @user.email, subject: "Finish your account registration!")
  end
end
