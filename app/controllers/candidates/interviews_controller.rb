class Candidates::InterviewsController < ApplicationController
  def index
    @candidates = Candidate.selected_for_interviews.page params[:page]
  end
end
