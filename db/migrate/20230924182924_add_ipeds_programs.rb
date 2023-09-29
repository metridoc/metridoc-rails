class AddIpedsPrograms < ActiveRecord::Migration[6.1]
  def change
    create_table :ipeds_programs do |t|
      t.integer :year
      t.integer :unitid
      t.text :cipcode
      t.integer :ptotal
      t.integer :ptotalde
      t.integer :ptotaldes
      t.integer :passoc
      t.integer :passocde
      t.integer :passocdes
      t.integer :pbachl
      t.integer :pbachlde
      t.integer :pbachldes
      t.integer :pmastr
      t.integer :pmastrde
      t.integer :pmastrdes
      t.integer :pdocrs
      t.integer :pdocrsde
      t.integer :pdocrsdes
      t.integer :pdocpp
      t.integer :pdocppde
      t.integer :pdocppdes
      t.integer :pdocot
      t.integer :pdocotde
      t.integer :pdocotdes
      t.integer :pcert1
      t.integer :pcert1_de
      t.integer :pcert1_a
      t.integer :pcert1_ade
      t.integer :pcert1_ades
      t.integer :pcert1_b
      t.integer :pcert1_bde
      t.integer :pcert1_bdes
      t.integer :pcert2
      t.integer :pcert2_de
      t.integer :pcert2_des
      t.integer :pcert4
      t.integer :pcert4_de
      t.integer :pcert4_des
      t.integer :ppbacc
      t.integer :ppbaccde
      t.integer :ppbaccdes
      t.integer :ppmast
      t.integer :ppmastde
      t.integer :ppmastdes

      t.index [:year, :unitid, :cipcode], unique: true, name: "ipeds_programs_unique_id"

    end

    create_table :ipeds_program_schema do |t|
      t.string :varname
      t.string :data_type
      t.integer :fieldwidth
      t.string :format
      t.string :imputationvar
      t.text :var_title

      t.index [:varname], unique: true, name: "ipeds_program_schema_unique_id"
    end
  end
end
