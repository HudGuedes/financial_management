class ChargesController < ApplicationController
  before_action :set_charge, only: [:show, :update, :destroy, :create_payment]

  # GET /charges
  def index
    @charges = Charge.includes(:payment_plan).all
    render json: @charges.map { |c| charge_json(c) }
  end

  # GET /charges/:id
  def show
    render json: charge_json(@charge)
  end

  # POST /charges
  def create
    @charge = Charge.new(charge_params)

    if @charge.save
      render json: charge_json(@charge), status: :created
    else
      render json: { errors: @charge.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /charges/:id
  def update
    if @charge.update(charge_params)
      render json: charge_json(@charge)
    else
      render json: { errors: @charge.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /charges/:id
  def destroy
    @charge.destroy
    head :no_content
  end

  # POST /charges/:id/payments
  def create_payment
    begin
      @charge.register_payment!(
        amount: payment_params[:amount],
        payment_date: payment_params[:payment_date] || Date.today,
        notes: payment_params[:notes]
      )

      render json: {
        message: 'Pagamento registrado com sucesso',
        charge: charge_json(@charge.reload),
        payment: @charge.payments.last
      }, status: :created
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def set_charge
    @charge = Charge.includes(:payment_plan).find(params[:id])
  end

  def charge_params
    params.require(:charge).permit(:payment_plan_id, :amount, :due_date, :payment_method, :status)
  end

  def payment_params
    params.require(:payment).permit(:amount, :payment_date, :notes)
  end

  def charge_json(charge)
    {
      id: charge.id,
      payment_plan_id: charge.payment_plan_id,
      amount: charge.amount,
      due_date: charge.due_date,
      payment_method: charge.payment_method,
      payment_code: charge.payment_code,
      status: charge.status,
      is_overdue: charge.overdue?,
      current_status: charge.current_status,
      created_at: charge.created_at,
      updated_at: charge.updated_at
    }
  end
end
