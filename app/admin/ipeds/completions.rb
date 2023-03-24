ActiveAdmin.register_page "Completions", namespace: :ipeds do
  menu false

  content title: "IPEDS Completions Dashboard" do
    render partial: 'completions'
  end
end
