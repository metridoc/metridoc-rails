class CreateAdditionalReshareTables < ActiveRecord::Migration[5.2]
  def change
    create_table :reshare_status do |t|
      t.column :last_updated, :datetime
      t.column :origin, :string

      t.column :st_id, :string
      t.column :st_version, :string
      t.column :st_owner, :string
      t.column :st_code, :string

      t.index :st_id, unique: true
    end

    create_table :reshare_patron_request_audits do |t|
      t.column :last_updated, :datetime
      t.column :origin, :string

      t.column :pra_id, :string
      t.column :pra_version, :string
      t.column :pra_date_created, :datetime

      t.column :pra_patron_request_fk, :string

      t.column :pra_from_status_fk, :string
      t.column :pra_to_status_fk, :string
      t.column :pra_message, :string

      t.index :pra_id, unique: true
    end

    change_table :reshare_patron_requests do |t|
      t.column :pr_due_date_from_lms, :datetime
      t.column :pr_parsed_due_date_lms, :datetime
      t.column :pr_due_date_rs, :datetime
      t.column :pr_parsed_due_date_rs, :datetime

      t.column :pr_overdue, :boolean
    end
  end
end
