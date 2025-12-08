ActiveAdmin.register Caiasoft::CirculationMetric,
  namespace: :caiasoft do
    menu false

    breadcrumb do
      [
        link_to('Caiasoft', :caiasoft_root)
      ]
    end

    actions :all, :except => [:new, :edit, :update, :destroy]

    index title: "Circulation Metric"
  end
