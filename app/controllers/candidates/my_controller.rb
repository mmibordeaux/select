class Candidates::MyController < ApplicationController
  def index
    @candidates = current_user.candidates_attributed
    @candidates_todo = @candidates.todo.page params[:page_todo]
    @candidates_done = @candidates.done.ordered_by_date.page params[:page_done]
  end
end