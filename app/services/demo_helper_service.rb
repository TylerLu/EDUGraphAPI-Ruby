# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

class DemoHelperService

  @@data = [
    {
      'controller': 'account',
      'action': 'login',
      'links': {
        'AccountController': '/app/controllers/account_controller.rb',
        'TokenService': '/app/services/token_service.rb',
        'MSGraphService': '/app/services/ms_graph_service.rb',
        'UserService': '/app/services/user_service.rb',
        'OrganizationService': '/app/services/organization_service.rb',
        'LoginView': '/app/views/account/login.html.erb',
        'O365LoginView': '/app/views/account/o365login.html.erb',
      }
    },
    {
      'controller': 'account',
      'action': 'register',
      'links': {
        'AccountController': '/app/controllers/account_controller.rb',
        'UserService': '/app/services/user_service.rb',
        'View': '/app/views/account/register.html.erb',
      }
    },
    {
      'controller': 'link',
      'action': 'index',
      'links': {
        'LinkController': '/app/controllers/link_controller.rb',
        'UserService': '/app/services/user_service.rb',
        'LinkService': '/app/services/link_service.rb',
        'TokenService': '/app/services/token_service.rb',
        'MSGraphService': '/app/services/ms_graph_service.rb',
        'View': '/app/views/link/index.html.erb',
      }
    },
    {
      'controller': 'link',
      'action': 'create_local',
      'links': {
        'LinkController': '/app/controllers/link_controller.rb',
        'UserService': '/app/services/user_service.rb',
        'LinkService': '/app/services/link_service.rb',
        'View': '/app/views/link/create_local.html.erb',
      }
    },
    {
      'controller': 'link',
      'action': 'login_local',
      'links': {
        'LinkController': '/app/controllers/link_controller.rb',
        'UserService': '/app/services/user_service.rb',
        'LinkService': '/app/services/link_service.rb',
        'View': '/app/views/link/login_local.html.erb',
      }
    },
    {
      'controller': 'link',
      'action': 'login_o365_required',
      'links': {
        'LinkController': '/app/controllers/link_controller.rb',
        'View': '/app/views/link/login_o365_required.html.erb',
      }
    },
    {
      'controller': 'admin',
      'action': 'index',
      'links': {
        'AdminController': '/app/controllers/admin_controller.rb',
        'OrganizationService': '/app/services/organization_service.rb',
        'TokenService': '/app/services/token_service.rb',
        'AADGraphService': '/app/services/aad_graph_service.rb',
        'View': '/app/views/admin/index.html.erb',
      }
    },
    {
      'controller': 'admin',
      'action': 'consent',
      'links': {
        'AdminController': '/app/controllers/admin_controller.rb',
        'OrganizationService': '/app/services/organization_service.rb',
        'View': '/app/views/admin/consent.html.erb',
      }
    },
    {
      'controller': 'admin',
      'action': 'linked_accounts',
      'links': {
        'AdminController': '/app/controllers/admin_controller.rb',
        'LinkService': '/app/services/link_service.rb',
        'View': '/app/views/admin/linked_accounts.html.erb',
      }
    },
    {
      'controller': 'admin',
      'action': 'unlink_account',
      'links': {
        'AdminController': '/app/controllers/admin_controller.rb',
        'LinkService': '/app/services/link_service.rb',
        'View': '/app/views/admin/unlink_account.html.erb',
      }
    },
    {
      'controller': 'manage',
      'action': 'aboutme',
      'links': {
        'ManageController': '/app/controllers/manage_controller.rb',
        'UserService': '/app/services/user_service.rb',
        'EducationService': '/lib/education/education_service.rb',
        'View': '/app/views/manage/aboutme.html.erb',
      }
    },
    {
      'controller': 'schools',
      'action': 'index',
      'links': {
        'SchoolsController': '/app/controllers/schools_controller.rb',
        'TokenService': '/app/services/token_service.rb',
        'EducationService': '/lib/education/education_service.rb',   
        'View': '/app/views/schools/index.html.erb',
      }
    },
    {
      'controller': 'schools',
      'action': 'users',
      'links': {
        'SchoolsController': '/app/controllers/schools_controller.rb',
        'TokenService': '/app/services/token_service.rb',
        'EducationService': '/lib/education/education_service.rb',    
        'View': '/app/views/schools/users.html.erb',
      }
    },
    {
      'controller': 'classes',
      'action': 'index',
      'links': {
        'ClassesController': '/app/controllers/classes_controller.rb',
        'TokenService': '/app/services/token_service.rb',
        'EducationService': '/lib/education/education_service.rb',    
        'View': '/app/views/classes/index.html.erb',
      }
    },
    {
      'controller': 'classes',
      'action': 'show',
      'links': {
        'ClassesController': '/app/controllers/classes_controller.rb',
        'TokenService': '/app/services/token_service.rb',
        'EducationService': '/lib/education/education_service.rb',
        'MSGraphService': '/app/services/ms_graph_service.rb',
        'UserService': '/app/services/user_service.rb',
        'View': '/app/views/classes/show.html.erb',
      }
    }
  ]

  def self.get_links(controller, action)        
    item = @@data.detect{ |item| item[:controller] == controller && item[:action] == action }
    item ? item[:links] : {}
  end

end