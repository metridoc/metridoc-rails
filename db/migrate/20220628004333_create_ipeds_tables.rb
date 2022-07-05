class CreateIpedsTables < ActiveRecord::Migration[5.2]
  def change
    create_table :ipeds_completions do |t|
      t.integer :year
      t.integer :unitid
      t.text :cipcode
      t.integer :majornum
      t.integer :awlevel
      t.integer :ctotalt
      t.integer :ctotalm
      t.integer :ctotalw
      t.integer :caiant
      t.integer :caianm
      t.integer :caianw
      t.integer :casiat
      t.integer :casiam
      t.integer :casiaw
      t.integer :cbkaat
      t.integer :cbkaam
      t.integer :cbkaaw
      t.integer :chispt
      t.integer :chispm
      t.integer :chispw
      t.integer :cnhpit
      t.integer :cnhpim
      t.integer :cnhpiw
      t.integer :cwhitt
      t.integer :cwhitm
      t.integer :cwhitw
      t.integer :c2_mort
      t.integer :c2_morm
      t.integer :c2_morw
      t.integer :cunknt
      t.integer :cunknm
      t.integer :cunknw
      t.integer :cnralt
      t.integer :cnralm
      t.integer :cnralw
    end

    create_table :ipeds_completion_schema do |t|
      t.string :varname
      t.string :data_type
      t.integer :fieldwidth
      t.string :format
      t.string :imputationvar
      t.text :var_title
    end

    create_table :ipeds_directories do |t|
      t.integer :unitid
      t.text :instnm
      t.text :ialias
      t.text :addr
      t.text :city
      t.string :stabbr
      t.string :zip
      t.integer :fips
      t.integer :obereg
      t.text :chfnm
      t.text :chftitle
      t.text :gentele
      t.string :ein
      t.text :duns
      t.string :opeid
      t.integer :opeflag
      t.text :webaddr
      t.text :adminurl
      t.text :faidurl
      t.text :applurl
      t.text :npricurl
      t.text :veturl
      t.text :athurl
      t.text :disaurl
      t.integer :sector
      t.integer :iclevel
      t.integer :control
      t.integer :hloffer
      t.integer :ugoffer
      t.integer :groffer
      t.integer :hdegofr1
      t.integer :deggrant
      t.integer :hbcu
      t.integer :hospital
      t.integer :medical
      t.integer :tribal
      t.integer :locale
      t.integer :openpubl
      t.string :act
      t.integer :newid
      t.integer :deathyr
      t.text :closedat
      t.integer :cyactive
      t.integer :postsec
      t.integer :pseflag
      t.integer :pset4_flg
      t.integer :rptmth
      t.integer :instcat
      t.integer :c18_basic
      t.integer :c18_ipug
      t.integer :c18_ipgrd
      t.integer :c18_ugprf
      t.integer :c18_enprf
      t.integer :c18_szset
      t.integer :c15_basic
      t.integer :ccbasic
      t.integer :carnegie
      t.integer :landgrnt
      t.integer :instsize
      t.integer :f1_systyp
      t.text :f1_sysnam
      t.string :f1_syscod
      t.integer :cbsa
      t.integer :cbsatype
      t.integer :csa
      t.integer :necta
      t.integer :countycd
      t.text :countynm
      t.integer :cngdstcd
      t.float :longitud
      t.float :latitude
      t.integer :dfrcgid
      t.integer :dfrcuscg
    end

    create_table :ipeds_directory_schema do |t|
      t.string :varname
      t.string :data_type
      t.integer :fieldwidth
      t.string :format
      t.string :imputationvar
      t.text :var_title
    end

    create_table :ipeds_cipcodes do |t|
      t.string :cip_code2010
      t.text :cip_title2010
      t.text :action
      t.string :text_change
      t.string :cip_code2020
      t.text :cip_title2020
    end

    create_table :ipeds_stem_cipcodes do |t|
      t.string :cip_code_two_digit_series
      t.string :cip_code_2020
      t.text :cip_code_title
    end
  end # End of change
end
