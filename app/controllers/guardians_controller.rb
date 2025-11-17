class GuardiansController < ApplicationController
  before_action :set_guardian, only: [:show, :update, :destroy, :payment_plans, :charges, :charges_count]

  # GET /guardians
  def index
    @guardians = Guardian.all
    render json: @guardians
  end

  # GET /guardians/:id
  def show
    render json: @guardian
  end

  # POST /guardians
  def create
    @guardian = Guardian.new(guardian_params)

    if @guardian.save
      render json: @guardian, status: :created
    else
      render json: { errors: @guardian.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /guardians/:id
  def update
    if @guardian.update(guardian_params)
      render json: @guardian
    else
      render json: { errors: @guardian.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /guardians/:id
  def destroy
    @guardian.destroy
    head :no_content
  end

  # GET /guardians/:id/payment_plans
  def payment_plans
    @payment_plans = @guardian.payment_plans.includes(:cost_center, :charges)
    render json: @payment_plans, include: ['cost_center', 'charges']
  end

  # GET /guardians/:id/charges
  def charges
    @charges = @guardian.charges.includes(:payment_plan)

    charges_data = @charges.map do |charge|
      {
        id: charge.id,
        payment_plan_id: charge.payment_plan_id,
        amount: charge.amount,
        due_date: charge.due_date,
        payment_method: charge.payment_method,
        payment_code: charge.payment_code,
        status: charge.status,
        is_overdue: charge.overdue?,
        current_status: charge.current_status
      }
    end

    render json: charges_data
  end

  # GET /guardians/:id/charges/count
  def charges_count
    count = @guardian.total_charges_count
    render json: { guardian_id: @guardian.id, charges_count: count }
  end

  private

  def set_guardian
    @guardian = Guardian.find(params[:id])
  end

  def guardian_params
    params.require(:guardian).permit(:name, :cpf, :email, :phone)
  end
end
