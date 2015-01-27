class UpdateTeamsTable < ActiveRecord::Migration
  def up
    add_column :teams, :team_code, :string
    add_column :teams, :team_status, :string
    add_column :teams, :win_perc, :string
    add_column :teams, :stat_games_back, :integer
    add_column :teams, :date_created, :datetime
    add_column :teams, :date_updated, :datetime
    add_column :teams, :date_approved, :datetime
    add_column :teams, :contact, :string
    add_column :teams, :email, :string
    add_column :teams, :created_user_id, :integer
    add_column :teams, :updated_user_id, :integer
  end
 
  def down
    remove_column :teams, :team_code
    remove_column :teams, :team_status
    remove_column :teams, :win_perc
    remove_column :teams, :stat_games_back
    remove_column :teams, :date_created
    remove_column :teams, :date_updated
    remove_column :teams, :date_approved
    remove_column :teams, :contact
    remove_column :teams, :email
    remove_column :teams, :created_user_id
    remove_column :teams, :updated_user_id
  end
end
