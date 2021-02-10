ActiveAdmin.register Report::Attribute do
  extend TableRetrieval
  menu false

  controller do
    def index
      table_names = params[:table_names]
      @table_attributes = TableRetrieval.attributes(table_names)
      respond_to do |format|
        format.json do
          render json: @table_attributes, status: 200
        end
      end
    end
  end
end
