class ModifiersController < ApplicationController
  before_action :set_modifier, only: [:show, :edit, :update, :destroy]

  # GET /modifiers
  def index
    @modifiers = Modifier.all
  end

  # GET /modifiers/1
  def show
  end

  # GET /modifiers/new
  def new
    @modifier = Modifier.new
  end

  # GET /modifiers/1/edit
  def edit
  end

  # POST /modifiers
  def create
    @modifier = Modifier.new(modifier_params)

    if @modifier.save
      redirect_to @modifier, notice: 'Modifier was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /modifiers/1
  def update
    if @modifier.update(modifier_params)
      redirect_to @modifier, notice: 'Modifier was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /modifiers/1
  def destroy
    @modifier.destroy
    redirect_to modifiers_url, notice: 'Modifier was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modifier
      @modifier = Modifier.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def modifier_params
      params.require(:modifier).permit(:title, :description, :value, :kind)
    end
end
