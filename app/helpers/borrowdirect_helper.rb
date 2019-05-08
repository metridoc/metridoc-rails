module BorrowdirectHelper
  def display_names_bd(institution_ids)
    render_ids = []
    institution_ids.each do |id, amount|
      render_ids << [Borrowdirect::Institution.find_by(library_id: id).nil? ? "Not supplied" : "#{Borrowdirect::Institution.find_by(library_id: id).institution_name} (#{id})", amount]
    end
    return render_ids
  end
end