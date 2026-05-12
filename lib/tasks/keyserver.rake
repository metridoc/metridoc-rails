namespace :keyserver do

  desc <<~DESC
    Assign stable opaque aliases to all user_name values in keyserver_events
    and keyserver_sessions that do not yet have an entry in
    keyserver_user_name_maps.

    Aliases are of the form "user_NNNN" where NNNN is a zero-padded integer
    assigned in insertion order.  Once assigned, an alias never changes —
    re-running this task after a fresh import adds only new usernames.

    Run after every import:
      rake import -- --config_folder keyserver
      rake keyserver:seed_user_names
  DESC
  task seed_user_names: :environment do
    inserted = Keyserver::UserNameMap.seed
    if inserted == 0
      puts "keyserver:seed_user_names — no new usernames to map."
    else
      puts "keyserver:seed_user_names — assigned #{inserted} new alias(es). " \
           "Total mapped: #{Keyserver::UserNameMap.count}."
    end
  end

end
