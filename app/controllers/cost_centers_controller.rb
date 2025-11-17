class CostCentersController < ApplicationController
  before_action :set_cost_center, only: [:show, :update, :destroy]

  # GET /cost_centers
  def index
    @cost_centers = CostCenter.all
    render json: @cost_centers
  end

  # GET /cost_centers/:id
  def show
    render json: @cost_center
  end

  # POST /cost_centers
  def create
    @cost_center = CostCenter.new(cost_center_params)

    if @cost_center.save
      render json: @cost_center, status: :created
    else
      render json: { errors: @cost_center.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cost_centers/:id
  def update
    if @cost_center.update(cost_center_params)
      render json: @cost_center
    else
      render json: { errors: @cost_center.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /cost_centers/:id
  def destroy
    @cost_center.destroy
    head :no_content
  end

  private

  def set_cost_center
    @cost_center = CostCenter.find(params[:id])
  end

  def cost_center_params
    params.require(:cost_center).permit(:name, :code, :description)
  end
end
