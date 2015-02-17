class AnswersController < ApplicationController
  def edit
    @answer = Answer.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @answer = Answer.find(params[:id])
    respond_to do |format|
      if @answer.update_attributes(answer_params)
        format.js
          @question = Question.find(@answer.question_id)
      end
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.is_active = false
    @answer.save
    respond_to do |format|
      @question = Question.find(@answer.question_id)
      binding.pry
      format.js   { render partial: "questions/q_show" }
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