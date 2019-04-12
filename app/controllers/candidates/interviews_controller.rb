class Candidates::InterviewsController < ApplicationController
  before_action :set_candidate, only: [:show, :update]

  def index
    @candidates = Candidate.selected_for_interviews.page params[:page]
  end

  def stats
    @candidates = Candidate.selected_for_interviews
  end

  def show
    bulletins = @candidate.parcoursup_clean 'bulletins'
    @bulletins_analyze = BulletinsAnalyze.new bulletins
  end

  def update
    @candidate.interview_done = true
    @candidate.assign_attributes candidate_params
    if @candidate.save(context: :interview)
      redirect_to interviews_candidates_path
    else
      render :show
    end
  end


  protected

  def set_candidate
    @candidate = Candidate.find(params[:id])
  end

  def candidate_params
    params.require(:candidate)
          .permit(:interview_knowledge_id, :interview_project_id, :interview_motivation_id, 
            :interview_culture_id, :interview_argument_id, :interview_comment)
  end
end
