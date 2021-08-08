class MailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id,func_name,order_id=nil)
    user=User.find(user_id)
    # print(new_user.email)
    if func_name=="forgot_password"
      UserMailer.forgot_password(user).deliver
    elsif func_name=="registration_confirmation"
      UserMailer.registration_confirmation(user).deliver
    elsif func_name=="order_confirmation"
      order=Order.find(order_id)
      UserMailer.order_confirmation(order,user).deliver
    elsif func_name=="order_delivered"
      order=Order.find(order_id)
      UserMailer.order_delivered(order,user).deliver
    elsif func_name=="order_cancelled"
      order=Order.find(order_id)
      UserMailer.order_cancelled(order,user).deliver
    end
  end
end
