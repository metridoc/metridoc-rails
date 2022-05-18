ActiveAdmin.register UpennAlma::Demographic do
  menu false
  permit_params :identifier_value,
    :status,
    :status_date,
    :statistical_category_1,
    :statistical_category_2,
    :statistical_category_3,
    :statistical_category_4,
    :statistical_category_5,
    :school
end
