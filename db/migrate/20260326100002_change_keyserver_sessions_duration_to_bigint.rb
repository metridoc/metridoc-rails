class ChangeKeyserverSessionsDurationToBigint < ActiveRecord::Migration[7.0]
  def change
    change_column :keyserver_sessions, :duration, :bigint
  end
end
