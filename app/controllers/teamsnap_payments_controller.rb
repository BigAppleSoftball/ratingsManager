class TeamsnapPaymentsController < ApplicationController

  # POST /teamsnap_payments
  # POST /teamsnap_payments.json
  def create
    @teamsnap_payments = TeamsnapPayment.new(teamsnap_payment_params)

    respond_to do |format|
      if @teamsnap_payments.save
        format.html { redirect_to '/payments/list', notice: 'Teamsnap Payment  was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
    def set_teamsnap_payment
      @teamsnap_payment = TeamsnapPayment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teamsnap_payment_params
      params.require(:teamsnap_payment).permit(:teamsnap_player_id, :teamsnap_player_name, :teamsnap_player_email)
    end
end