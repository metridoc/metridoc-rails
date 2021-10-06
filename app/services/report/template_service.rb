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

  end
end
