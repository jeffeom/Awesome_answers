class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  # this will ensure that the question_id / user_id combo is unique
  # this is needed to ensure that the user can only like a question once.
  validates :question_id, uniqueness: {scope: :user_id}
end
