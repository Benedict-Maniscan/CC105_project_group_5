-- <<< SELECT & FIlTERING >>>

-- Select all columns
SELECT * FROM employees;

-- Select specific columns
SELECT first_name, middle_name, last_name, gender, birth_date FROM employees;

-- Column aliases
SELECT first_name AS Name, email As contact, birth_date AS birthday FROM employees;
SELECT COUNT(*) AS Total_users FROM employees;

-- DISTINCT — remove duplicates
SELECT DISTINCT salary_amount FROM employee_salaries;
SELECT DISTINCT salary_amount, salary_type FROM employee_salaries;

-- WHERE clause operators
SELECT * FROM employee_salaries WHERE salary_amount >= 50000;
SELECT * FROM employee_salaries WHERE salary_amount >= 50000 AND effective_date = '2019-01-17';
SELECT * FROM employee_salaries WHERE salary_amount = '22500' OR effective_date = '2019-01-17';
SELECT * FROM employee_salaries WHERE NOT effective_date = '2019-01-17';

-- IN — match against a list
SELECT * from positions WHERE employment_level IN ('Entry level', 'Mid level', 'Senior level', 'Manager');

-- BETWEEN — range (inclusive)
SELECT * FROM employees WHERE employee_id BETWEEN 1 AND 25;
SELECT * FROM employees WHERE hire_date BETWEEN '2018-01-01' AND '2024-12-30';

-- ORDER BY — sorting
SELECT * FROM employees ORDER BY first_name ASC;          -- Ascending (default)
SELECT * FROM employees ORDER BY hire_date DESC;           -- Descending
SELECT * FROM employees ORDER BY employee_id ASC, first_name ASC; -- Multi-column

-- LIMIT / TOP / FETCH
SELECT * FROM employees LIMIT 10;                    -- MySQL, PostgreSQL
SELECT * FROM employees LIMIT 10 OFFSET 20;          -- Skip 20, take 10

-- Comments
-- Single line comment
/* Multi-line
   comment */
   
-- % — matches zero or more characters
SELECT * FROM employees WHERE first_name LIKE 'J%';          -- John, Jane, Jim
SELECT * FROM employees WHERE middle_name LIKE '%mos';       -- Johnson, Wilson
SELECT * FROM employees WHERE email LIKE '%@company.com';	 -- Gmail users
SELECT * FROM employees WHERE last_name LIKE '%vill%';       -- Contains "vill"

-- _ — matches exactly one character
SELECT * FROM employees WHERE first_name LIKE '_ohn';       -- John, but not Johnson
SELECT * FROM employees WHERE last_name LIKE 'V__';         -- A followed by 2 chars -- note: working but no data
SELECT * FROM employees WHERE phone LIKE '___-___-____';		-- note: working but no data

-- Combine wildcards
SELECT * FROM employees WHERE first_name LIKE 'PRD-__-%';	-- note: working but no data

-- NOT LIKE
SELECT * FROM employees WHERE first_name NOT LIKE '%test%';


-- <<< DATA MODIFICATION >>> 

-- INSERT single row
INSERT INTO employees (employee_id, employee_number, first_name, middle_name, last_name, gender, birth_date, email, phone, hire_date)
VALUES ('10001', 'EM10001', 'Dela', 'Santos', 'Cruz', 'female', '20006-07-13', 'delacruz@gmail.com', '09612345542', '2026-01-01');

-- INSERT multiple rows
IVALUES ('10001', 'EM10001', 'Dela', 'Santos', 'Cruz', 'female', '20006-07-13', 'delacruz@gmail.com', '09612345542', '2026-01-01'),
		  ('10001', 'EM10001', 'Dela', 'Santos', 'Cruz', 'female', '20006-07-13', 'delacruz@gmail.com', '09612345542', '2026-01-01'),
		  ('10001', 'EM10001', 'Dela', 'Santos', 'Cruz', 'female', '20006-07-13', 'delacruz@gmail.com', '09612345542', '2026-01-01');

-- INSERT from another table
INSERT INTO employees (first_name, email)
SELECT first_name, email FROM employees WHERE employment_status = 'On Leave';

-- UPDATE single column
UPDATE employees SET first_name = 'Anna' WHERE employee_id = 1000;

-- UPDATE multiple columns
UPDATE employees SET first_name = 'Anna', middle_name = 'Reyes' WHERE employee_id = 1000;

-- UPDATE with subquery
UPDATE employee_salaries SET salary_amount = salary_amount * 12						-- NOTE NOT TESTED YET
WHERE salary_id IN (SELECT salary_id FROM categories WHERE name = 'Premium');

-- DELETE specific rows
DELETE FROM employees WHERE employee_id = 5;

-- DELETE with condition
DELETE FROM employees WHERE employment_status = 'Inactive' AND hire_date < '2018-01-01';

-- DELETE all rows (keeps table structure)
DELETE FROM employees;
-- or faster (no rollback):
TRUNCATE TABLE employees;


-- <<< JOIN >>>

-- INNER JOIN — only matching rows
SELECT e.first_name, e.middle_name, e.last_name, e.birth_date, d.department_name, d.location
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- LEFT JOIN — all left rows, NULL for unmatched right
SELECT e.first_name, e.middle_name, e.last_name, e.birth_date, d.department_name, d.location
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;
-- Users with no orders get NULL for o.total

-- RIGHT JOIN — all right rows, NULL for unmatched left
SELECT e.first_name, e.middle_name, e.last_name, e.birth_date, d.department_name, d.location
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- CROSS JOIN — cartesian product (every combination)
SELECT e.first_name, e.middle_name, e.last_name, e.birth_date, departments.department_name, departments.location
FROM employees e
CROSS JOIN departments;

-- SELF JOIN — join a table to itself
SELECT e.first_name AS employee, p.employment_level AS manager
FROM employees e
LEFT JOIN positions p ON e.position_id = p.position_id;

-- Multiple joins
SELECT e.first_name, e.middle_name, e.last_name, p.position_title, p.employment_level, s.salary_amount, s.effective_date
FROM employees e
JOIN positions p ON e.position_id = p.position_id
JOIN employee_salaries s ON e.employee_id = s.employee_id;

-- Join with additional conditions
SELECT u.name, o.total
FROM users u
JOIN orders o ON u.id = o.user_id AND o.status = 'completed';


-- <<< AGRREGATION >>>

-- Aggregate functions
SELECT COUNT(*) FROM employees;                			-- Count all rows
SELECT COUNT(DISTINCT employee_id) FROM employees;    -- Count unique values
SELECT COUNT(email) FROM employees;            			-- Count non-NULL values
SELECT SUM(salary_amount) FROM employee_salaries;
SELECT AVG(salary_amount) FROM employee_salaries;
SELECT MIN(salary_amount), MAX(salary_amount) FROM employee_salaries;

-- GROUP BY — group rows and aggregate
SELECT gender, COUNT(*) AS user_account
FROM employees
GROUP BY gender;

-- GROUP BY multiple columns
SELECT department_name, location, COUNT(*) AS count_of_departmentname_by_location
FROM departments
GROUP BY department_name, location;

-- GROUP BY with aggregate expressions
SELECT
  salary_amount,
  COUNT(*) AS total_amount,
  AVG(salary_amount) AS avg_salary,
  SUM(salary_amount) AS total_salary,
  MIN(salary_amount) AS low_salary,
  MAX(salary_amount) AS high_salary
FROM employee_salaries
GROUP BY salary_amount;

-- HAVING — filter after grouping (WHERE filters before)
SELECT gender, COUNT(*) AS count_of_male_and_female
FROM employees
GROUP BY gender
HAVING COUNT(*) > 10;

-- HAVING with multiple conditions
SELECT salary_amount, AVG(salary_amount) AS avg_amount
FROM employee_salaries
GROUP BY salary_amount
HAVING AVG(salary_amount) > 50 AND COUNT(*) > 5;

-- WHERE + GROUP BY + HAVING together
SELECT employment_status, COUNT(*) AS active_users
FROM employees
WHERE employment_status = 'Active'        -- Filter rows first
GROUP BY gender                  			-- Then group
HAVING COUNT(*) > 5            				-- Then filter groups
ORDER BY active_users DESC;    				-- Then sort


-- <<< SAMPLE JOIN >>> --
   
SELECT *
FROM employees
JOIN departments ON employees.department_id = departments.department_id
JOIN positions  ON employees.position_id = positions.position_id
JOIN employee_salaries  ON employees.employee_id = employee_salaries.employee_id
ORDER BY employee_number
LIMIT 10;

SELECT employee_number, first_name, middle_name, last_name, department_name, location, position_title, employment_level, base_salary, salary_amount, effective_date
FROM employees
JOIN departments ON employees.department_id = departments.department_id
JOIN positions  ON employees.position_id = positions.position_id
JOIN employee_salaries  ON employees.employee_id = employee_salaries.employee_id
ORDER BY employee_number DESC;