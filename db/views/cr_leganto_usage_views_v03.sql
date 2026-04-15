SELECT
  lu.id,
  lu.event_date,
  lc.course_year,
  lc.course_term,
  lc.academic_department,
  lc.course_code,
  lc.course_name,
  lc.course_enrollment,
  lu.course_id,
  lu.reading_list_id,
  lu.citation_id,
  COALESCE(
    NULLIF(
      COALESCE(
        NULLIF(lci.title, ''),
        lci.book_chapter_title
      ), ''
    ),
    lci.journal_title
  )
    AS title,
  lci.author,
  lu.user_role,
  lu.files_downloaded,
  lu.file_views,
  lu.full_text_views,
  lu.total_views,
  lc.processing_department
FROM cr_leganto_usage lu
LEFT JOIN cr_leganto_courses lc
  ON lu.course_id = lc.course_id
LEFT JOIN cr_leganto_citations lci
  ON lu.citation_id = lci.citation_id
WHERE lu.total_views <> 0
AND lc.course_id <> '7988545480003681'