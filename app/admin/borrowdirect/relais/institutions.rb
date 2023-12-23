ActiveAdmin.register Borrowdirect::Relais::Institution,
as: "Relais::Institution",
namespace: :borrowdirect do
  menu false

  breadcrumb do
    # Custom breadcrumb links
    [
      link_to('BorrowDirect', :borrowdirect_root),
      link_to('Relais', :borrowdirect_relais)
    ]
  end

  permit_params :library_id,
  :library_symbol,
  :institution_name,
  :prime_post_zipcode,
  :weighting_factor

  actions :all, :except => [:new, :edit, :update, :destroy]

  # Set the title on the index page
  index title: "Institution"
end
