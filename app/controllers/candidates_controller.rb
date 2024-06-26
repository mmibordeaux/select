class CandidatesController < ApplicationController
  before_action :set_candidate, only: [:show, :edit, :update, :destroy]

  # GET /candidates
  def index
    @title = 'Tous les dossiers'
    @candidates =  Candidate.ordered_by_evaluation
                            .includes(:baccalaureat)
    respond_to do |format|
      format.html do
        if params.has_key? :evaluations
          case params[:evaluations].to_i
          when 0
            @title = '0 évaluation'
            @candidates = @candidates.evaluation_todo
          when 1
            @title = '1 évaluation'
            @candidates = @candidates.evaluated_once_or_more
          when 2
            @title = '2 évaluations'
            @candidates = @candidates.evaluated_twice_or_more
          end
        end
        @candidates = @candidates.search params[:search] if params.has_key? :search
        @candidates = @candidates.page params[:page]
        @candidates_single_done = Candidate.evaluated_once_or_more.count
        @candidates_multiple_done = Candidate.evaluated_twice_or_more.count
        @candidates_multiple_todo = Candidate.evaluated_and_not_disqualified.count
        @candidates_total = Candidate.count
        @candidates_single_percent = @candidates_total.zero?    ? 0
                                                                : 100.0 * @candidates_single_done / @candidates_total
        @candidates_multiple_percent = @candidates_total.zero?  ? 0
                                                                : 100.0 * @candidates_multiple_done / @candidates_multiple_todo
      end
      format.xlsx
    end
  end

  def scholarship
    @candidates = Candidate.where(scholarship: true).ordered_by_evaluation.page params[:page]
  end

  # GET /candidates/1
  def show
    @bulletins_analyze = BulletinsAnalyze.new @candidate.bulletins_texts
    @candidate.evaluations.where(user: current_user).first_or_initialize
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
    @candidate.evaluation_done = true
    @candidate.evaluated_by = current_user
    @candidate.assign_attributes candidate_params
    if @candidate.save(context: :evaluation)
      remaining = current_user.evaluations.todo.count
      next_candidate = current_user.evaluations.todo.first
      if next_candidate
        redirect_to next_candidate, notice: "Evaluation enregistrée. Courage, plus que #{remaining} !"
      else
        redirect_to candidates_path, notice: "Terminé!"
      end
    else
      bulletins = @candidate.parcoursup_clean 'bulletins'
      @bulletins_analyze = BulletinsAnalyze.new bulletins
      render :show
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_candidate
      @candidate = Candidate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def candidate_params
      params.require(:candidate)
            .permit(:attitude_id, :intention_id, :production_id, :localization_id, :evaluation_comment, :baccalaureat_id, :dossier_note)
    end
end
