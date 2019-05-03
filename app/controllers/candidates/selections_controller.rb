class Candidates::SelectionsController < ApplicationController

  def index
    @candidates =  Candidate.selected
    @candidates = @candidates.search params[:search] if params.has_key? :search
  end

  def stats
    @candidates = Candidate.selected
  end
end