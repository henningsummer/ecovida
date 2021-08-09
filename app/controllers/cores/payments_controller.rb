class Cores::PaymentsController < ApplicationController
  before_action :require_admin
  before_action :set_year
  before_filter :find_core
  before_filter :find_payment, only: [:destroy, :edit, :update]

  def index
    params[:q] ||= {}
    if params[:q][:in_force_year_eq].present?
      @year = params[:q][:in_force_year_eq]
      @summarized = @core.summarizing(@year.to_i)
      @q = CorePayment.search_by_year(@year)
      @payments = @q.result(distinct: true).where(core: @core).page(params[:page]).per(20)
      @payed = @payments.map(&:amount).reduce(:+).to_f
      @to_pay =  @summarized[:amount] - @payed
    else
      @q = CorePayment.ransack(params[:q])
      @payments = @q.result(distinct: true).page(params[:page]).per(20)
    end
  end

  def new
    if user_type == 4 #Se é administrador
      @payment = CorePayment.new
    end
  end

  def create
    @payment = CorePayment.new(payment_params)

    respond_to do |format|
      @payment.core_id = @core.id
      if @payment.save

        #LOG#
        SystemLog.create(description: "Criou um novo pagamento para o núcleo #{@core.name}", author: name_and_type_of_logged_user)

        format.html { redirect_to core_payments_path, notice: "Pagamento para o Núcleo #{@core.name} foi criado com sucesso." }
        format.json { render :index, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @payment.update(payment_params)
        SystemLog.create(description: "Editou um pagamento do núcleo #{@core.name} com id #{@payment.id}", author: name_and_type_of_logged_user)
        format.html { redirect_to core_payments_path, notice: "Pagamento de id #{@payment.id} foi atualizado com sucesso." }
        format.json { render :index, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @payment.destroy
    SystemLog.create(description: "Deletou um pagamento do Núcleo #{@core.name}", author: name_and_type_of_logged_user)
    respond_to do |format|
      format.html { redirect_to core_payments_path, notice: 'Pagamento Deletado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private

  def find_core
    @core = Core.find(params[:core_id]) if params[:core_id]
  end

  def find_payment
    @payment = CorePayment.find(params[:id])
  end

  def set_year
    params[:q] = {} if params[:q].nil?
    params[:q][:in_force_year_eq] ||= Date.today.year
  end

  def payment_params
    params
      .require(:core_payment)
      .permit(
        :description,
        :amount,
        :payment_date,
        :in_force_year
      )
  end
end
