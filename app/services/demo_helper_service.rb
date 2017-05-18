# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

class DemoHelperService

  @@data = [
    {
      'controller': 'schools',
      'action': 'index',
      'links': {
        'AccountController': '/app/controllers/schools_controller.rb'
      }
    }
  ]
  # TODO fill data helper data

  def self.get_links(controller, action)        
    item = @@data.first{ |item| item[:controller] == controller && item[:action] == action }
    item ? item[:links] : {}
  end

end