class Question < ActiveRecord::Base
belongs_to :user
has_many :answers, -> { includes(:user) }
 acts_as_taggable

 validates_presence_of :description, :title
 validates_presence_of :tag_list

# def tags_check(user, question)
#   question.tag_list.select {|u| user.tag_list.include?(u)} ? true : false
# end

end
