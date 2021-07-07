class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.registration_confirmation.subject
  #
  def registration_confirmation(user)
    @user = user

    mail to: user.email, subject: "Registration Confirmation"
  end

  def forgot_password(user)
    @user = user
    @greeting = "Hi"

    mail to: user.email, :subject => "Reset password"
  end

  def order_confirmation
    @user, @order = params[:user], params[:order]
    mail(to: @user.email, subject: "Order Confirmed")
  end

  def order_delivered
    @user, @order = params[:user], params[:order]
    mail(to: @user.email, subject: "Order delivered!")
  end
end
