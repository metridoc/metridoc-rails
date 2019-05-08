module KeyserverHelper
  def display_names_ks_events(event_ids)
    render_ids = []
    event_ids.each do |id, amount|
      render_ids << [Keyserver::EventTerm.find_by(term_id: id).nil? ? "Not supplied" : "#{Keyserver::EventTerm.find_by(term_id: id).term_value} | term_id: (#{id})", amount]
    end
    return render_ids
  end
end
