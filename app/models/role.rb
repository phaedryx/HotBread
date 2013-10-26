class Role < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :user
end
