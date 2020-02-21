class Sceti::Project < Sceti::Base
    has_many :tracking

    default_scope { order(name: :asc) }
end
