class Console::BillsController < ConsoleController
  before_filter :require_admin

  def index
    @title = "Оплаченные и неоплаченные счета"
    @invoices = Invoice.paginate :page => params[:page], :per_page => 100, :order => 'id desc'
  end

  def confirm
    @invoice = Invoice.find(params[:id])
    @invoice.success!
    @invoice.expand_premium_for_user!
    redirect_to :action => :index
  end
end
