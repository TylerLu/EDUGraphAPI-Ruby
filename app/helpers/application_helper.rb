# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

require 'fileutils'

module ApplicationHelper
	# { host: 'graph.windows.net', tenant_name: '', access_token: '', resource_name: 'me', api_version: 'beta' }
	def graph_request(row = {})
		if row[:host] == Settings.host.gwn
			return JSON.parse(
				HTTParty.method(row[:http_method] || 'get').call(
					"https://#{row[:host]}/#{row[:tenant_name]}/#{row[:resource_name]}?api-version=#{row[:api_version] || 'beta'}",
					query: row[:query] || {},
					body: row[:body] || {},
					headers: {
						"Authorization" => "Bearer #{row[:access_token]}",
						"Content-Type" => "application/x-www-form-urlencoded"
					}
				).body
			) rescue {}
		elsif row[:host] == Settings.host.gmc
			callback = Proc.new { |r| r.headers["Authorization"] = "Bearer #{row[:access_token]}" }

			return MicrosoftGraph.new(
			  base_url: "https://#{row[:host]}/v#{row[:api_version] || '1.0'}",
			  cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, "metadata_v1.0.xml"),
			  &callback
			)
		end
	end

	def get_request_schema
		"#{(is_http = request.headers['HTTP_X_ARR_SSL'].blank?) ? request.protocol : 'https://' }#{request.host}:#{is_http ? request.port : 443}"
	end

	def is_admin?
    # !session[:current_user][:email] && \
    # !session[:current_user][:user_identify] && \
    # !session[:current_user][:o365_email]
    
    (session[:roles] || []).include? 'Admin'
  end

  def user_roles
  	graph_request({
			host: 'graph.microsoft.com',
			tenant_name: Settings.tenant_name,
			access_token: session[:gmc_access_token]
		})
  end

  def get_user_photo_url(objectId)
  	if File.exist? "#{Rails.root}/public/photos/#{objectId}.jpg"
			photo_url = "/photos/#{objectId}.jpg"
		else
			photo = HTTParty.get("https://graph.microsoft.com/v1.0/users/#{objectId}/photo/$value", headers: {
				"Authorization" => "#{session[:token_type]} #{session[:gmc_access_token]}",
				"Content-Type" => "application/x-www-form-urlencoded"
			}).body

			photo_url = "/Images/header-default.jpg"
			begin
				JSON.parse photo
			rescue
				if photo.nil? || photo.empty?
					# FileUtils.cp("#{Rails.root}/public/Images/header-default.jpg", "#{Rails.root}/public/photos/#{objectId}.jpg")
					photo_url = "/Images/header-default.jpg"
				else
					File.open("#{Rails.root}/public/photos/#{objectId}.jpg", "wb") do |f|
						f.write photo
					end
					photo_url = "/photos/#{objectId}.jpg"					
				end
			end
			# photo_url = "/photos/#{objectId}.jpg"	
			# SyncUserPhotoJob.set(wait_until: Date.tomorrow).perform_later(objectId, session[:token_type], session[:gmc_access_token], "#{Rails.root}/public/photos")
			# photo_url = "/Images/header-default.jpg"
		end

		return photo_url
  end
end
