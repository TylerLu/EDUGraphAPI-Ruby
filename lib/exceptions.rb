# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

module Exceptions
  # Exception raised when refresh token do not exist or is expired
  class RefreshTokenError < StandardError; end
end