class Candidates::PromotionController < ApplicationController
  def index
    @candidates =  Candidate.promotion_selected.ordered_by_promotion
  end

  def stats
    @candidates = Candidate.promotion_selected
  end
end