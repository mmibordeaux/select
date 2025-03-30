class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: [:show, :edit, :update, :destroy]

  # GET /evaluations
  def index
    @evaluations = Evaluation.all
  end

  # GET /evaluations/1
  def show
  end

  # GET /evaluations/new
  def new
    @evaluation = Evaluation.new
  end

  # GET /evaluations/1/edit
  def edit
  end

  # POST /evaluations
  def create
    @evaluation = Evaluation.new(evaluation_params)
    @candidate = @evaluation.candidate
    if @evaluation.save(context: :evaluation)
      redirect
    else
      render :new
    end
  end

  # PATCH/PUT /evaluations/1
  def update
    @evaluation.assign_attributes evaluation_params
    @candidate = @evaluation.candidate
    if @evaluation.save(context: :evaluation)
      redirect
    else
      render :edit
    end
  end

  def no_url
    Evaluation.no_url params[:candidate], current_user.id
    redirect
  end

  # DELETE /evaluations/1
  def destroy
    @evaluation.destroy
    redirect_to evaluations_url, notice: 'Evaluation was successfully destroyed.'
  end

  private

  def redirect
    remaining = current_user.evaluations.todo.count
    next_evaluation = current_user.evaluations.todo.first
    if next_evaluation
      redirect_to next_evaluation.candidate, notice: "Evaluation enregistrée. Courage, plus que #{remaining} !"
    else
      redirect_to candidates_path, notice: "Terminé!"
    end
  end

  def set_evaluation
    @evaluation = Evaluation.find(params[:id])
  end

  def evaluation_params
    params.require(:evaluation).permit(:candidate_id, :user_id, :attitude_id, :intention_id, :production_id, :localization_id, :comment, :boost)
  end
end
