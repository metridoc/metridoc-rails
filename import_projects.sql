INSERT INTO sceti_projects(name, active)
	SELECT Project AS name, 1 AS active
	FROM scetisample 
	WHERE Project IS NOT NULL AND Project <> ''
	ORDER BY Project
