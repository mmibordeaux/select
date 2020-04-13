class Candidates::SelectionsController < ApplicationController

  def index
    @candidates =  Candidate.selection_selected.ordered_by_selection
    @candidates = @candidates.search params[:search] if params.has_key? :search
    if params.has_key? :baccalaureat_id
      @baccalaureat = Baccalaureat.find params[:baccalaureat_id]
      @candidates = @candidates.where(baccalaureat_id: @baccalaureat.children_ids)
    end
  end

  def stats
    @candidates = Candidate.selection_selected
  end
end
