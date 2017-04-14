# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

module SchoolsHelper
  def is_linked?
    return false unless Account.find_by_o365_email(cookies[:o365_login_email])
    return true
  end
end
