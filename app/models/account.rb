class Account < ApplicationRecord
	belongs_to :role
	belongs_to :token
end
