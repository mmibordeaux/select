class Candidates::SelectionsController < ApplicationController

  def index
    @candidates =  Candidate.selection_selected.ordered_by_selection
    @candidates = @candidates.search params[:search] if params.has_key? :search
  end

  def stats
    @candidates = Candidate.selection_selected
  end
end