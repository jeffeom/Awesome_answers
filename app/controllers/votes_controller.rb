class VotesController < ApplicationController
  before_action :authenticate_user

  def create
    # this will instantiate a vote object pre-associated with the current users
    # which means 'vote' will have a 'user_id' value equivalent to current_user.id
    vote          = current_user.votes.new vote_params
    vote.question = question
    if vote.save
      redirect_to question, notice: "Voted!"
    else
      redirect_to question, alert: "Can't vote!"
    end
  end

  def destroy
    vote = current_user.votes.find params[:id]
    vote.destroy
    redirect_to question, notice: "Vote removed!"
  end

  def update
    vote = current_user.votes.find params[:id]
    if vote.update vote_params
      redirect_to question, notice: "Vote updated!"
    else
      redirect_to question, alert: "Vote wasn't updated!"
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:is_up)
  end

  def question
    @question ||= Question.friendly.find params[:question_id]
  end
end
