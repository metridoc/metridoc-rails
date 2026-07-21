module KeyserverHelper
  # Formats a microsecond duration (Keyserver::Session#duration) as a compact,
  # human-readable string, e.g. 148_959_000_000 => "1d 17h 22m",
  # 1_088_000_000 => "18m 8s", 0 => "0s". Sub-second remainders are dropped.
  # Returns nil for blank input so table cells render empty rather than "0s".
  def humanized_duration(microseconds)
    return if microseconds.blank?

    secs = microseconds.to_i / 1_000_000
    return "0s" if secs.zero?

    sign = secs.negative? ? "-" : ""
    days, rem     = secs.abs.divmod(86_400)
    hours, rem    = rem.divmod(3_600)
    minutes, secs = rem.divmod(60)

    parts = []
    parts << "#{days}d"    if days.positive?
    parts << "#{hours}h"   if hours.positive?
    parts << "#{minutes}m" if minutes.positive?
    # Only bother with seconds for short (sub-day) durations.
    parts << "#{secs}s"    if secs.positive? && days.zero?

    "#{sign}#{parts.join(' ')}"
  end
end
