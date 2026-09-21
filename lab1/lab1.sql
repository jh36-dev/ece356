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
/*
Delete this block comment and place your answer to 2a here.
*/


---- 2e
/*
Delete this block comment and place your answer to 2e here.
*/


---- 3a
/*
Delete this block comment and place your answer to 3a here.
*/


---- 3b
/*
Delete this block comment and place your answer to 3b here.
*/


---- 3c
/*
Delete this block comment and place your answer to 3c here.
*/


---- 3d
/*
Delete this block comment and place your answer to 3d here.
*/
