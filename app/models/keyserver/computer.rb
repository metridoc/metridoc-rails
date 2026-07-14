class Keyserver::Computer < Keyserver::Base
  # One row per physical computer. location is the physical space (mirrors
  # Keyserver::Session#location); section is the functional grouping used to
  # scope the keyserver_events admin view to public computing terminals.

  # Maps abbreviated header names used in Keyserver's raw CSV export to the
  # column names used in this table.
  def self.column_aliases
    {
      'name'     => 'computer_name',
      'division' => 'location',
    }
  end

  # Unlike Event/Session (append-only logs of historical records), this is a
  # dimension table describing current computer state, so re-uploads should
  # refresh location/section for computers we've already seen rather than
  # being ignored as duplicates.
  def self.on_conflict_update
    {
      conflict_target: [:computer_name],
      columns: [:location, :section]
    }
  end
end
