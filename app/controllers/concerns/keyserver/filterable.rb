module Keyserver
  module Filterable
    extend ActiveSupport::Concern

    included do
      helper_method :filtered_scope
    end

    private

    def setup_date_range(model)
      @min_date   = model.minimum(:start_time)&.to_date
      @max_date   = model.maximum(:start_time)&.to_date
      @start_date = params[:start_date].presence&.to_date || @min_date
      @end_date   = params[:end_date].presence&.to_date   || @max_date

      setup_filter_options
    end

    def setup_filter_options
      @user_groups  = REVERSE_USER_GROUP_MAP.keys
      @affiliations = REVERSE_SCHOOL_MAP.keys
    end

    def setup_division_list
      @divisions = Keyserver::Computer.distinct.order(:division).pluck(:division)
    end

    def setup_product_list
      @products = Keyserver::Product.distinct.order(:product_name).pluck(:product_name)
    end

    def setup_program_list
      @programs = Keyserver::ProgramUsage.distinct.order(:program_name).pluck(:program_name)
    end

    def filtered_scope(model)
      scope = model.where(start_time: @start_date..@end_date)
      
      if params[:division].presence && @divisions&.include?(params[:division])
        scope = scope.where(division: params[:division])
      end

      if (mapped = REVERSE_USER_GROUP_MAP[params[:user_group].presence]) 
        scope = scope.where(user_group: mapped)
      end
      
      if (mapped = REVERSE_SCHOOL_MAP[params[:school].presence]) 
        scope = scope.where(school: mapped)
      end

      if params[:product_name].presence && @products&.include?(params[:product_name])
        scope = scope.where(product_name: params[:product_name])
      end

      if params[:program_name].presence && @programs&.include?(params[:program_name])
        scope = scope.where(program_name: params[:program_name])
      end
      
      scope
    end

    def filtered_occupancy_scope
      scope = Keyserver::Occupancy.where(date: @start_date..@end_date)

      if params[:division].presence && @divisions&.include?(params[:division])
        scope = scope.where(division: params[:division]) if params[:division].presence    
      end
      
      scope
    end
    
  end
end
