class Candidates::SelectionsController < ApplicationController

  def index
    @title = 'Sélection'
    @candidates =  Candidate.selection_selected.ordered_by_selection
    @candidates = @candidates.search params[:search] if params.has_key? :search
    if params.has_key? :baccalaureats

      @baccalaureat = Baccalaureat.send params[:baccalaureats]
      @candidates = @candidates.where(baccalaureat_id: @baccalaureat.children_ids)
      @title += " #{params[:baccalaureats]}"
    end
  end

  def stats
    @candidates = Candidate.selection_selected
  end
end
