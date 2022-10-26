ActiveAdmin.register Reshare::PatronRequestRota do
  menu false
  actions :all, :except => [:new, :edit, :update, :destroy]

  permit_params :last_updated,
    :origin,
    :prr_id,
    :prr_version,
    :prr_date_created,
    :prr_last_updated,
    :prr_rota_position,
    :prr_directory_id_fk,
    :prr_patron_request_fk,
    :prr_state_fk,
    :prr_peer_symbol_fk,
    :prr_lb_score,
    :prr_lb_reason
end
