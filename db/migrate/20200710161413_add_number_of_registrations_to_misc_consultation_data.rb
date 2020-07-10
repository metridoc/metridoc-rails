class AddNumberOfRegistrationsToMiscConsultationData < ActiveRecord::Migration[5.2]
  def change
    add_column :misc_consultation_data, :number_of_registrations, :integer
    add_column :misc_consultation_data, :referral_method, :string
  end
end
