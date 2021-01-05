require 'rails_helper'

RSpec.describe Import::Task, type: :model do
  it "imports a csv file" do
    main = Import::Main.new(config_folder: "google_analytics")
    task_filename = Rails.root.join('spec','fixtures','test.csv')
    t = described_class.new(main, task_filename, true)
  end
end
