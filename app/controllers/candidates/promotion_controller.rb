class Candidates::PromotionController < ApplicationController
  def index
    @candidates =  Candidate.promotion_selected.ordered_by_promotion
  end

  def stats
    @candidates = Candidate.promotion_selected
  end

  def select
    @candidate = Candidate.find(params[:candidate_id])
    @candidate.update_column :promotion_selected, true
    redirect_to candidates_selections_path
  end

  def unselect
    @candidate = Candidate.find(params[:candidate_id])
    @candidate.update_column :promotion_selected, false
    redirect_to candidates_selections_path
  end
end