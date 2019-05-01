class Candidates::SelectionsController < ApplicationController

  def index
    @candidates =  Candidate.ordered_by_selection
                            .selected
    @candidates = @candidates.search params[:search] if params.has_key? :search
    @candidates = @candidates.page params[:page]
  end

  def stats
    @candidates = Candidate.selected
  end
end