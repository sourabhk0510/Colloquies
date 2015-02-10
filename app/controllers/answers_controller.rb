class AnswersController < ApplicationController

 # before_action :find_question
  def index
    #@answer = Question.where(:user_id => current_user.id)
   # @question = current_user.questions
      @answer = current_user.answers
  end

   def show
      @question = current_user.questions
      @answer = current_user.answers
    end

 # def new
 #  binding.pry
 #   @answer = Answer.new({:question_id => @question.id, :user_id => @question.user_id, :feedback => "Default"})
 #end

 def create
   binding.pry
   @answer = Answer.new(answer_params)

   if @answer.save
    redirect_to question_path(@question.id)
  else
    render('new')
  end
end


  def edit
     # @question = Question.find(params[:question_id])
    @answer = Answer.includes(:question).find(params[:id])

    # authorize @answer, :edit?
  end

  def update
    @answer = Answer.includes(:question)find(params[:id])
    if @answer.update_attributes(answer_params)
      redirect_to question_path(@answer.question_id)
    else
      render('edit')
    end
  end

# def delete
#   @answer = Answer.find(params[:id])
# end

  def destroy
   @answer = Answer.find(params[:id])
    @answer.is_active = false
    @answer.save
    redirect_to question_path(@answer.question_id)
  end

 private
 def answer_params
  params.require(:answer).permit(:question_id, :user_id, :feedback)
 end

  def find_question
   @question = Question.find(params[:question_id]) if params[:question_id]
   @user = Answer.find(params[:user_id]) if params[:user_id]
  end
  
end

