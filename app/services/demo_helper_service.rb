# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

class DemoHelperService

  @@data = [
    {
      'controller': 'account',
      'action': 'login',
      'functions': [
        {
          'title': 'Login for local user or O365 user',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/account_controller.rb',
              'methods': [
                {
                  'title': 'login',
                  'description': 'Show the login page.'
                },
                {
                  'title': 'login_local',
                  'description': 'Handle local user login.'
                },
                {
                  'title': 'login_o365',
                  'description': 'Redirect to the Office 365 sign in page.'
                },
                {
                  'title': 'reset',
                  'description': 'Delete cookies to let the user sign in with a different account.'
                },                
                {
                  'title': 'azure_oauth2_callback',
                  'description': 'Handle Azure OAuth2 callback.'
                },
              ]
            },
            {
              'url': '/app/services/token_service.rb',
              'methods': [
                {
                  'title': 'cache_tokens',
                  'description': 'Cache access token and refresh token.'
                },
                {
                  'title': 'get_access_token',
                  'description': 'Get access token.'
                },
              ]
            },
            {
              'url': '/app/services/ms_graph_service.rb',
              'methods': [
                {
                  'title': 'get_organization',
                  'description': 'Get organization.'
                },
                {
                  'title': 'get_me',
                  'description': 'Get me.'
                },
                {
                  'title': 'get_my_roles',
                  'description': 'Get my roles.'
                },
              ]
            },
            {
              'url': '/app/services/user_service.rb',
              'methods': [
                {
                  'title': 'authenticate',
                  'description': 'Authenticate local user.'
                },
                {
                  'title': 'get_user_by_o365_email',
                  'description': 'Get local user by Office 365 email.'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      'controller': 'account',
      'action': 'register',
      'functions': [
        {
          'title': 'User register',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/account_controller.rb',
              'methods': [
                {
                  'title': 'register',
                  'description': 'Show the reigster page.'
                },
                {
                  'title': 'register_post',
                  'description': 'Handle the register post request.'
                }
              ]
            },
            {
              'url': '/app/services/user_service.rb',
              'methods': [
                {
                  'title': 'register',
                  'description': 'Register local user.'
                },
                {
                  'title': 'get_user_by_email',
                  'description': 'Get local user by email.'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      'controller': 'link',
      'action': 'index',
      'functions': [
        {
          'title': 'Get user information and check link status',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/link_controller.rb',
              'methods': [
                {
                  'title': 'index',
                  'description': 'Show link page.'
                },
                {
                  'title': 'matched_local',
                  'description': 'Link current Office 365 account with the matched local account.'
                },
                {
                  'title': 'login_o365',
                  'description': 'Let current user to login in with Office 365 account.'
                },
                {
                  'title': 'login_o365_callback',
                  'description': 'Handle Office 365 login, link accounts.'
                }
              ]
            },
            {
              'url': '/app/services/token_service.rb',
              'methods': [
                {
                  'title': 'cache_tokens',
                  'description': 'Cache access token and refresh token.'
                },
                {
                  'title': 'get_access_token',
                  'description': 'Get access token.'
                },
              ]
            },
            {
              'url': '/app/services/ms_graph_service.rb',
              'methods': [
 
                {
                  'title': 'get_organization',
                  'description': 'Get organization(tenant).'
                },
                {
                  'title': 'get_my_roles',
                  'description': 'Get my roles.'
                },
              ]
            },
            {
              'url': '/app/services/organization_service.rb',
              'methods': [
                {
                  'title': 'create_or_update_organization',
                  'description': 'Create or update organization.'
                }
              ]
            },
            {
              'url': '/app/services/user_service.rb',
              'methods': [
                {
                  'title': 'get_user_by_email',
                  'description': 'Get local user by email.'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      'controller': 'link',
      'action': 'create_local',
      'functions': [
        {
          'title': 'Create local account',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/link_controller.rb',
              'methods': [
                {
                  'title': 'create_local',
                  'description': 'Show create local account page.'
                },
                {
                  'title': 'create_local_post',
                  'description': 'Hanlde create local account post request.'
                }
              ]
            },
            {
              'url': '/app/services/user_service.rb',
              'methods': [
                {
                  'title': 'create',
                  'description': 'Create a local user.'
                }
              ]
            },
            {
              'url': '/app/services/link_service.rb',
              'methods': [
                {
                  'title': 'link',
                  'description': 'Link an O365 account with a local account.'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      'controller': 'link',
      'action': 'login_local',
      'functions': [
        {
          'title': 'Local user login and link',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/link_controller.rb',
              'methods': [
                {
                  'title': 'login_local',
                  'description': 'Show local account login page.'
                },
                {
                  'title': 'login_local_post',
                  'description': 'Hande login account login and link accounts.'
                }
              ]
            },
            {
              'url': '/app/services/user_service.rb',
              'methods': [
                {
                  'title': 'authenticate',
                  'description': 'Authenticate local account.'
                }
              ]
            },
            {
              'url': '/app/services/link_service.rb',
              'methods': [
                {
                  'title': 'link',
                  'description': 'Link an O365 account with a local account.'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      'controller': 'link',
      'action': 'login_o365_required',
      'functions': [
        {
          'title': 'O365 user relogin if token is clear or expired',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/link_controller.rb',
              'methods': [
                {
                  'title': 'login_o365_required',
                  'description': 'Show "Login to Office 365 is required" page.'
                },
                {
                  'title': 'relogin_o365',
                  'description': 'Redirect the user to Office 365 login page.'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      'controller': 'admin',
      'action': 'index',
      'functions': [
        {
          'title': 'Get admin\'s tenant and organization information',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/admin_controller.rb',
              'methods': [
                {
                  'title': 'index',
                  'description': 'Show admin page.'
                },
                {
                  'title': 'consent_post',
                  'description': 'Redirect the user to admin consent page.'
                },
                {
                  'title': 'consent_callback',
                  'description': 'Post-process after admin consent.'
                },
                {
                  'title': 'unconsent',
                  'description': 'Undo admin consent.'
                },
                {
                  'title': 'add_app_role_assignments',
                  'description': 'Enable user access.'
                },
                {
                  'title': 'clear_adal_cache',
                  'description': 'Clean adal token cache.'
                }
              ]
            },
            {
              'url': '/app/services/organization_service.rb',
              'methods': [
                {
                  'title': 'is_admin_consented',
                  'description': 'Check if the organization (tenant) is consent by an admin.'
                },
                {
                  'title': 'update_organization',
                  'description': 'Update an organization.'
                }
              ]
            },
            {
              'url': '/app/services/token_service.rb',
              'methods': [
                {
                  'title': 'get_access_token',
                  'description': 'Get current user access token.'
                },
                {
                  'title': 'clear_token_cache',
                  'description': 'Remove all user tokens from database.'
                }
              ]
            },
            {
              'url': '/app/services/aad_graph_service.rb',
              'methods': [
                {
                  'title': 'get_service_principal',
                  'description': 'Get service principal.'
                },
                {
                  'title': 'add_app_role_assignments',
                  'description': 'Enable access to all your tenant users.'
                },
                {
                  'title': 'delete_service_principal',
                  'description': 'Delete service principal.'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      'controller': 'admin',
      'action': 'consent',
      'functions': [
        {
          'title': 'Consent the app',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/admin_controller.rb',
              'methods': [
                {
                  'title': 'consent',
                  'description': 'Show admin consent page.'
                },
                {
                  'title': 'consent_post',
                  'description': 'Redirect the user to admin consent page.'
                },
                {
                  'title': 'consent_callback',
                  'description': 'Post-process after admin consent.'
                },
              ]
            },
            {
              'url': '/app/services/organization_service.rb',
              'methods': [
                {
                  'title': 'update_organization',
                  'description': 'Update an organization.'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      'controller': 'admin',
      'action': 'linked_accounts',
      'functions': [
        {
          'title': 'Get linked accounts',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/admin_controller.rb',
              'methods': [
                {
                  'title': 'linked_accounts',
                  'description': 'Mange linked accounts action.'
                }
              ]
            },
            {
              'url': '/app/services/link_service.rb',
              'methods': [
                {
                  'title': 'get_linked_users',
                  'description': 'Get linked users of an organization.'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      'controller': 'admin',
      'action': 'unlink_account',
      'functions': [
        {
          'title': 'Get user that needs to unlink',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/admin_controller.rb',
              'methods': [
                {
                  'title': 'unlink_account',
                  'description': 'Show unlink account page'
                },
                {
                  'title': 'unlink_account_post',
                  'description': 'Unlink current user\' accounts.'
                }
              ]
            },
            {
              'url': '/app/services/user_service.rb',
              'methods': [
                {
                  'title': 'get_user_by_id',
                  'description': 'Get user from database by id.'
                }
              ]
            },
            {
              'url': '/app/services/link_service.rb',
              'methods': [
                {
                  'title': 'unlink_account',
                  'description': 'Unlink account.'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      'controller': 'manage',
      'action': 'aboutme',
      'functions': [
        {
          'title': 'Get current user information',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/manage_controller.rb',
              'methods': [
                {
                  'title': 'aboutme',
                  'description': 'Show about me page.'
                },
                {
                  'title': 'update_favorite_color',
                  'description': 'Save favorite color.'
                }
              ]
            },
            {
              'url': '/app/services/user_service.rb',
              'methods': [
                {
                  'title': 'get_favorite_color',
                  'description': 'Get current user\'s favorite color.'
                },
                {
                  'title': 'update_favorite_color',
                  'description': 'Update current user\'s favorite color.'
                }
              ]
            },
            {
              'url': '/app/services/token_service.rb',
              'methods': [
                {
                  'title': 'get_access_token',
                  'description': 'Get access token.'
                },
              ]
            },
            {
              'url': '/lib/education/education_service.rb',
              'methods': [
                {
                  'title': 'get_my_classes',
                  'description': 'Get current user\'s classes.'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      'controller': 'schools',
      'action': 'index',
      'functions': [
      {
        'title': 'Get schools information',
        'tab': '',
        'files': [
          {
            'url': '/app/controllers/schools_controller.rb',
            'methods': [
              {
                'title': 'index',
                'description': 'Show all schools page.'
              }
            ]
          },
          {
            'url': '/app/services/token_service.rb',
            'methods': [
              {
                'title': 'get_access_token',
                'description': 'Get access token.'
              }
            ]
          },
          {
            'url': '/lib/education/education_service.rb',
            'methods': [
              {
                'title': 'get_me',
                'description': 'Get current user\'s information.'
              },
              {
                'title': 'get_all_schools',
                'description': 'Get all schools.'
              }
            ]
          }
        ]
      }
    ]
    },
    {
      'controller': 'classes',
      'action': 'index',
      'functions': [
        {
          'title': 'Get classes information',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/classes_controller.rb',
              'methods': [
                {
                  'title': 'index',
                  'description': 'Show classes page.'
                },
                {
                  'title': 'more',
                  'description': 'Return more classes (JSON data).'
                }
              ]
            },
            {
              'url': '/app/services/token_service.rb',
              'methods': [
                {
                  'title': 'get_access_token',
                  'description': 'Get access token.'
                }
              ]
            },
            {
              'url': '/lib/education/education_service.rb',
              'methods': [
                {
                  'title': 'get_school',
                  'description': 'Get a school.'
                }
              ]
            }
          ]
        },
        {
          'title': 'Get my classes information',
          'tab': 'filtermyclasses',
          'files': [
            {
              'url': '/lib/education/education_service.rb',
              'methods': [
                {
                  'title': 'get_my_classes',
                  'description': 'Get my classes within a school.'
                }
              ]
            }
          ]
        },
        {
          'title': 'Get all classes information',
          'tab': 'filterclasses',
          'files': [
            {
              'url': '/lib/education/education_service.rb',
              'methods': [
                {
                  'title': 'get_classes',
                  'description': 'Get classes within a school.'
                }
              ]
            }
          ]
        }
      ]
    },
    {
      'controller': 'classes',
      'action': 'show',
      'functions': [
        {
          'title': 'Get school and class information',
          'tab': '',
          'files': [
            {
              'url': '/app/controllers/classes_controller.rb',
              'methods': [
                {
                  'title': 'show',
                  'description': 'Return class details page.'
                },
                {
                  'title': 'add_coteacher',
                  'description': 'Add a teacher to current class.'
                }
              ]
            },
            {
              'url': '/app/services/token_service.rb',
              'methods': [
                {
                  'title': 'get_access_token',
                  'description': 'Get access token.'
                }
              ]
            },
            {
              'url': '/lib/education/education_service.rb',
              'methods': [
                {
                  'title': 'get_school',
                  'description': 'Get a school.'
                },
                {
                  'title': 'get_class',
                  'description': 'Get a class.'
                },
                {
                  'title': 'get_teachers',
                  'description': 'Get teachers within a school.'
                },
                {
                  'title': 'add_user_to_class_as_member',
                  'description': 'Add a user to class as a member.'
                },
                {
                  'title': 'add_user_to_class_as_owner',
                  'description': 'Add a user to the class as an owner.'
                }
              ]
            }
          ]
        },
        {
          'title': 'Get students in this class',
          'tab': '#students',
          'files': [
            {
              'url': '/lib/education/education_service.rb',
              'methods': [
                {
                  'title': 'get_class_members',
                  'description': 'Get members within a class.'
                }
              ]
            }
          ]
        },
        {
          'title': 'Get assignments in this class',
          'tab': '#assignments',
          'files': [
            {
              'url': '/lib/education/education_service.rb',
              'methods': [
                {
                  'title': 'get_assignments_by_class_id',
                  'description': 'Get a class\'s assignments.'
                },
                {
                  'title': 'create_assignment',
                  'description': 'Create an assignment for a class.'
                },
                {
                  'title': 'add_assignment_resources',
                  'description': 'Add resource to an assignment.'
                },
                {
                  'title': 'publish_assignment',
                  'description': 'Publish an assignment. Set its status from draft to published.'
                },
                {
                  'title': 'add_submission_resource',
                  'description': 'Add resources to an assignment submission.'
                },
                {
                  'title': 'get_assignment_resources',
                  'description': 'Get resources of an assignment.'
                },
                {
                  'title': 'get_assignment_submissions',
                  'description': 'Get submissions of an assignment.'
                },
                {
                  'title': 'get_assignment_submission_by_user',
                  'description': 'Get a student\'s assignment submissions.'
                }
              ]
            }
          ]
        },
        {
          'title': 'Get all conversations of current class',
          'tab': '#conversations',
          'files': [
            {
              'url': '/app/services/ms_graph_service.rb',
              'methods': [
                {
                  'title': 'get_conversations',
                  'description': 'Get conversations of a class.'
                }
              ]
            }
          ]
        },
        {
          'title': 'Get documents from OneDrive of current class',
          'tab': '#documents',
          'files': [
            {
              'url': '/app/services/ms_graph_service.rb',
              'methods': [
                {
                  'title': 'get_documents',
                  'description': 'Get documents of a class'
                },
                {
                  'title': 'get_documents_web_url',
                  'description': 'Get URL of the documents page.'
                }              
              ]
            }
          ]
        },
        {
          'title': 'Display, edit and save students charts',
          'tab': '#seatingchart',
          'files': [
            {
              'url': '/app/services/user_service.rb',
              'methods': [
                {
                  'title': 'get_seating_position_hash',
                  'description': 'Get seating positions of a class.'
                },
                {
                  'title': 'get_favorite_color_hash',
                  'description': 'Get users\' favorite colors.'
                },
                {
                  'title': 'save_seating_positions',
                  'description': 'Save seating positions.'
                }
              ]
            }
          ]
        }
      ]
    }
]

  def self.get_links(controller, action)        
    item = @@data.detect{ |item| item[:controller] == controller && item[:action] == action }
    item ? item[:functions] : []
  end

end