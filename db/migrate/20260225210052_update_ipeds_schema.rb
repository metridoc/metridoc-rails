class UpdateIpedsSchema < ActiveRecord::Migration[7.2]
  def change
    add_column :ipeds_directories, :ueis, :string
    add_column :ipeds_directories, :c00_carnegie, :integer
    add_column :ipeds_directories, :c21_basic, :integer
    add_column :ipeds_directories, :carnegieic, :integer
    add_column :ipeds_directories, :carnegiesaec, :integer
    add_column :ipeds_directories, :carnegiersch, :integer
    add_column :ipeds_directories, :carnegiesize, :integer
    add_column :ipeds_directories, :carnegiealf, :integer
    add_column :ipeds_directories, :carnegieapm, :integer
    add_column :ipeds_directories, :carnegiegpm, :integer
  end
end
