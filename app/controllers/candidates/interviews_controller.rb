class Candidates::InterviewsController < ApplicationController
  before_action :set_candidate, only: [:show, :update, :print]

  def index
    @candidates =  Candidate.evaluation_selected
                            .ordered_by_interview
                            .includes(:baccalaureat)
    @candidates = @candidates.search params[:search] if params.has_key? :search
    respond_to do |format|
      format.html { @candidates = @candidates.page params[:page] }
      format.xlsx {}
    end
    
  end

  def stats
    @candidates = Candidate.evaluation_selected
  end

  def show
  end

  def print
  end

  def update
    @candidate.interview_done = true
    @candidate.assign_attributes candidate_params
    if @candidate.save(context: :interview)
      redirect_to candidates_print_interview_path(@candidate)
    else
      render :show
    end
  end


  protected

  def set_candidate
    @candidate = Candidate.find(params[:id])
    @bulletins_analyze = BulletinsAnalyze.new @candidate.bulletins_texts
  end

  def candidate_params
    params.require(:candidate)
          .permit(:interview_knowledge_id, :interview_project_id, :interview_motivation_id,
            :interview_culture_id, :interview_argument_id, :interview_comment, :interview_bonus,
            interviewer_ids: [])
  end
end
