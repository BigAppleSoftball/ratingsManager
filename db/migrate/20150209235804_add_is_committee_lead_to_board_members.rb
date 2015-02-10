class AddIsCommitteeLeadToBoardMembers < ActiveRecord::Migration
  def up
    add_column :board_members, :is_committee_lead, :boolean
  end

  def down
    remove_column :board_members, :is_committee_lead
  end
end
