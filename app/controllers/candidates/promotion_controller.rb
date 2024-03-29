class Candidates::PromotionController < ApplicationController
  def index
    @candidates =  Candidate.promotion_selected.ordered_by_promotion
  end

  def stats
    @candidates = Candidate.promotion_selected
  end

  def stats_tech
    @candidates = Candidate.promotion_selected.tech
    render :stats
  end

  def stats_gen
    @candidates = Candidate.promotion_selected.gen
    render :stats
  end

  def select
    @candidate = Candidate.find(params[:candidate_id])
    @candidate.update_column :promotion_selected, true
    redirect_to @candidate, notice: 'Personne sélectionnée'
  end

  def unselect
    @candidate = Candidate.find(params[:candidate_id])
    @candidate.update_column :promotion_selected, false
    redirect_to @candidate, notice: 'Personne désélectionnée'
  end
end