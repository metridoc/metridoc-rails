class Springshare::Libchat::Chat < Springshare::Libchat::Base

  # Define relation to InquiryMap
  has_one :inquiry_map, 
    class_name: "Springshare::Inquirymap::Inquirymap"

  # For URL Parsing
  require 'uri'

  # Define the SuperAdmin columns
  def self.superadmin_columns
    [
      "name", "contact_info", 
      "user_field_1", "user_field_2", "user_field_3", 
      "initial_question", "internal_note", "transcript",
      "penn_id", "pennkey"
    ]
  end

  # Define an alternate name for an id
  # To correct the id named on upload
  def self.alternate_id
    "chat_id"
  end

  def self.on_conflict_update
    {
      conflict_target: [:chat_id],
      columns: [
        :duration,
        :answerer,
        :timestamp,
        :transfer_history,
        :ticket_id
      ]
    }
  end

  # Extract additional columns for each chat record.
  def self.calculate_chat_columns
    self.where(pennkey: nil)
    .each do |row|
      # Extract the fiscal year from the timestamp
      unless row.timestamp.nil?
        row.fiscal_year = (row.timestamp + 6.months).year
      end

      # Extract the referrer URL Host
      unless row.referrer.empty?
        # Remove the query part of the string, it can contain non-ASCII characters
        row.referrer_basename = URI.parse(
          row.referrer.split("?").first 
        ).host
      end

      # Extract the pennkey
      if row.contact_info.include?("upenn") && row.contact_info.include?("@")
        row.pennkey = row.contact_info.split('@').first
      elsif row.name.include?("upenn") && row.name.include?("@")
        row.pennkey = row.name.split('@').first
      elsif row.user_field_1.start_with?("Email (PennKey Preferred):")
        row.pennkey = row.user_field_1.split(': ').last.split('@').first
      else
        # Default set the pennkey to anonymous so we don't 
        # keep going over the same records
        row.pennkey = "anonymous"
      end

      # Save the record
      row.save
    end
  end

  # Set the display name for the chat
  def self.update_chat_display_name
    # SQL query to set the display name
    query = <<-SQL
      UPDATE ss_libchat_chats
      SET display_name = chat_id
      WHERE display_name IS NULL
    SQL

    # Execute the raw SQL
    ActiveRecord::Base.connection.execute(query)
  end
  
  # Fill in the remaining demographic information
  def self.update_chat_demographics
    # SQL query to update demographic information based on potential pennkey
    query = <<-SQL
      UPDATE ss_libchat_chats
      SET (
        statistical_category_1,
        statistical_category_2,
        statistical_category_3,
        statistical_category_4,
        statistical_category_5,
        user_group,
        school,
        penn_id
      ) = (
        upenn_alma_demographics.statistical_category_1,
        upenn_alma_demographics.statistical_category_2,
        upenn_alma_demographics.statistical_category_3,
        upenn_alma_demographics.statistical_category_4,
        upenn_alma_demographics.statistical_category_5,
        COALESCE(upenn_alma_demographics.user_group, 'Unknown'),
        COALESCE(upenn_alma_demographics.school, 'Unknown'),
        upenn_alma_demographics.penn_id
      )
      FROM upenn_alma_demographics
      WHERE
        ss_libchat_chats.penn_id IS NULL
        AND NOT ss_libchat_chats.pennkey = 'anonymous'
        AND ss_libchat_chats.pennkey = upenn_alma_demographics.pennkey
    SQL

    # Execute the raw SQL
    ActiveRecord::Base.connection.execute(query)
  end
  
  # Case statement to derive the user type from the 
  # initial question and the transcript
  def self.find_user_type(initial_question, transcript)
    initial_question.downcase!
    transcript.downcase!
    case
    when (initial_question+transcript).include?("visitor") then "Visitor"
    when (initial_question+transcript).include?("alum") then "Alumni"
    when initial_question.include?("student") then "Student"
    when ["faculty", "staff", "prof"].any? { 
      |s| initial_question.include?(s)
      } then "Faculty"
    else "Unknown"
    end
  end

  # Search initial question for reference to newspapers
  def self.find_newspaper_flag(initial_question)
    ["news", "nyt", "new york times", "philadelphia inquirer"].any? {
      |s| initial_question.downcase.include?(s)
    } ? 1 : 0
  end

  # Find the medium of the item the request is about
  def self.find_medium(initial_question)
    initial_question.downcase!
    case
    when initial_question.include?("book") then 1
    when ["article", "journal"].any? {
      |s| initial_question.include?(s)
    } then 2
    when initial_question.include?("music") then 3
    when initial_question.include?("microfilm") then 4
    when ["film", "movie"].any? {
      |s| initial_question.include?(s)
    } then 5
    else 0
    end
  end

  # Find what common searches people are doing?
  def self.find_top_searches(initial_question)
    initial_question.downcase!
    case 
    when ["poster", "print"].any? {
      |s| initial_question.include?(s)
    } then 1
    when ["cite", "citation"].any? {
      |s| initial_question.include?(s)
    } then 2
    else 0
    end
  end

  # Extract the types of services patrons are asking about
  def self.find_services(initial_question)
    case
    when ["interlibrary loan", "illiad"].any? {
      |s| initial_question.downcase.include?(s)
    } then 1
    when initial_question.include?("ILL") then 1
    when ["franklin", "library website", "catalog"].any? {
      |s| initial_question.downcase.include?(s)
    } then 2
    when initial_question.include?("FIND") then 2
    else 0
    end
  end

  # Define what the account question is about
  def self.find_account_question(initial_question)
    initial_question.downcase!
    case
    when ['account', 'pennkey'].any? {
      |s| initial_question.include?(s)
    } then 1
    when ['fine', 'renew', 'overdue', 'fee'].any? {
      |s| initial_question.include?(s)
    } then 2
    when ['equipment', 'laptop', 'camera', 'monitor', 'speaker'].any? {
      |s| initial_question.include?(s)
    } then 4
    when ['physical', 'check out', 'return', 'pick up', 'borrow', 'rent'].any? {
      |s| initial_question.include?(s)
    } then 3
    else 0
    end
  end

  # Extract any subscription issues
  def self.find_subscription_issues(initial_question)
    initial_question.downcase!
    case
    when initial_question.include?("subscription") then 1
    when initial_question.include?("access") then 2
    when ['log in', 'logged in', 'sign in', 'signed in'].any? {
      |s| initial_question.include?(s)
    } then 3
    else 0
    end
  end

  # Extract the type of research a patron is doing
  def self.find_type_of_search(initial_question)
    initial_question.downcase!
    case
    when ['class', 'course'].any? {
      |s| initial_question.include?(s)
    } then 2
    when initial_question.include?("librarian") then 3
    when ['dissertation', 'thesis'].any? {
      |s| initial_question.include?(s)
    } then 4
    when ['database', 'software'].any? {
      |s| initial_question.include?(s)
    } then 5
    when ['local', 'community', 'philadelphia', 'philly'].any? {
      |s| initial_question.include?(s)
    } then 7
    when initial_question.include?("research") then 1
    when ['find', 'search'].any? {
      |s| initial_question.include?(s)
    } then 6
    else 0
    end
  end

  # Take in a transcript and the answerer of the chat
  # Manipulate transcript to evaluate the sentiment of the 
  # patron.
  def self.calculate_transcript_sentiment(transcript, answerer)
    return 0, "Neutral" if transcript.empty?

    # Separate out the lines of the transcript
    line_sentiment = transcript.split("\n")
    .select{
      # Filter out librarian responses
      |line| !line.include?(answerer)
    }.map {
      # Remove the timestamp and user's name
      |line| line.split(": ", 2).last
    }.select{
      # Remove any empty lines after preprocessing
      |line| !line.blank?
    }.map {
      # Process the sentiment for each line
      |line| VaderSentimentRuby.polarity_scores(line)[:compound]
    }

    # Find the average of each line of sentiment
    average_sentiment = if line_sentiment.empty? then 0 
    else line_sentiment.sum.fdiv(line_sentiment.length) 
    end

    # Classify the sentiment into levels
    sentiment = case
      when average_sentiment <= -0.05 then "Negative"
      when average_sentiment < 0.05 then "Neutral"
      when average_sentiment < 0.3 then "Positive"
      else "Ecstatic"
    end

    # Return both the average sentiment and 
    # the sentiment classification
    return average_sentiment, sentiment
  end

  # Pull new chat ids and process the transcripts 
  # through inquiry map
  def self.create_inquiry_map
    maps = []
    # Find all chats that have not been processed into Inquiry Map
    self.where.missing(:inquiry_map).each do |row|

      # Run the Sentiment Analysis
      sentiment_score, sentiment = self.calculate_transcript_sentiment(
        row.transcript, row.answerer
      )

      inquiry_map = {
        user_type: self.find_user_type(row.initial_question, row.transcript),
        newspaper: self.find_newspaper_flag(row.initial_question),
        medium: self.find_medium(row.initial_question),
        top_searches: self.find_top_searches(row.initial_question),
        services: self.find_services(row.initial_question),
        account_q: self.find_account_question(row.initial_question),
        subscription_issues: self.find_subscription_issues(row.initial_question),
        type_of_search: self.find_type_of_search(row.initial_question),
        sentiment_score: sentiment_score,
        sentiment: sentiment,
        chat: row
      }

      # Create a new instance of InquiryMap for each chat
      maps << Springshare::Inquirymap::Inquirymap.new(inquiry_map)
    end

    # Import in bulk
    Springshare::Inquirymap::Inquirymap.import maps, batch_size: 500
  end
  
  # Function to auto update tables after upload via file import tool
  def self.update_after_import

    # Update the display name to be the chat id
    self.update_chat_display_name

    # Update the chat table with extra information
    self.calculate_chat_columns
    self.update_chat_demographics

    # Create records for the inquiry map table
    self.create_inquiry_map

  end

end