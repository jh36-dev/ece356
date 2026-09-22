---- 1a
SELECT * 
FROM Department 
WHERE location = 'Cairo';

---- 1b
SELECT job, COUNT(job) AS count
FROM Employee
GROUP BY job
ORDER BY job ASC;

/*Two small notes

1. COUNT(job) vs COUNT(*): COUNT(job) skips rows where job is 
NULL, while COUNT(*) counts every row. In each group the job 
value is never NULL (NULL jobs would be grouped separately), 
so the counts match here. The only difference is a possible
NULL group: COUNT(job) would show 0 for it, and COUNT(*) 
would show the real number of people. The lab says "how 
many people are employed in each job type", so COUNT(*) 
is the safer habit, in case the hidden grading data has an
employee with no job.
2. Backticks around count: your version works in MySQL as 
it is. If you ever get a syntax error on that line, writing 
`count` fixes it.*/

---- 1c
SELECT empName, salary
FROM Employee
WHERE job = 'engineer';

----1d
SELECT job, AVG(salary) AS avg_salary
FROM Employee
GROUP BY job

---- 1e
SELECT deptID, count 
    (SELECT deptID, COUNT(job) AS count
    FROM Employee
    GROUP BY deptID
    HAVING job = 'engineer';) AS count_engineers
FROM Employee
WHERE count = MAX(count_engineers.count);

-- Q5 notes:
-- 1. Remove the ; inside the parentheses. Only one ; at the very end.
-- 2. Use WHERE job = 'engineer' (between FROM and GROUP BY), not HAVING job = ...
-- 3. Put the subquery after FROM and give it a nickname, not after SELECT.
-- 4. Don't use MAX(...) in WHERE. Compare totals in HAVING.
-- 5. The outer query can't see "count". It only exists inside the subquery.
-- Shape: SELECT deptID FROM Employee WHERE ... GROUP BY ...
--        HAVING COUNT(*) = (SELECT MAX(...) FROM (...) AS nickname);

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

-- inner query: counts of engineers per department
-- middle query: max of those counts
-- outer query: departments with that max count

---- 1f
SELECT deptID, 100 * COUNT(job)/COUNT(*) AS percentage_engineers
FROM Employee
WHERE job = 'engineer'
GROUP BY deptID
-- this doesn't work because the WHERE clause filters out non-engineers, 
-- so COUNT(*) is the same as COUNT(job) and the percentage is always 100%. 
--We need to count all employees in each department, not just engineers.
SELECT deptID, 100 * SUM(job = 'engineer')/COUNT(*) AS percentage_engineers
FROM Employee
GROUP BY deptID;

---- 1g
SELECT empID, salary
FROM Employee
WHERE salary = MAX(
    SELECT DISTINCT salary
    FROM Employee
    NOT IN (
        SELECT MAX(salary)
        FROM Employee
    )
);

-- can't use MAX for a select
-- can't directly use NOT IN, use WHERE salary NOT IN
-- rememmber to nickname the subquery

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
/*
1. Syntax: NOT IN needs parentheses around a real subquery, 
not a bare table name — WHERE empID NOT IN (SELECT empID 
FROM Assigned), not NOT IN Assigned.

Output columns: just empName and empID, in that order, 
matching the names the question asks for. Expect 3 rows 
on your data: Herr, Morris, Maria.
*/

---- 2b
SELECT e.empName, e.job, a.role
FROM Employee e
JOIN Assigned a ON e.empID = a.empID
WHERE e.job != a.role;

---- 2c
SELECT e.job, COUNT(*) AS count
FROM Employee e
JOIN Assigned a ON e.empID = a.empID
WHERE e.job = a.role
GROUP BY e.job;
--- can also say count(e.job)

---- 2d
SELECT a.projID, sum(e.salary) AS total_salary
FROM Employee e
JOIN Assigned a ON e.empID = a.empID
GROUP BY a.projID;

---- 2e
--- JOIN vs LEFT JOIN
SELECT a.projID, sum(e.salary) AS total_salary
FROM Employee e
LEFT JOIN Assigned a ON e.empID = a.empID
GROUP BY a.projID;

---- 2f
SELECT e.empName, e.empID
FROM Employee e
JOIN Assigned a ON a.empID = e.empID
GROUP BY e.empID, e.empName
HAVING COUNT(*) > 1;

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
