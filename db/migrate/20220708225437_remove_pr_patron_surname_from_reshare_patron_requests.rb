class RemovePrPatronSurnameFromResharePatronRequests < ActiveRecord::Migration[5.2]
  def change
    remove_column :reshare_patron_requests, :pr_patron_surname, :string
  end
end
