class Keyserver::AnalysisController < ApplicationController
  layout 'keyserver'

  # Keyserver software usage analysis.
  # All views are aggregate-only; no individual user identifiers are exposed.

  # GET /keyserver
  # Full software usage profile for all managed products on non-staff computers.
  # Optional query param: status (Active | Stale | Dormant) to pre-filter.
  def index
    @profiles = Keyserver::SoftwareUsageProfile.order(checkouts: :desc)
    @profiles = @profiles.where(status: params[:status]) if params[:status].present?

    @status_counts = Keyserver::SoftwareUsageProfile
                       .group(:status)
                       .count
                       .sort_by { |s, _| Keyserver::SoftwareUsageProfile::STATUS_ORDER.fetch(s, 99) }
                       .to_h
  end

  # GET /keyserver/stale
  # Products with no checkout in 90+ days, sorted by most dormant first.
  def stale
    @profiles = Keyserver::SoftwareUsageProfile
                  .non_active
                  .order(days_since_checkout: :desc)
  end

  # GET /keyserver/locations
  # Session heatmaps: hour-of-day and day-of-week, per location.
  def locations
    # Group by location so views can render one table per location.
    @by_hour = Keyserver::LocationByHour
                 .order(:location, :hour_of_day)
                 .group_by(&:location)

    @by_dow  = Keyserver::LocationByDow
                 .order(:location, :day_of_week)
                 .group_by(&:location)

    @locations = @by_hour.keys | @by_dow.keys
  end

  # GET /keyserver/by_school
  # Checkout counts per product per school (Alma-derived).
  # Rows with school = nil represent non-pennkey users.
  def by_school
    @rows = Keyserver::SoftwareUsageBySchool
              .order(:product, :school)

    @products = @rows.map(&:product).uniq.sort
    @schools  = @rows.map(&:school).uniq.sort_by { |s| s.nil? ? "" : s }

    # Build a nested hash for pivot rendering: product → school → checkouts
    @pivot = @rows.each_with_object({}) do |row, h|
      h[row.product] ||= {}
      h[row.product][row.school] = row.checkouts
    end
  end

  # GET /keyserver/by_user_group
  # Checkout counts per product per Alma user_group.
  def by_user_group
    @rows = Keyserver::SoftwareUsageByUserGroup
              .order(:product, :user_group)

    @products     = @rows.map(&:product).uniq.sort
    @user_groups  = @rows.map(&:user_group).uniq.sort_by { |g| g.nil? ? "" : g }

    # Build a nested hash: product → user_group → checkouts
    @pivot = @rows.each_with_object({}) do |row, h|
      h[row.product] ||= {}
      h[row.product][row.user_group] = row.checkouts
    end
  end
end
