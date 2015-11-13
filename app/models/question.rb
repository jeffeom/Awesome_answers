class Question < ActiveRecord::Base

  has_many(:answers, {dependent: :destroy})

  has_many :likes, dependent: :destroy
  # has_many :users, through: :likes
  has_many :liking_users, through: :likes, source: :user

  has_many :votes, dependent: :destroy
  has_many :voting_users, through: :votes, source: :user

  belongs_to :user

  #validates(:title, {presence: true,
  #                   uniqueness: true})
  validates(:title, {presence: true,
                     uniqueness: {message: "was used already"},
                     length: {minimum: 3}})
  validates :body, presence: true,
                     uniqueness: {scope: :title}
                     # using scope: :title will make sure that the body is unique in combination with the title.

  #validates :body, presence: true
  #validates :view_count, numericality: true
  validates :view_count, numericality: {greater_than_or_equal_to: 0}

  # Error, if it is not in email format
  # validates :email, format: VALID_EMAIL_REGEX

  validate :no_monkey
  after_initialize :set_default_values
  before_validation :capitalize_title

  def self.recent_ten
    order("created_at DESC").limit(10)
  end
  # same thing with:
  # scope :recent_ten, lambda { order("created_at DESC").limit(10) }
  # scope defines first thing (symbol) as a second thing (lambda).

  def self.recent(num_records)
    order("created_at DESC").limit(num_records)
  end

  def self.search(term)
    if term == ""
      "You must enter"
    else
      # where(["title ILIKE ? OR body ILIKE ?", "%#{term}%", "%#{term}%"])
      where(["title ILIKE :search_term OR body ILIKE :search_term",
        {search_term: "%#{term}%"}])
    end
  end

  def liked_by?(user)
    # likes.find_by_user_id(user.id).present?
    like_for(user).present?
  end

  def like_for(user)
    likes.find_by_user_id(user.id)
  end

  def voted_on_by?(user)
    vote_for(user).present?
  end

  def vote_for(user)
    votes.find_by_user_id user.id
  end

  def vote_result
    votes.select{|v| v.is_up?}.count - votes.select{|v| !v.is_up?}.count
  end

  private

  # this is a custom validation method
  def no_monkey
    if title.present? && title.downcase.include?("monkey")
      errors.add(:title, "No monkeys please!")
    end
  end

  def set_default_values
    self.view_count ||= 0
  end

  def capitalize_title
    self.title.capitalize! if title
  end
end
