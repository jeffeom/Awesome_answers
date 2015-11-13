class User < ActiveRecord::Base
  has_secure_password

  # attr_accessor :hello

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  # this will give allthe answers on the questions created by the user
  # user -- created many --> questions -- has many --> answers
  has_many :questions_answers, through: :questions, source: :answers

  has_many :likes, dependent: :destroy
  has_many :liked_questions, through: :likes, source: :question

  has_many :votes, dependent: :nullify
  has_many :voted_questions, through: :votes, source: :question

  validates :email, presence: true, uniqueness: true

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
