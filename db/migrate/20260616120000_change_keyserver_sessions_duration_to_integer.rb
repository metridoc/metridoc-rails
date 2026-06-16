class ChangeKeyserverSessionsDurationToInteger < ActiveRecord::Migration[7.2]
  # duration holds session length in whole seconds (derived from logoff - logon).
  # The longest plausible session is a few weeks (~10^6 seconds), so a 4-byte
  # integer (max ~2.1 * 10^9) is ample; the earlier bigint widening was only
  # needed to absorb an out-of-band sub-second (microsecond) representation that
  # we no longer store. See Keyserver::Session for where the value is now derived.
  #
  # Existing rows may hold those oversized values (and possibly a mix of units
  # from different import paths), so recompute duration in whole seconds from the
  # timestamps before narrowing the column — otherwise the type change fails with
  # PG::NumericValueOutOfRange. duration is exactly (logoff - logon); rows missing
  # either timestamp can't yield one and are nulled.
  def up
    execute(<<~SQL)
      UPDATE keyserver_sessions
      SET duration = CASE
        WHEN logon IS NULL OR logoff IS NULL THEN NULL
        ELSE EXTRACT(EPOCH FROM (logoff - logon))::bigint
      END;
    SQL

    # Defensive: null out anything that would still overflow int4 (e.g. corrupt
    # timestamps) so the type change can't fail on a stray pathological row.
    execute(<<~SQL)
      UPDATE keyserver_sessions
      SET duration = NULL
      WHERE duration IS NOT NULL
        AND (duration > 2147483647 OR duration < -2147483648);
    SQL

    change_column :keyserver_sessions, :duration, :integer
  end

  def down
    change_column :keyserver_sessions, :duration, :bigint
  end
end
