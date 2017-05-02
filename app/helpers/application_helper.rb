# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

require 'fileutils'

module ApplicationHelper
	def get_request_schema
		"#{(is_http = request.headers['HTTP_X_ARR_SSL'].blank?) ? request.protocol : 'https://' }#{request.host}:#{is_http ? request.port : 443}"
	end

	def is_admin?
    (session[:roles] || []).include? 'Admin'
  end

  def get_user_photo_url(objectId)
  	if File.exist? "#{Rails.root}/public/photos/#{objectId}.jpg"
			photo_url = "/photos/#{objectId}.jpg"
		else
			photo = HTTParty.get("https://graph.microsoft.com/v1.0/users/#{objectId}/photo/$value", headers: {
				"Authorization" => "Bearer #{session[:gmc_access_token]}",
				"Content-Type" => "application/x-www-form-urlencoded"
			}).body

			photo_url = "/Images/header-default.jpg"
			begin
				JSON.parse photo
			rescue
				if photo.nil? || photo.empty?
					photo_url = "/Images/header-default.jpg"
				else
					File.open("#{Rails.root}/public/photos/#{objectId}.jpg", "wb") do |f|
						f.write photo
					end
					photo_url = "/photos/#{objectId}.jpg"					
				end
			end
		end

		return photo_url
  end
end
