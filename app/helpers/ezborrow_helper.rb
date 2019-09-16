module EzborrowHelper
  def display_names_ezb(institution_ids)
    render_ids = []
    institution_ids.each do |id, amount|
      render_ids << [Ezborrow::Institution.find_by(library_id: id).nil? ? "Not supplied" : "#{Ezborrow::Institution.find_by(library_id: id).institution_name} (#{id})", amount]
    end
    return render_ids
  end
end