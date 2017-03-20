require 'fileutils'

module ApplicationHelper
	def is_admin?
    !session[:current_user][:email] && !session[:current_user][:user_identify] && !session[:current_user][:o365_email]
  end

  def get_user_photo_url(objectId)
  	if File.exist? "#{Rails.root}/public/photos/#{objectId}.jpg"
			photo_url = "/photos/#{objectId}.jpg"
		else
			# photo = HTTParty.get("https://graph.microsoft.com/v1.0/users/#{objectId}/photo/$value", headers: {
			# 	"Authorization" => "#{session[:token_type]} #{session[:gmc_access_token]}",
			# 	"Content-Type" => "application/x-www-form-urlencoded"
			# }).body

			# if photo.nil? || photo.empty?
			# 	FileUtils.cp("#{Rails.root}/public/Images/header-default.jpg", "#{Rails.root}/public/photos/#{objectId}.jpg")
			# else
			# 	File.open("#{Rails.root}/public/photos/#{objectId}.jpg", "wb") do |f|
			# 		f.write photo
			# 	end
			# end
			# photo_url = "/photos/#{objectId}.jpg"	
			SyncUserPhotoJob.perform_later(objectId, session[:token_type], session[:gmc_access_token], "#{Rails.root}/public/photos")
			photo_url = "/Images/header-default.jpg"
		end

		return photo_url
  end
end
