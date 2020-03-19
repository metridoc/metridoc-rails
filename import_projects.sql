INSERT INTO sceti_projects(name, active)
	SELECT DISTINCT project AS name, true AS active
	FROM scetisample 
	WHERE project IS NOT NULL AND project <> ''
	ORDER BY project
