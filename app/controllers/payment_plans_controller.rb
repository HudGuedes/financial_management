class PaymentPlansController < ApplicationController
  before_action :set_payment_plan, only: [:show, :update, :destroy, :total]

  # GET /payment_plans
  def index
    @payment_plans = PaymentPlan.includes(:guardian, :cost_center, :charges).all
    render json: @payment_plans, include: ['guardian', 'cost_center', 'charges']
  end

  # GET /payment_plans/:id
  def show
    render json: {
      id: @payment_plan.id,
      guardian: @payment_plan.guardian,
      cost_center: @payment_plan.cost_center,
      total_amount: @payment_plan.total_amount,
      charges: @payment_plan.charges.map { |c| charge_json(c) },
      created_at: @payment_plan.created_at,
      updated_at: @payment_plan.updated_at
    }
  end

  # POST /payment_plans
  def create
    @payment_plan = PaymentPlan.new(payment_plan_params)

    if @payment_plan.save
      render json: {
        id: @payment_plan.id,
        guardian: @payment_plan.guardian,
        cost_center: @payment_plan.cost_center,
        total_amount: @payment_plan.total_amount,
        charges: @payment_plan.charges.map { |c| charge_json(c) }
      }, status: :created
    else
      render json: { errors: @payment_plan.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payment_plans/:id
  def update
    if @payment_plan.update(payment_plan_params)
      render json: @payment_plan, include: ['guardian', 'cost_center', 'charges']
    else
      render json: { errors: @payment_plan.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /payment_plans/:id
  def destroy
    @payment_plan.destroy
    head :no_content
  end

  # GET /payment_plans/:id/total
  def total
    render json: {
      payment_plan_id: @payment_plan.id,
      total_amount: @payment_plan.total_amount,
      currency: 'BRL'
    }
  end

  private

  def set_payment_plan
    @payment_plan = PaymentPlan.includes(:guardian, :cost_center, :charges).find(params[:id])
  end

  def payment_plan_params
    params.require(:payment_plan).permit(
      :guardian_id,
      :cost_center_id,
      charges_attributes: [:amount, :due_date, :payment_method]
    )
  end

  def charge_json(charge)
    {
      id: charge.id,
      amount: charge.amount,
      due_date: charge.due_date,
      payment_method: charge.payment_method,
      payment_code: charge.payment_code,
      status: charge.status,
      is_overdue: charge.overdue?,
      current_status: charge.current_status
    }
  end
end
