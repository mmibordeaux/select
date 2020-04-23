class Evaluations::MyController < ApplicationController
  def index
    @candidates = current_user.candidates
    @evaluations = current_user.evaluations
    @evaluations_todo = @evaluations.todo.page params[:page_todo]
    @evaluations_done = @evaluations.done.page params[:page_done]
  end
end
