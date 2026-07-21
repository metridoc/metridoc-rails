class Keyserver::Event < Keyserver::Base
  # Represents a single Keyserver event record (one row per software event).
  #
  # user_name and computer_name are raw identifiers as Keyserver recorded them
  # — some user_name values are PennKeys and can be joined to Alma demographics;
  # others are not. They are treated as super-admin-only columns: the admin views
  # display them only to super admins (see app/admin/keyserver/event.rb),
  # following the superadmin_columns pattern.
  def self.superadmin_columns = [:user_name, :computer_name]

  # Maps abbreviated header names used in Keyserver's raw CSV export to the
  # column names used in this table. Applied by Tools::FileUploadImport before
  # schema matching so uploads can use the file as-is without renaming headers.
  def self.column_aliases
    {
      'name'     => 'application',
      'vers'     => 'version',
      'event'    => 'event_type',
      'when'     => 'occurred_at',
      'user'     => 'user_name',
      'computer' => 'computer_name'
    }
  end

  # Checkout event types — the set that represents a user actually launching
  # or starting a managed product.
  CHECKOUT_EVENTS = %w[
    launch
    logged\ launch
    launch\ offline
    logged\ launch\ offline
    license\ start
    product\ usage\ start
  ].freeze

  # Infrastructure / housekeeping event types that carry no software identity
  # and should be excluded from usage analysis.
  INFRA_EVENTS = %w[
    obtain return logon logoff block
    info up down
    shadow\ info shadow\ up shadow\ down
    audited issued revoked deny\ unkeyed
    session\ idle\ start session\ idle\ stop
  ].freeze

  scope :checkouts,     -> { where(event_type: CHECKOUT_EVENTS) }
  scope :non_infra,     -> { where.not(event_type: INFRA_EVENTS) }
  scope :with_product,  -> { where.not(product: [nil, ""]) }

  # Re-uploading a file that overlaps existing data is safe: rows matching the
  # natural key are left untouched rather than raising a uniqueness error.
  def self.on_conflict_update
    {
      conflict_target: [:computer_name, :occurred_at, :application, :event_type, :user_name],
      columns: []
    }
  end
end
