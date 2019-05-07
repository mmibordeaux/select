class Candidates::OperationsController < ApplicationController
  def import
    Candidate.import params[:csv] if params[:csv]
  end
end