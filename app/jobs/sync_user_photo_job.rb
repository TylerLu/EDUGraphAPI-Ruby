# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class SyncUserPhotoJob < ApplicationJob
  queue_as :default

  # 开启后端任务， 异步抓住用户头像
  def perform(objectId, token_type, access_token, file_path)
    photo = HTTParty.get("https://graph.microsoft.com/v1.0/users/#{objectId}/photo/$value", headers: {
			"Authorization" => "#{token_type} #{access_token}",
			"Content-Type" => "application/x-www-form-urlencoded"
		}).body


		unless photo.nil? || photo.empty?
			# File.open("#{Rails.root}/public/photos/#{objectId}.jpg", "wb") do |f|
			File.open("#{file_path}/#{objectId}.jpg", "wb") do |f|
				f.write photo
			end
		end
  end
end
