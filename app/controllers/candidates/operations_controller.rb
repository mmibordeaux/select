class Candidates::OperationsController < ApplicationController
  def import
    Candidate.import params[:csv] if params[:csv]
  end

  def positionize
    Candidate.positionize
    redirect_to candidates_path
  end
end