class RenameIssueIdToMotionIdInMotionOptions < ActiveRecord::Migration
  def change
    rename_column :motion_options, :issue_id, :motion_id
  end
end
