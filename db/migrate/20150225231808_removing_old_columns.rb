class RemovingOldColumns < ActiveRecord::Migration
  def change
    remove_column :divisions, :div_id
    remove_column :divisions, :standings
    remove_column :divisions, :pool_id

    remove_column :fields, :directions

    remove_column :profiles, :nickname
    remove_column :profiles, :emergency_name
    remove_column :profiles, :emergency_relation
    remove_column :profiles, :emergency_phone
    remove_column :profiles, :emergency_email

    remove_column :ratings, :ssma_timestamp
    remove_column :ratings, :rating_notes
    remove_column :ratings, :approver_notes
    remove_column :ratings, :rating_list
    remove_column :ratings, :rating_total
    remove_column :ratings, :history
    remove_column :ratings, :updated

    remove_column :rosters, :date_approved

    remove_column :seasons, :pool_id
    remove_column :seasons, :season_id

    remove_column :sponsors, :sponsor_id
    remove_column :sponsors, :date_created
    remove_column :sponsors, :date_updated
    remove_column :sponsors, :created_user_id
    remove_column :sponsors, :updated_user_id

    remove_column :teams, :teamsnap_id
    remove_column :teams, :team_code
    remove_column :teams, :team_status
    remove_column :teams, :contact
    remove_column :teams, :email
  end
end
