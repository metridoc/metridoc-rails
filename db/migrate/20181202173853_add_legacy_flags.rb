class AddLegacyFlags < ActiveRecord::Migration[5.1]
  def change

    add_column :borrowdirect_bibliographies      , :is_legacy, :boolean, null: false, default: false;
    add_column :borrowdirect_call_numbers        , :is_legacy, :boolean, null: false, default: false;
    add_column :borrowdirect_exception_codes     , :is_legacy, :boolean, null: false, default: false;
    add_column :borrowdirect_institutions        , :is_legacy, :boolean, null: false, default: false;
    add_column :borrowdirect_min_ship_dates      , :is_legacy, :boolean, null: false, default: false;
    add_column :borrowdirect_patron_types        , :is_legacy, :boolean, null: false, default: false;
    add_column :borrowdirect_print_dates         , :is_legacy, :boolean, null: false, default: false;
    add_column :borrowdirect_ship_dates          , :is_legacy, :boolean, null: false, default: false;

    add_column :ezborrow_bibliographies          , :is_legacy, :boolean, null: false, default: false;
    add_column :ezborrow_call_numbers            , :is_legacy, :boolean, null: false, default: false;
    add_column :ezborrow_exception_codes         , :is_legacy, :boolean, null: false, default: false;
    add_column :ezborrow_institutions            , :is_legacy, :boolean, null: false, default: false;
    add_column :ezborrow_min_ship_dates          , :is_legacy, :boolean, null: false, default: false;
    add_column :ezborrow_patron_types            , :is_legacy, :boolean, null: false, default: false;
    add_column :ezborrow_print_dates             , :is_legacy, :boolean, null: false, default: false;
    add_column :ezborrow_ship_dates              , :is_legacy, :boolean, null: false, default: false;

    add_column :illiad_borrowings                , :is_legacy, :boolean, null: false, default: false;
    add_column :illiad_groups                    , :is_legacy, :boolean, null: false, default: false;
    add_column :illiad_history_records           , :is_legacy, :boolean, null: false, default: false;
    add_column :illiad_lender_groups             , :is_legacy, :boolean, null: false, default: false;
    add_column :illiad_lender_infos              , :is_legacy, :boolean, null: false, default: false;
    add_column :illiad_lending_trackings         , :is_legacy, :boolean, null: false, default: false;
    add_column :illiad_lendings                  , :is_legacy, :boolean, null: false, default: false;
    add_column :illiad_reference_numbers         , :is_legacy, :boolean, null: false, default: false;
    add_column :illiad_trackings                 , :is_legacy, :boolean, null: false, default: false;
    add_column :illiad_transactions              , :is_legacy, :boolean, null: false, default: false;
    add_column :illiad_user_infos                , :is_legacy, :boolean, null: false, default: false;

  end
end
