class Candidates::ProductionController < ApplicationController
  def index
    @candidates = Candidate.all
    case params[:production]
    when 'yes'
      @title = 'Candidats avec production'
      @candidates = @candidates.where(production_in_formulaire: true)
    when 'maybe'
      @title = 'Candidats avec possible production'
      @candidates = @candidates.where(production_in_formulaire: false, production_somewhere_else: true)
    when 'not-analyzed'
      @title = 'Candidats à production non analysée'
      @candidates = @candidates.where(production_analyzed: false)
    when 'no'
      @title = 'Candidats sans production'
      @candidates = @candidates.where(production_in_formulaire: false, production_somewhere_else: false, production_analyzed: true)
    end
    @candidates = @candidates.page params[:page]
  end
end