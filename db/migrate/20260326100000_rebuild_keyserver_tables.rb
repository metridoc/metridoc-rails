class RebuildKeyserverTables < ActiveRecord::Migration[7.0]
  def up
    # ── Drop old tables ────────────────────────────────────────────────────────
    %i[
      keyserver_programs
      keyserver_computers
      keyserver_status_terms
      keyserver_reason_terms
      keyserver_platform_terms
      keyserver_event_terms
      keyserver_cpu_type_terms
      keyserver_usages
    ].each { |t| drop_table t, if_exists: true }

    # ── keyserver_events ───────────────────────────────────────────────────────
    create_table :keyserver_events do |t|
      t.string   :computer_name
      t.datetime :occurred_at
      t.string   :application
      t.string   :version
      t.string   :event_type
      t.string   :product
      t.string   :user_name
      t.string   :address
      t.timestamps null: true
    end

    add_index :keyserver_events, :computer_name
    add_index :keyserver_events, [:computer_name, :occurred_at]
    add_index :keyserver_events, :occurred_at
    add_index :keyserver_events, :user_name

    # ── keyserver_sessions ─────────────────────────────────────────────────────
    create_table :keyserver_sessions do |t|
      t.string   :computer_name
      t.string   :user_name
      t.datetime :logon
      t.datetime :logoff
      t.integer  :duration
      t.string   :address
      t.string   :location
      t.timestamps null: true
    end

    add_index :keyserver_sessions, [:computer_name, :logon, :logoff]
    add_index :keyserver_sessions, [:location, :logon]
    add_index :keyserver_sessions, :user_name

    # ── keyserver_app_name_overrides ───────────────────────────────────────────
    # raw_name  — the application string exactly as Keyserver records it
    # canonical — the preferred display name to use instead
    create_table :keyserver_app_name_overrides do |t|
      t.string :raw_name,  null: false
      t.string :canonical, null: false
    end

    add_index :keyserver_app_name_overrides, :raw_name, unique: true

    # ── normalize_app_name PostgreSQL function ─────────────────────────────────
    # Checks app_name_overrides first, then strips version numbers and
    # parenthetical arch/OS suffixes from application names.
    # Regex steps (applied in order):
    #   1. strip parenthetical content  e.g. "(x64)", "(Windows)"
    #   2. strip trailing " - X.Y.Z" build suffixes
    #   3. strip trailing dotted version numbers e.g. " 120.0", " 24.07"
    #      (bare year/product numbers like "365" or "2022" are preserved)
    #   4. collapse runs of whitespace left by stripping
    execute <<~SQL
      CREATE OR REPLACE FUNCTION normalize_app_name(raw TEXT) RETURNS TEXT AS $$
          SELECT COALESCE(
              (SELECT canonical FROM keyserver_app_name_overrides WHERE raw_name = raw),
              TRIM(
                  REGEXP_REPLACE(
                      REGEXP_REPLACE(
                          REGEXP_REPLACE(
                              REGEXP_REPLACE(raw, '\\s*\\([^)]*\\)\\s*', ' ', 'g'),
                              '\\s*-\\s*\\d[\\d.]+\\s*$', ''),
                          '\\s+\\d+\\.\\d[\\d.]*\\s*$', ''),
                      '\\s+', ' ', 'g')
              )
          );
      $$ LANGUAGE SQL STABLE;
    SQL
  end

  def down
    execute "DROP FUNCTION IF EXISTS normalize_app_name(TEXT);"

    drop_table :keyserver_app_name_overrides, if_exists: true
    drop_table :keyserver_sessions,           if_exists: true
    drop_table :keyserver_events,             if_exists: true
  end
end
