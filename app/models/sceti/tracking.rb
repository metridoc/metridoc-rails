class Sceti::Tracking < Sceti::Base
    belongs_to :project, foreign_key: :sceti_project_id
end
