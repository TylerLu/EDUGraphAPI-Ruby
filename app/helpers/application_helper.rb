module ApplicationHelper
	def is_admin?
		# p session[:current_user]
    !session[:current_user][:email] && !session[:current_user][:user_identify] && !session[:current_user][:o365_email]
  end
end
