class BaccalaureatsController < ApplicationController
  before_action :set_baccalaureat, only: [:show, :edit, :update, :destroy]

  # GET /baccalaureats
  def index
    @baccalaureats = Baccalaureat.all.sort_by(&:to_s)
  end

  # GET /baccalaureats/1
  def show
    @candidates = @baccalaureat.inherited_candidates.ordered_by_evaluation.page params[:page]
  end

  # GET /baccalaureats/new
  def new
    @baccalaureat = Baccalaureat.new
  end

  # GET /baccalaureats/1/edit
  def edit
  end

  # POST /baccalaureats
  def create
    @baccalaureat = Baccalaureat.new(baccalaureat_params)
    if @baccalaureat.save
      redirect_to @baccalaureat, notice: 'Baccalaureat was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /baccalaureats/1
  def update
    if @baccalaureat.update(baccalaureat_params)
      redirect_to @baccalaureat, notice: 'Baccalaureat was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /baccalaureats/1
  def destroy
    @baccalaureat.destroy
    redirect_to baccalaureats_url, notice: 'Baccalaureat was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_baccalaureat
      @baccalaureat = Baccalaureat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def baccalaureat_params
      params.require(:baccalaureat).permit(:title, :parent_id, :quota, :evaluation_bonus)
    end
end
