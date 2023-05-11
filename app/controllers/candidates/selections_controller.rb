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

  def stats_tech
    @candidates = Candidate.selection_selected.tech
    render :stats
  end

  def stats_gen
    @candidates = Candidate.selection_selected.gen
    render :stats
  end
end
