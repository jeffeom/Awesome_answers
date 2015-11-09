class QuestionsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]

  # before action will register a method (in this case it's called find_question)
  # that will be executed before all actions unless you specify options such as:
  # :except or :only.
  # before_action(:find_question, {except [:index, :new, :create] })
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  # we usually use the word 'authenticate' to refer to signing in or out with
  # eamil and password. We use the word 'authorize' to refer to enforcing
  # permissions for specific actions.
  before_action :authorize, only: [:edit, :update, :destroy]

  def new
    # the default behaviour of controller action is to render a template
    # within a folder with the same controller name. Using the format/templating
    # language used. In this case we're using the default format which is HTML
    # we are using the default templating language which is ERB
    # So the controller action will render template:
    # views/questions/new.html.erb
    @q = Question.new
  end

  def create
    @q = Question.new(question_params)
    @q.user = current_user
    if @q.save
      # render text: "Saved Correctly!"
      # redirect_to(question_path({id: @q.id}))
      redirect_to(question_path(@q), notice: "Question created!")
    else
      # render text: "Didn't save correctly! #{q.errors.full_messages.join(", ")}"
      render :new
    end
    # Question.creat(questions_params)
    # Questions.create(params[:question])
    # render text: "Inside Questions Create: #{params[:question]}"
  end

  # GET /question/:id
  # you get access to the id in the URL from params[:id]
  def show
    @answer = Answer.new
    # we inantiate an empty Answer object as we need a form on the show page
    # to create an answer for our question
    #render text: params
  end

  def edit
    if current_user != @q.user
      redirect_to root_path, alert: "Access Denied" unless can? :edit, @q
    end
  end

  def update
    if @q.update(question_params)
      redirect_to question_path(@q), notice: "Question updated!"
      # render text: "inside update #{params}"
    else
      render :edit
    end
  end

  def index
    Rails.logger.error ">>>>>>>>>>>> #{current_user }"
    @questions = Question.recent_ten
  end

  def destroy
    @q.destroy
    flash[:notice] = "Question deleted successfully"
    redirect_to questions_path
  end

  private

  def question_params
    # params[:question] # "questions" =>{"title"=>"abc", "body"=>"xyz"}
    # Question.create({title: params[:question][:title],
    #                  body: params[:question][:body]})
    # Mass assignment way:
    params.require(:question).permit([:title, :body])
  end

  def find_question
    @q = Question.find params[:id]
  end

  def authorize
    redirect_to root_path, alert: "Access Denied!" unless can? :manage, @q
  end
end
