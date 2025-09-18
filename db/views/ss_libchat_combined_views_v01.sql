SELECT 
  c.id AS chat_id,
  c.fiscal_year,
  c.timestamp,
  c.department,
  c.widget,
  c.answerer,
  c.referrer,
  c.wait_time,
  c.duration,
  c.message_count,
  c.initial_question,
  c.transfer_history,
  c.ticket_id,
  c.user_group,
  c.school,
  c.statistical_category_1,
  c.statistical_category_2,
  c.statistical_category_3,
  c.statistical_category_4,
  c.statistical_category_5,
  im.newspaper,
  im.medium,
  im.top_searches,
  im.services,
  im.account_q,
  im.subscription_issues,
  im.type_of_search
FROM ss_libchat_chats c 
LEFT JOIN 
  ss_libchat_inquirymap im 
  ON im.chat_id = c.id