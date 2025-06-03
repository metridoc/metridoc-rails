module Report
  class TemplateService

    def self.save_query_as_template(query:)
      template = Report::Template.new(
        name: query.name,
        comments: query.comments,
        select_section: query.select_section,
        from_section: query.from_section,
        where_section: query.where_section,
        group_by_section: query.group_by_section,
        order_section: query.order_section,
        order_direction_section: query.order_direction_section,
        full_sql: query.full_sql,
      )
      query.report_query_join_clauses.each do |eport_query_join_clause|
        template.report_template_join_clauses.build(
          keyword: report_query_join_clause.keyword,
          table: report_query_join_clause.table,
          on_keys: report_query_join_clause.on_keys,
        )
      end

      template.save
      template
    end

    def self.run_template_as_query(template:, owner:)
      query = get_matching_query(template: template, owner: owner)
      if query
        query.re_process
        return query
      end

      query = Report::Query.new(
        report_template_id: template.id,
        owner_id: owner.id,
        name: template.name,
        comments: template.comments,
        select_section: template.select_section,
        from_section: template.from_section,
        where_section: template.where_section,
        group_by_section: template.group_by_section,
        order_section: template.order_section,
        order_direction_section: template.order_direction_section,
        full_sql: template.full_sql,
      )
      template.report_template_join_clauses.each do |join_clause|
        query.report_query_join_clauses.build(
          keyword: join_clause.keyword,
          table: join_clause.table,
          on_keys: join_clause.on_keys,
        )
      end

      query.save
      query
    end
  
    private
    def self.get_matching_query(template:, owner:)
      Report::Query.find_by(
        report_template: template,
        owner: owner,
      )
    end
  end
end
