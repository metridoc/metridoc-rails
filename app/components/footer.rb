class Footer < ActiveAdmin::Component

  def build(namespace)
    super :id => "footer"

    div :id => "footer_content" do
      render 'admin/parts/footer'
    end
  end

end