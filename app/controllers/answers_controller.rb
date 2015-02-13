class AnswersController < ApplicationController
  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(answer_params)
      redirect_to question_path(@answer.question_id)
    else
      render('edit')
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.is_active = false
    @answer.save
    respond_to do |format|
      format.html { redirect_to question_path(@answer.question_id)}
      format.js   { render :nothing => true }
    end
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