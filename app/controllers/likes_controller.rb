class LikesController < ApplicationController
  before_action :authenticate_user

  # POST /questions/12/likes
  def create
    like          = Like.new
    question      = Question.friendly.find params[:question_id]
    like.question = question
    like.user     = current_user
    if like.save
      AnswersMailer.notify_question_owner_like(like, like.user).deliver_now
      redirect_to question_path(question), notice: "Thanks for liking!"
    else
      redirect_to question_path(question), alert: "Can't like! Liked already?"
    end
  end

  def destroy
    question = Question.friendly.find params[:question_id]
    like     = current_user.likes.find params[:id]
    like.destroy
    redirect_to question_path(question), notice: "Like removed!"
  end

end
