class Candidates::SelectionsController < ApplicationController

  def index
    @candidates =  Candidate.ordered_by_selection
                            .selected
                            .page params[:page]
  end

  def stats
    @candidates = Candidate.selected
  end
end