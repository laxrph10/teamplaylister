class Admin < ActiveRecord::Base
	has_many: :parties
	has_many: :playlists, through: :parties
end
