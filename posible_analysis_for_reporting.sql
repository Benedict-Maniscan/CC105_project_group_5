-- COUNTING OVERALL EMPLOYEE 
SELECT COUNT(*) AS total_employees 
FROM employees;

-- COUNTING EMPLOYEE BY DEPARTMENT WITH PERCENTAGE
SELECT d.department_name, 
    COUNT(e.employee_id) AS total_employees, 
    ROUND( COUNT(e.employee_id) * 100.0 / (SELECT COUNT(*) FROM employees), 2 ) AS percentage_of_workforce 
FROM departments d 
JOIN employees e ON d.department_id = e.department_id 
GROUP BY d.department_id, d.department_name 
ORDER BY total_employees DESC;

-- COUNTING EMPLOYEE IN FINANCE DEPARTMENT ONLY
SELECT d.department_name, COUNT(e.employee_id) AS total_employees 
FROM departments d 
JOIN employees e ON d.department_id = e.department_id 
WHERE d.department_name = 'Finance' 
GROUP BY d.department_name;

-- COUNTING THEEMPLOYEE BY EMPLOYMENT STATUS
SELECT employment_status, 
    COUNT(*) AS total_employees, 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 2) AS percentage 
FROM employees 
GROUP BY employment_status 
ORDER BY total_employees DESC;

-- COUNTING THE MIN, MAX, AVG, AND SUM OF THE SALARY AMOUNT
SELECT MIN(salary_amount) AS lowest_salary, 
    MAX(salary_amount) AS highest_salary, 
    ROUND(AVG(salary_amount), 2) AS average_salary, 
    SUM(salary_amount) AS total_monthly_payroll 
FROM employee_salaries;

-- COUNTING THE EMPLOYEE, MIN,MAX, AVG, AND SUM OF EACH DEPARTMENTS
SELECT d.department_name, 
    COUNT(e.employee_id) AS total_employees, 
    MIN(s.salary_amount) AS lowest_salary, 
    MAX(s.salary_amount) AS highest_salary, 
    ROUND(AVG(s.salary_amount), 2) AS average_salary, 
    SUM(s.salary_amount) AS total_payroll 
FROM departments d 
JOIN employees e ON d.department_id = e.department_id 
JOIN employee_salaries s ON e.employee_id = s.employee_id 
GROUP BY d.department_id, d.department_name 
ORDER BY average_salary DESC;

-- COUNTING THE EMPLOYEE AND AVG SALARY FOR EACH POSITION
SELECT p.position_title, 
    COUNT(e.employee_id) AS total_employees, 
    ROUND(AVG(s.salary_amount), 2) AS average_salary 
FROM positions p 
JOIN employees e ON p.position_id = e.position_id 
JOIN employee_salaries s ON e.employee_id = s.employee_id 
GROUP BY p.position_id, p.position_title 
ORDER BY average_salary DESC;

-- LOOKING FOR THE TOP 10 HIGHEST-PAID EMPLOYEES
SELECT e.employee_number, 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name, 
    d.department_name, p.position_title, s.salary_amount 
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
JOIN positions p ON e.position_id = p.position_id 
JOIN employee_salaries s ON e.employee_id = s.employee_id 
ORDER BY s.salary_amount DESC 
LIMIT 10;

-- LOOKING FOR THE TOP 10 LOWEST-PAID EMPLOYEES
SELECT e.employee_number, 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name, 
    d.department_name, p.position_title, s.salary_amount 
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
JOIN positions p ON e.position_id = p.position_id 
JOIN employee_salaries s ON e.employee_id = s.employee_id 
ORDER BY s.salary_amount ASC 
LIMIT 10;

-- LOKING FOR THE MIN, MAX, AND RANGE SALARY
SELECT MIN(salary_amount) AS lowest_salary, 
    MAX(salary_amount) AS highest_salary, 
    MAX(salary_amount) - MIN(salary_amount) AS salary_range 
FROM employee_salaries;

-- LOKING FOR THE COUNT OF ACTIVE EMPLOYEE WITH MIN, MAX, AVG AND SUM OF THE SALARY IN ACTIVE EMPLOYEE
SELECT COUNT(e.employee_id) AS active_employees, 
    MIN(s.salary_amount) AS lowest_salary, 
    MAX(s.salary_amount) AS highest_salary, 
    ROUND(AVG(s.salary_amount), 2) AS average_salary, 
    SUM(s.salary_amount) AS total_payroll 
FROM employees e 
JOIN employee_salaries s ON e.employee_id = s.employee_id 

WHERE e.employment_status = 'Active';

-- COUNTING THE NUMBER OF EMPLOYEES BY DEPARTMENT AND POSITION
SELECT d.department_name, p.position_title, COUNT(e.employee_id) AS total_employees 
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
JOIN positions p ON e.position_id = p.position_id 
GROUP BY d.department_id, d.department_name, p.position_id, p.position_title 
ORDER BY d.department_name, total_employees DESC;

-- COUNTING THE AVERAGE, MIN, MAX, SALARY BY POSITION TITLE AND EMPLOYMENT LEVEL
SELECT p.position_title, p.employment_level, 
    COUNT(e.employee_id) AS total_employees, 
    ROUND(AVG(s.salary_amount), 2) AS average_salary, 
    MIN(s.salary_amount) AS minimum_salary, MAX(s.salary_amount) AS maximum_salary 
FROM positions p 
JOIN employees e ON p.position_id = e.position_id 
JOIN employee_salaries s ON e.employee_id = s.employee_id 
GROUP BY p.position_id, p.position_title, p.employment_level 
ORDER BY average_salary DESC;

-- COUNTING EMPLOYEES BY HIRED YEAR
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS employees_hired 
FROM employees 
GROUP BY YEAR(hire_date) 
ORDER BY hire_year;

-- COUNTING EMPLOYEES BY GENDER WITH PERCENTAGE
SELECT gender, COUNT(*) AS total_employees, ROUND(COUNT(*) * 100.0 / 
(SELECT COUNT(*) FROM employees), 2) AS percentage 
FROM employees 
GROUP BY gender 
ORDER BY total_employees DESC;

-- COUNTING THE DEPARTMENT WITH THE HIGHEST TOTAL PAYROLL
SELECT d.department_name, SUM(s.salary_amount) AS total_payroll 
FROM departments d 
JOIN employees e ON d.department_id = e.department_id 
JOIN employee_salaries s ON e.employee_id = s.employee_id 
GROUP BY d.department_id, d.department_name 
ORDER BY total_payroll DESC 
LIMIT 1;

-- COUNTING THE DEPARTMENTS THAT HAVE ABOVE THE COMPANY AVERAGE SALARY
SELECT d.department_name, 
ROUND(AVG(s.salary_amount), 2) AS department_average_salary 
FROM departments d 
JOIN employees e ON d.department_id = e.department_id 
JOIN employee_salaries s ON e.employee_id = s.employee_id 
GROUP BY d.department_id, d.department_name 
HAVING AVG(s.salary_amount) > (SELECT AVG(salary_amount) 
FROM employee_salaries) 

-- COUNTING THE DEPARTMENTS THAT HEVE BELOW THE COMPANY AVERAGE
SELECT d.department_name, ROUND(AVG(s.salary_amount), 2) AS department_average_salary 
FROM departments d 
JOIN employees e ON d.department_id = e.department_id 
JOIN employee_salaries s ON e.employee_id = s.employee_id 
GROUP BY d.department_id, d.department_name 
HAVING AVG(s.salary_amount) < (SELECT AVG(salary_amount) 
FROM employee_salaries) 
ORDER BY department_average_salary ASC;

-- COUNTING THE TOTAL EMPLOYEES, TOTAL POSITIONS, ACTIVE EMPLOYEES, AVG SALARY LOWEST SALARY, HIGHEST SALARY, AND TOTAL PAYROLL EACH DEPARTMENT
SELECT d.department_name, 
    COUNT(DISTINCT e.employee_id) AS total_employees, 
    COUNT(DISTINCT p.position_id) AS total_positions, 
    COUNT(CASE WHEN e.employment_status = 'Active' THEN 1 END) AS active_employees, 
    ROUND(AVG(s.salary_amount), 2) AS average_salary, 
    MIN(s.salary_amount) AS lowest_salary, 
    MAX(s.salary_amount) AS highest_salary, 
    SUM(s.salary_amount) AS total_payroll 
FROM departments d 
JOIN employees e ON d.department_id = e.department_id 
JOIN positions p ON e.position_id = p.position_id 
JOIN employee_salaries s ON e.employee_id = s.employee_id 
GROUP BY d.department_id, d.department_name 
HAVING COUNT(e.employee_id) >= 50 
ORDER BY total_payroll DESC;

