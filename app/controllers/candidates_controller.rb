class CandidatesController < ApplicationController
  before_action :set_candidate, only: [:show, :edit, :update, :destroy]

  # GET /candidates
  def index
    @candidates = Candidate.ordered_by_evaluation.includes(:baccalaureat)
    @candidates = @candidates.search params[:search] if params.has_key? :search
    @candidates = @candidates.page params[:page]
  end

  def import
    Candidate.import params[:csv] if params[:csv]
  end

  def scholarship
    @candidates = Candidate.where(scholarship: true).page params[:page]
  end

  def production
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

  def positionize
    Candidate.positionize
    redirect_to candidates_path
  end

  def my
    @candidates = current_user.candidates_attributed
    @candidates_todo = @candidates.todo.page params[:page_todo]
    @candidates_done = @candidates.done.page params[:page_done]
  end

  # GET /candidates/1
  def show
  end

  # GET /candidates/new
  def new
    @candidate = Candidate.new
  end

  # GET /candidates/1/edit
  def edit
  end

  # POST /candidates
  def create
    @candidate = Candidate.new(candidate_params)

    if @candidate.save
      redirect_to @candidate, notice: 'Candidate was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /candidates/1
  def update
    @candidate.production_auto_evaluated = false
    @candidate.evaluated_by = current_user
    @candidate.assign_attributes candidate_params
    if @candidate.save(context: :evaluation)
      redirect_to @candidate, notice: 'Candidate was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /candidates/1
  def destroy
    @candidate.destroy
    redirect_to candidates_url, notice: 'Candidate was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_candidate
      @candidate = Candidate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def candidate_params
      params.require(:candidate).permit(:attitude_id, :intention_id, :production_id, :localization_id, :evaluation_comment, :baccalaureat_id, :dossier_note)
    end
end
