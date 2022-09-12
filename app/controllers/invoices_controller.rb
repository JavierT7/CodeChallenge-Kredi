class InvoicesController < ApplicationController
  require 'zip'

  before_action :set_invoice, only: %i[ show edit update destroy ]

  # GET /invoices
  def index
    if params[:filters].present?
      filters     = params[:filters]
      @status     = filters['status']
      @emitter    = filters['emitter']
      @receiver   = filters['receiver']
      @range_min  = filters['amount_range_min']
      @range_max  = filters['amount_range_max']

      @invoices = Invoice.f_by_status(@status).f_by_emitter(@emitter).f_by_receiver(@receiver).min_amount(@range_min).max_amount(@range_max)
      @invoices = @invoices.paginate(:page => params[:page], :per_page => 30)
    else
      @invoices = Invoice.all.paginate(:page => params[:page], :per_page => 30)
    end
  end

  # GET /invoices/1
  def show
  end

  # GET /users/new
  def new
    @invoice = Invoice.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /invoices
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to invoices_path, notice: "Invoice was successfully created." }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to invoices_path, notice: "Invoice was successfully updated." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url, notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def my_invoices
    if params[:filters].present?
      filters = params[:filters]
      @invoice_type = filters['invoice_type']
      @start_date   = Date.civil(filters["min_emitted_at(1i)"].to_i,
                               filters["min_emitted_at(2i)"].to_i,
                               filters["min_emitted_at(3i)"].to_i)

      @end_date = Date.civil(filters["max_emitted_at(1i)"].to_i,
                             filters["max_emitted_at(2i)"].to_i,
                             filters["max_emitted_at(3i)"].to_i)
      @invoices = Invoice.f_by_type(@invoice_type, current_user.id).f_by_min_emitted_at(@start_date).f_by_max_emitted_at(@end_date)
      @invoices = @invoices.paginate(:page => params[:page], :per_page => 30)
    else
      @invoices = Invoice.where(emitter: current_user.id).or(Invoice.where(receiver: current_user.id)).paginate(:page => params[:page], :per_page => 30)
    end
  end

  def upload_zip_file
    if params[:zip_file].present?
      SaveInvoicesWorker.perform_async(params[:zip_file].tempfile.path)
    end
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: "Invoices in process, please refresh later." }
      format.json { head :no_content }
    end
  end

  def invoice_qr_code
    @invoice = Invoice.find(params[:id])
    @qr_code = RQRCode::QRCode.new(@invoice.try(:cfdi_digital_stamp))
    @svg = @qr_code.as_svg(
                       offset: 0,
                       color: '000',
                       shape_rendering: 'cripsEdges',
                       module_size: 6
    )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.require(:invoice).permit(:invoice_uid, :status, :emitter_id, :receiver_id, :amount_cents, :amount_currency, :emitted_at, :expires_at, :signed_at, :cfdi_digital_stamp)
    end
end
