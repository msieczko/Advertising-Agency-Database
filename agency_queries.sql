--Full address information of all employees
SELECT E.first_name || ' ' || E.last_name AS NAME, A.street_address, A.postal_code, A.city, A.country
FROM employee E JOIN address A ON E.address_id = A.ID
ORDER BY E.last_name, E.first_name;


--List employees along with their current assignments
SELECT E.first_name || ' ' || E.last_name AS employee, A.contract_id, T.DESCRIPTION FROM employee E 
JOIN assignment A ON E.pesel = A.employee_pesel
JOIN task T ON A.task_id = T.ID
WHERE A.status = 'in progress'
ORDER BY E.last_name, E.first_name, A.contract_id;


--List emplyees along with the number of their assignemnts - show those who have the lowest number first
SELECT E.first_name || ' ' || E.last_name AS employee, COUNT(E.first_name || ' ' || E.last_name) AS assignments 
FROM assignment A JOIN employee E ON A.employee_pesel = E.pesel
WHERE status = 'in progress' 
GROUP BY E.first_name || ' ' || E.last_name ORDER BY 2;


--List emplyees along with the number of hours of assigned tasks - show those who have the lowest number first
SELECT E.first_name || ' ' || E.last_name AS Employee, SUM(T.estimated_duration) AS Hours FROM task T 
JOIN assignment A ON A.task_id = T.ID
JOIN employee E ON A.employee_pesel = E.pesel
WHERE status = 'in progress'
GROUP BY E.first_name || ' ' || E.last_name
ORDER BY 2;


--Show the number of onging contracts
SELECT COUNT(*) AS ongoing_contracts FROM contract WHERE start_date < sysdate AND end_date > sysdate;


--List ongoing contracts along with client name, contract value, number of tasks involved and number of man-hours required
SELECT C.ID AS Contract, A.NAME AS Client, C.total_value AS Value, x.tasks AS Tasks, y.TIME AS "MAN-HOURS"
FROM contract C 
JOIN client A 
    ON C.client_id = A.ID
JOIN (SELECT contract_id, COUNT(contract_id) AS tasks FROM assignment GROUP BY contract_id) x 
    ON C.ID = x.contract_id
JOIN (SELECT A.contract_id AS ID, SUM(T.estimated_duration) AS time FROM assignment A
        JOIN task T ON A.task_id = T.ID GROUP BY A.contract_id) y
    ON C.ID = y.ID
WHERE C.start_date < sysdate AND C.end_date > sysdate
ORDER BY 1;


