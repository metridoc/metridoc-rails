class AddPickLocationToReshare < ActiveRecord::Migration[7.1]
  def change
    add_column :bd_reshare_patron_requests, :pr_pick_shelving_location_fk, :string
    add_column :bd_reshare_patron_requests, :pr_patron_identifier, :string
    add_column :bd_reshare_transactions, :fiscal_year, :integer
    add_column :bd_reshare_lending_turnarounds, :fiscal_year, :integer
    add_column :bd_reshare_borrowing_turnarounds, :fiscal_year, :integer

    add_column :reshare_patron_requests, :pr_pick_shelving_location_fk, :string
    add_column :reshare_patron_requests, :pr_patron_identifier, :string
    add_column :reshare_transactions, :fiscal_year, :integer
    add_column :reshare_lending_turnarounds, :fiscal_year, :integer
    add_column :reshare_borrowing_turnarounds, :fiscal_year, :integer

  end
end
