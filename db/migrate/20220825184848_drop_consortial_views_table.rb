class DropConsortialViewsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :reshare_consortial_views
    drop_table :reshare_req_overdues
    drop_table :reshare_sup_overdues
    drop_table :reshare_rtat_reqs
    drop_table :reshare_rtat_ships
    drop_table :reshare_rtat_recs
    drop_table :reshare_stat_reqs
    drop_table :reshare_stat_assis
    drop_table :reshare_stat_ships
    drop_table :reshare_stat_recs
    drop_table :reshare_sup_tat_stats
    drop_table :reshare_sup_stats
    drop_table :reshare_req_stats
  end
end
