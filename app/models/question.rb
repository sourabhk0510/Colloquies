class Question < ActiveRecord::Base
	belongs_to :user
	has_many :answers, -> { includes(:user) }
  acts_as_taggable

	validates_presence_of :description, :title
	validates_presence_of :tag_list
end