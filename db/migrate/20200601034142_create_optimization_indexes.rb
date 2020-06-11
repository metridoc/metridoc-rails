class CreateOptimizationIndexes < ActiveRecord::Migration[5.2]
  def up
    add_index :borrowdirect_bibliographies, :borrower 
    add_index :borrowdirect_bibliographies, :lender 
    add_index :borrowdirect_bibliographies, :request_number 
    add_index :borrowdirect_bibliographies, :patron_type 
    add_index :borrowdirect_bibliographies, [:borrower, :lender, :request_number, :patron_type], name: "borrowdirect_bibliographies_composite_idx"

    add_index :borrowdirect_ship_dates, :request_number 
    add_index :borrowdirect_ship_dates, :exception_code 
    add_index :borrowdirect_ship_dates, [:request_number, :exception_code] , name: "borrowdirect_ship_dates_composite_idx"

    add_index :borrowdirect_exception_codes, :exception_code

    add_index :borrowdirect_institutions, :library_id

    add_index :borrowdirect_print_dates, :request_number

    add_index :borrowdirect_min_ship_dates, :request_number

    add_index :borrowdirect_patron_types, :patron_type

    change_column :borrowdirect_bibliographies, :request_number, :text
    change_column :borrowdirect_ship_dates, :request_number, :text
  end
  def down
    remove_index :borrowdirect_bibliographies, :borrower 
    remove_index :borrowdirect_bibliographies, :lender 
    remove_index :borrowdirect_bibliographies, :request_number 
    remove_index :borrowdirect_bibliographies, :patron_type 

    remove_index :borrowdirect_ship_dates, :request_number 
    remove_index :borrowdirect_ship_dates, :exception_code 

    remove_index :borrowdirect_ship_dates, [:request_number, :exception_code] 

    remove_index :borrowdirect_bibliographies, [:borrower, :lender, :request_number, :patron_type]

    remove_index :borrowdirect_exception_codes, :exception_code

    remove_index :borrowdirect_institutions, :library_id

    remove_index :borrowdirect_print_dates, :request_number

    remove_index :borrowdirect_min_ship_dates, :request_number

    remove_index :borrowdirect_patron_types, :patron_type

    change_column :borrowdirect_bibliographies, :request_number, :string
    change_column :borrowdirect_ship_dates, :request_number, :string
  end
end

#
# EXPLAIN
# SELECT count(*)
# FROM "public"."borrowdirect_bibliographies" "borrowdirect_bibliographies"
#   INNER JOIN "public"."borrowdirect_institutions" "borrowdirect_institutions" ON ("borrowdirect_bibliographies"."borrower" = "borrowdirect_institutions"."library_id")
#   INNER JOIN "public"."borrowdirect_institutions" "borrowdirect_institutions1" ON ("borrowdirect_bibliographies"."lender" = "borrowdirect_institutions1"."library_id")
#   INNER JOIN "public"."borrowdirect_ship_dates" "borrowdirect_ship_dates" ON ("borrowdirect_bibliographies"."request_number" = "borrowdirect_ship_dates"."request_number")
#   INNER JOIN "public"."borrowdirect_exception_codes" "borrowdirect_exception_codes" ON ("borrowdirect_ship_dates"."exception_code" = "borrowdirect_exception_codes"."exception_code")
#   LEFT JOIN "public"."borrowdirect_print_dates" "borrowdirect_print_dates" ON ("borrowdirect_bibliographies"."request_number" = "borrowdirect_print_dates"."request_number")
#   LEFT JOIN "public"."borrowdirect_min_ship_dates" "borrowdirect_min_ship_dates" ON ("borrowdirect_bibliographies"."request_number" = "borrowdirect_min_ship_dates"."request_number")
#   LEFT JOIN "public"."borrowdirect_patron_types" "borrowdirect_patron_types" ON ("borrowdirect_bibliographies"."patron_type" = "borrowdirect_patron_types"."patron_type")
#
#
#
#
#   SELECT count(*)
#   FROM "public"."borrowdirect_bibliographies" "borrowdirect_bibliographies"
#     INNER JOIN "public"."borrowdirect_ship_dates" "borrowdirect_ship_dates" ON ("borrowdirect_bibliographies"."request_number" = "borrowdirect_ship_dates"."request_number")
#
#
# ALTER TABLE borrowdirect_bibliographies ALTER COLUMN request_number TYPE TEXT;
#
# ALTER TABLE borrowdirect_ship_dates ALTER COLUMN request_number TYPE TEXT;
#
#
#
#
#
#
# CREATE INDEX ON borrowdirect_bibliographies (borrower);
# CREATE INDEX ON borrowdirect_bibliographies (lender);
# CREATE INDEX ON borrowdirect_bibliographies (request_number);
# CREATE INDEX ON borrowdirect_bibliographies (patron_type);
#
# CREATE INDEX ON borrowdirect_ship_dates (request_number);
# CREATE INDEX ON borrowdirect_ship_dates (exception_code);
#
#
#
# CREATE INDEX ON borrowdirect_ship_dates (request_number, exception_code);
#
# CREATE INDEX ON borrowdirect_bibliographies(borrower, lender, request_number, patron_type);
#
# CREATE INDEX ON borrowdirect_exception_codes (exception_code);
#
# CREATE INDEX ON borrowdirect_institutions (library_id);
#
# CREATE INDEX ON borrowdirect_print_dates (request_number);
#
# CREATE INDEX ON borrowdirect_min_ship_dates (request_number);
#
# CREATE INDEX ON borrowdirect_patron_types (patron_type);
