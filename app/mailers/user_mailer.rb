class UserMailer < ActionMailer::Base
  default from: "koppanna@gmail.com"

  def confirmation_email(user)
    @user = user
    @url = user_confirm_url(@user, host: 'shiftschedulerapp.herokuapp.com')

    mail(to: @user.email, subject: "Finish your account registration!")
  end
end
