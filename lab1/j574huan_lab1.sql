---- 1b
SELECT job, COUNT(job) AS count
FROM Employee
GROUP BY job
ORDER BY job ASC;


---- 1e
SELECT deptID 
FROM Employee
WHERE job = 'engineer'
GROUP BY deptID
HAVING COUNT(*) = (
    SELECT MAX(count)
    FROM (
        SELECT deptID, COUNT(job) AS count
        FROM Employee
        WHERE job = 'engineer'
        GROUP BY deptID
    ) AS count_engineers
);


---- 1g
SELECT empID, salary
FROM Employee
WHERE salary = (
    SELECT MAX(salary)
    FROM
    (
        SELECT DISTINCT salary
        FROM Employee
        WHERE salary NOT IN (
            SELECT MAX(salary)
            FROM Employee
        )
    ) AS second_highest_salaries
);


---- 2a
SELECT empName, empID
FROM Employee
WHERE empID NOT IN (
    SELECT empID
    FROM Assigned
);


---- 2e
SELECT a.projID, sum(e.salary) AS total_salary
FROM Employee e
LEFT JOIN Assigned a ON e.empID = a.empID
GROUP BY a.projID;


---- 3a
UPDATE Employee
SET salary = salary * 1.10
WHERE empID IN (
    SELECT a.empID
    FROM Assigned a
    JOIN Project p ON a.projID = p.projID
    WHERE p.title = 'compiler'
);

---- 3b
UPDATE Employee e
JOIN Department d ON e.deptID = d.deptID
SET e.salary = e.salary * CASE
    WHEN d.location = 'Waterloo' THEN 1.08
    WHEN e.job = 'janitor' THEN 1.05
    ELSE 1.00
END;


---- 3c
ALTER TABLE Employee
ADD COLUMN shift VARCHAR(5);


---- 3d
UPDATE Employee e
SET shift = CASE
    WHEN empID NOT IN (
        SELECT empID
        FROM Assigned
    ) THEN 'N.A.'
    WHEN e.empID % 2 = 0 THEN 'day'
    ELSE 'night'
END;
