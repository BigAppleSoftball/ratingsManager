class TeamsnapPaymentsSync < ActiveRecord::Base

  def run_on
    self.created_at.in_time_zone('Eastern Time (US & Canada)').strftime('%B %e at %l:%M:%S %p')
  end
end
