class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def confirmation_email(user)
    @user = user
    @url = user_confirm_url(@user, host: 'localhost:3000')

    mail(to: @user.email, subject: "Finish your account registration!")
  end
end
