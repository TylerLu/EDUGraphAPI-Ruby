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
              'url': '/src/app/controllers/account_controller.rb',
              'methods': [
                {
                  'title': 'Login',
                  'description': 'Login action.'
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
              'url': '/src/app/controllers/account_controller.rb',
              'methods': [
                {
                  'title': 'Register',
                  'description': 'Register action.'
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
              'url': '/src/app/controllers/account_controller.rb',
              'methods': [
                {
                  'title': 'Register',
                  'description': 'Register action.'
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
              'url': '/src/app/controllers/link_controller.rb',
              'methods': [
                {
                  'title': 'index',
                  'description': 'Index action.'
                }
              ]
            },
            {
              'url': '/src/app/controllers/application_controller.rb',
              'methods': [
                {
                  'title': 'current_user',
                  'description': 'Get current user.'
                }
              ]
            },
            {
              'url': '/src/app/services/user_service.rb',
              'methods': [
                {
                  'title': 'get_user_by_email',
                  'description': 'Get user by email.'
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
              'url': '/src/app/controllers/link_controller.rb',
              'methods': [
                {
                  'title': 'create_local',
                  'description': 'Page action.'
                },
                {
                  'title': 'create_local_post',
                  'description': 'Create local account post action.'
                }
              ]
            },
            {
              'url': '/src/app/services/user_service.rb',
              'methods': [
                {
                  'title': 'create',
                  'description': 'Create a user.'
                }
              ]
            },
            {
              'url': '/src/app/services/link_service.rb',
              'methods': [
                {
                  'title': 'link',
                  'description': 'Link O365 account with local account.'
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
              'url': '/src/app/controllers/link_controller.rb',
              'methods': [
                {
                  'title': 'login_local',
                  'description': 'Page action.'
                },
                {
                  'title': 'login_local_post',
                  'description': 'Login local account post action.'
                }
              ]
            },
            {
              'url': '/src/app/services/user_service.rb',
              'methods': [
                {
                  'title': 'authenticate',
                  'description': 'Local account authentication.'
                }
              ]
            },
            {
              'url': '/src/app/services/link_service.rb',
              'methods': [
                {
                  'title': 'link',
                  'description': 'Link O365 account with local account.'
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
              'url': '/src/app/controllers/link_controller.rb',
              'methods': [
                {
                  'title': 'login_o365_required',
                  'description': 'Page action.'
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
              'url': '/src/app/controllers/admin_controller.rb',
              'methods': [
                {
                  'title': 'index',
                  'description': 'Page action.'
                },
                {
                  'title': 'consent_post',
                  'description': 'Consent post action.'
                },
                {
                  'title': 'unconsent',
                  'description': 'Unconsent post action.'
                },
                {
                  'title': 'add_app_role_assignments',
                  'description': 'Enable user access action.'
                },
                {
                  'title': 'clear_adal_cache',
                  'description': 'Clean adal cache action.'
                }
              ]
            },
            {
              'url': '/src/app/services/organization_service.rb',
              'methods': [
                {
                  'title': 'is_admin_consented',
                  'description': 'Get admin\'s tenant and organization information.'
                },
                {
                  'title': 'update_organization',
                  'description': 'Create (or update) an organization, and make it as AdminConsented.'
                }
              ]
            },
            {
              'url': '/src/app/services/token_service.rb',
              'methods': [
                {
                  'title': 'clear_token_cache',
                  'description': 'Remove all user tokens from database.'
                },
                {
                  'title': 'get_access_token',
                  'description': 'Get current user access token.'
                }
              ]
            },
            {
              'url': '/src/app/services/aad_graph_service.rb',
              'methods': [
                {
                  'title': 'get_service_principal',
                  'description': 'Get service principal.'
                },
                {
                  'title': 'delete_service_principal',
                  'description': 'Delete service principal.'
                },
                {
                  'title': 'add_app_role_assignments',
                  'description': 'Enable access to all your tenant users.'
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
              'url': '/src/app/controllers/admin_controller.rb',
              'methods': [
                {
                  'title': 'consent',
                  'description': 'Page action.'
                },
                {
                  'title': 'consent_post',
                  'description': 'Consent post action.'
                }
              ]
            },
            {
              'url': '/src/app/services/organization_service.rb',
              'methods': [
                {
                  'title': 'update_organization',
                  'description': 'Create (or update) an organization, and make it as AdminConsented.'
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
              'url': '/src/app/controllers/admin_controller.rb',
              'methods': [
                {
                  'title': 'linked_accounts',
                  'description': 'Mange linked accounts action.'
                }
              ]
            },
            {
              'url': '/src/app/services/link_service.rb',
              'methods': [
                {
                  'title': 'get_linked_users',
                  'description': 'Get linked users with the specified organization.'
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
              'url': '/src/app/controllers/admin_controller.rb',
              'methods': [
                {
                  'title': 'unlink_account',
                  'description': 'Unlink account action.'
                },
                {
                  'title': 'unlink_account_post',
                  'description': 'Unlink the specified the account post action.'
                }
              ]
            },
            {
              'url': '/src/app/services/user_service.rb',
              'methods': [
                {
                  'title': 'get_user_by_id',
                  'description': 'Get user from database by id.'
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
              'url': '/src/app/controllers/manage_controller.rb',
              'methods': [
                {
                  'title': 'aboutme',
                  'description': 'AboutMe page action.'
                }
              ]
            },
            {
              'url': '/src/app/services/user_service.rb',
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
              'url': '/src/lib/education/education_service.rb',
              'methods': [
                {
                  'title': 'get_me',
                  'description': 'Get current user information.'
                },
                {
                  'title': 'get_my_sections',
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
            'url': '/src/app/controllers/schools_controller.rb',
            'methods': [
              {
                'title': 'index',
                'description': 'Index action.'
              }
            ]
          },
          {
            'url': '/src/app/services/token_service.rb',
            'methods': [
              {
                'title': 'get_access_token',
                'description': 'Get current user access token.'
              }
            ]
          },
          {
            'url': '/src/lib/education/education_service.rb',
            'methods': [
              {
                'title': 'get_me',
                'description': 'Get current user information.'
              },
              {
                'title': 'get_all_schools',
                'description': 'Get all schools that exist in the Azure Active Directory tenant.'
              }
            ]
          }
        ]
      }
    ]
  },
  {
    'controller': 'schools',
    'action': 'users',
    'functions': [
      {
        'title': 'Get all students and teachers information',
        'tab': '',
        'files': [
          {
            'url': '/src/app/controllers/schools_controller.rb',
            'methods': [
              {
                'title': 'users',
                'description': 'Users action.'
              },
              {
                'title': 'users_next',
                'description': 'Next page action.'
              }
            ]
          },
          {
            'url': '/src/app/services/token_service.rb',
            'methods': [
              {
                'title': 'get_access_token',
                'description': 'Get current user access token.'
              }
            ]
          },
          {
            'url': '/src/lib/education/education_service.rb',
            'methods': [
              {
                'title': 'get_all_schools',
                'description': 'Get all schools that exist in the Azure Active Directory tenant.'
              }
            ]
          }
        ]
      },
      {
        'title': 'Get all members information',
        'tab': 'filterall',
        'files': [
          {
            'url': '/src/lib/education/education_service.rb',
            'methods': [
              {
                'title': 'get_members',
                'description': 'Get users within a school.'
              }
            ]
          }
        ]
      },
      {
        'title': 'Get all students information',
        'tab': 'filterstudnet',
        'files': [
          {
            'url': '/src/lib/education/education_service.rb',
            'methods': [
              {
                'title': 'get_students',
                'description': 'Get students within a school.'
              }
            ]
          }
        ]
      },
      {
        'title': 'Get all teachers information',
        'tab': 'filterteacher',
        'files': [
          {
            'url': '/src/lib/education/education_service.rb',
            'methods': [
              {
                'title': 'get_teachers',
                'description': 'Get teachers within a school.'
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
            'url': '/src/app/controllers/classes_controller.rb',
            'methods': [
              {
                'title': 'index',
                'description': 'Index action.'
              },
              {
                'title': 'more',
                'description': 'More action.'
              }
            ]
          },
          {
            'url': '/src/app/services/token_service.rb',
            'methods': [
              {
                'title': 'get_access_token',
                'description': 'Get current user access token.'
              }
            ]
          },
          {
            'url': '/src/lib/education/education_service.rb',
            'methods': [
              {
                'title': 'get_school',
                'description': 'Get a school by using the id.'
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
            'url': '/src/lib/education/education_service.rb',
            'methods': [
              {
                'title': 'get_my_sections',
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
            'url': '/src/lib/education/education_service.rb',
            'methods': [
              {
                'title': 'get_sections',
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
            'url': '/src/app/controllers/classes_controller.rb',
            'methods': [
              {
                'title': 'show',
                'description': 'Show action.'
              }
            ]
          },
          {
            'url': '/src/app/services/token_service.rb',
            'methods': [
              {
                'title': 'get_access_token',
                'description': 'Get current user access token.'
              }
            ]
          },
          {
            'url': '/src/lib/education/education_service.rb',
            'methods': [
              {
                'title': 'get_school',
                'description': 'Get a school by using the id.'
              },
              {
                'title': 'get_section',
                'description': 'Get a class by using the id.'
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
            'url': '/src/lib/education/education_service.rb',
            'methods': [
              {
                'title': 'get_section_members',
                'description': 'Get students within a class.'
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
            'url': '/src/app/services/ms_graph_service.rb',
            'methods': [
              {
                'title': 'get_conversations',
                'description': 'Get all conversations.'
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
            'url': '/src/app/services/ms_graph_service.rb',
            'methods': [
              {
                'title': 'get_documents',
                'description': 'Get all documents.'
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
            'url': '/src/app/services/user_service.rb',
            'methods': [
              {
                'title': 'get_seating_position_hash',
                'description': 'Get all seating positions.'
              },
              {
                'title': 'get_favorite_color_hash',
                'description': 'Get favorite color hash.'
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