module IlliadHelper
  def display_names_ill(institution_ids)
    render_ids = {}
    institution_ids.each do |id, amount|
      render_ids[Institution.find_by(id: id).nil? ? "Not supplied" : Institution.find_by(id: id).name] = amount
    end
    return render_ids
  end
end