class Keyserver::Event < Keyserver::Base
  # Represents a single Keyserver event record (one row per software event).
  #
  # user_name is the raw identifier as Keyserver recorded it — some values
  # are PennKeys and can be joined to Alma demographics; others are not.

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

  # Maps abbreviated header names used in Keyserver's raw CSV export to the
  # column names used in this table. Applied by Tools::FileUploadImport before
  # schema matching so uploads can use the file as-is without renaming headers.
  def self.superadmin_columns
    ['user_name']
  end

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

  def self.on_conflict_update
    {
      conflict_target: [:computer_name, :occurred_at, :application, :event_type, :user_name],
      columns: []
    }
  end

end
