class Springshare::Libanswers::Ticket < Springshare::Libanswers::Base

  self.ignored_columns = [
    :details, :name, :email, :pennkey, :penn_id
  ]

  # Specify how time intervals should show up
  attribute :time_to_first_reply, :interval
  attribute :time_to_close, :interval

  # Define an alternate name for an id
  # To correct the id named on upload
  def self.alternate_id
    "ticket_id"
  end

  # Define how to handle updates with unique keys
  def self.on_conflict_update 
    {
      conflict_target: [:ticket_id],
      columns: [
        :owner,
        :status,
        :last_updated,
        :tags,
        :interactions,
        :time_to_first_reply,
        :time_to_close
      ]
    }
  end

  # Update count of tickets in queue table if any are destroyed
  after_destroy :update_queue_ticket_count


  def self.update_queue_ticket_count
    # SQL query updates the number of tickets for each queue
    # Ruby on Rails methods called a commit for each entry
    query = <<-SQL
      WITH ticket_counts AS (
        SELECT 
          queue_id, 
          COUNT(*) AS count
        FROM ss_libanswers_tickets
        GROUP BY queue_id
      )
      UPDATE ss_libanswers_queues
      SET 
        number_of_tickets = count,
        last_modified = NOW()
      FROM ticket_counts
      WHERE ss_libanswers_queues.queue_id = ticket_counts.queue_id
    SQL

    # Execute the raw SQL
    ActiveRecord::Base.connection.execute(query)
  end

  def self.update_ticket_demographics
    # SQL query to update demographic information based on email
    # of submitter
    query = <<-SQL
      UPDATE ss_libanswers_tickets
      SET (
        statistical_category_1,
        statistical_category_2,
        statistical_category_3,
        statistical_category_4,
        statistical_category_5,
        user_group,
        school,
        penn_id,
        pennkey
      ) = (
        upenn_alma_demographics.statistical_category_1,
        upenn_alma_demographics.statistical_category_2,
        upenn_alma_demographics.statistical_category_3,
        upenn_alma_demographics.statistical_category_4,
        upenn_alma_demographics.statistical_category_5,
        COALESCE(upenn_alma_demographics.user_group, 'Unknown'),
        COALESCE(upenn_alma_demographics.school, 'Unknown'),
        upenn_alma_demographics.penn_id,
        upenn_alma_demographics.pennkey
      )
      FROM upenn_alma_demographics
      WHERE
        ss_libanswers_tickets.pennkey IS NULL
        AND ss_libanswers_tickets.email LIKE '%upenn%'
        AND upenn_alma_demographics.pennkey = 
          SPLIT_PART(ss_libanswers_tickets.email, '@', '1')
    SQL

    # Execute the raw SQL
    ActiveRecord::Base.connection.execute(query)
  end

  # Function to auto update tables after upload via file import tool
  def self.update_after_import

    self.update_queue_ticket_count
    self.update_ticket_demographics

  end
end
