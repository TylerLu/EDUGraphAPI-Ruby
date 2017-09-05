# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

require 'fileutils'

module ApplicationHelper

  def full_host
    if request.scheme && request.url.match(URI::ABS_URI)
      uri = URI.parse(request.url.gsub(/\?.*$/, ''))
      uri.path = ''
      # sometimes the url is actually showing http inside rails because the
      # other layers (like nginx) have handled the ssl termination.
      uri.scheme = 'https' if ssl? # rubocop:disable BlockNesting
      uri.to_s
      else ''
    end
  end

  def ssl?
    request.env['HTTP_X_ARR_SSL'] ||
      request.env['HTTPS'] == 'on' ||
      request.env['HTTP_X_FORWARDED_SSL'] == 'on' ||
      request.env['HTTP_X_FORWARDED_SCHEME'] == 'https' ||
      (request.env['HTTP_X_FORWARDED_PROTO'] && request.env['HTTP_X_FORWARDED_PROTO'].split(',')[0] == 'https') ||
      request.env['rack.url_scheme'] == 'https'
  end

end