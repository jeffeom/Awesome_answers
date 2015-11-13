class AnswersMailer < ApplicationMailer
  def notify_question_owner(answer)
    @answer   = answer
    @question = answer.question
    @owner    = @question.user
    if @owner.email.present?
      mail(to: @owner.email, subject: "You got a new answer!")
    end
  end

  def notify_question_owner_like(like, like_owner)
    @question = like.question
    @owner = @question.user
    @like_owner = like.user
    if @owner.email.present?
      mail(to: @owner.email, subject: "You got a like!")
    end
  end
end
