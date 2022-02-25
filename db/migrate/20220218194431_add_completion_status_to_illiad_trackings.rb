class AddCompletionStatusToIlliadTrackings < ActiveRecord::Migration[5.2]
  def change
    add_column :illiad_trackings, :completion_status, :string
  end
end
