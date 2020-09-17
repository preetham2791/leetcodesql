175.

SELECT Person.FirstName, Person.LastName, Address.City, Address.State
from Person
LEFT OUTER JOIN Address
ON Person.PersonId = Address.PersonId


176. 

SELECT (SELECT DISTINCT Salary 
from Employee
ORDER BY SALARY DESC
LIMIT 1 OFFSET 1) as SecondHighestSalary;


177.

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    RETURN
    (
        select E.Salary
        from Employee E
        CROSS JOIN Employee F
        WHERE E.SALARY <= F.SALARY
        GROUP BY E.SALARY
        HAVING COUNT(DISTINCT F.SALARY) = N
    );
END


178.

SELECT Score,
DENSE_RANK() OVER (ORDER BY Score DESC) AS 'Rank'
FROM Scores


180.

SELECT distinct l1.num as ConsecutiveNums
from Logs l1, Logs l2, Logs l3
where l1.id = l2.id-1 and l2.id = l3.id-1 and l1.num = l2.num and l2.num = l3.num


181.

SELECT e1.Name as Employee
from employee e1
JOIN employee e2
ON e1.ManagerId = e2.Id
WHERE e1.Salary > e2.Salary


182.

SELECT Email
from Person
GROUP BY Email
HAVING count(email) > 1


183.

SELECT Name as Customers
from Customers
WHERE Customers.Id not in
(SELECT CustomerId from Orders)


184.

SELECT D.Name as Department, E.Name as Employee, E.Salary
from Employee E
JOIN Department D
on E.DepartmentId = D.Id
WHERE
(E.DepartmentId, E.Salary) IN
    (
SELECT DepartmentId, MAX(SALARY)
from Employee
GROUP BY DepartmentId
    );


185.

SELECT D.name as Department, E.name as Employee, E.Salary as Salary
from Employee E
INNER JOIN Department D
on (E.DepartmentId = D.Id)
where > 3 (
SELECT COUNT (DISTINCT F.Salary)
FROM Employee F
WHERE F.DepartmentId = E.DepartmentId and
		F.Salary > E.Salary
)


196.

DELETE P1
FROM Person P1, Person P2
where P1.Email = P2.Email AND P1.Id > P2.Id


197.

SELECT Weather.Id
from Weather
JOIN Weather w 
on DATEDIFF(weather.recordDate, w.recordDate) = 1 AND
Weather.Temperature > w.Temperature;


262.

select Request_at as Day,
ROUND(SUM(CASE
          WHEN Status = "cancelled_by_driver" then 1
          WHEN Status = "cancelled_by_client" then 1
          ELSE 0
END)/COUNT(*),2) as 'Cancellation Rate'
from Trips
where
Request_at between "2013-10-01" and "2013-10-03" and
Client_Id NOT IN (SELECT Users_Id from Users where Banned="Yes") and
Driver_Id NOT IN (SELECT Users_Id from Users where Banned="Yes")
group by request_at


569.

select
    id, 
    company, 
    salary 
from 
    (
        select
            id, 
            company, 
            salary, 
            @rownum := @rownum + 1 row_number 
        from
            employee, 
            (
                select
                    @rownum :=0
            ) init
        order by company, salary) c
where
    c.row_number in (
        select
            max(row_number) - floor(count(row_number)/2) row_number
        from
            (
                select
                    id, 
                    company,
                    salary, 
                    @rownum1 := @rownum1 + 1 row_number 
                from
                    employee, 
                    (
                        select
                            @rownum1 :=0
                    ) init 
                order by company, salary) employees_ordered
group by company
union
select
    min(row_number) + floor(count(row_number)/2) row_number 
from
    (
        select
            id, 
            company, 
            salary, 
            @rownum2 := @rownum2 + 1 row_number 
        from
            employee, 
            (
                select
                    @rownum2 :=0
            ) init 
        order by company, salary) employees_ordered 
group by company);


570.

select
    a.name
from
    employee a 
inner join
    employee b 
on (a.id = b.managerid) 
group by a.name
having count(distinct b.id) >= 5


571.

SELECT AVG(Number) as Median
from numbers n
where n.frequency >= ABS(
(SELECT SUM(FREQUENCY) FROM Numbers where number<=n.number) - (SELECT SUM(FREQUENCY) FROM Numbers where number>=n.number)
) 


574.

select
    a.name
from
    candidate a 
inner join (
    select
        candidateid, count(*) no_of_votes 
    from
        vote 
    group by
        candidateid 
    order by
        no_of_votes desc
    limit 1) b
on a.id = b.candidateid


577.

select
    a.name,
    b.bonus 
from
    employee a 
left outer join
    bonus b 
on (a.empid = b.empid)
where ifnull(bonus,-1) < 1000


578.

select
    c.question_id survey_log 
from
    (
        select
            a.question_id,
            count(distinct a.question_id) count
        from
            survey_log a 
        group by a.question_id) c
left outer join
    (
        select
            b.question_id, 
            count(*) count
        from
            survey_log b 
        where b.action = 'answer'
        group by b.question_id) d
on (c.question_id = d.question_id)
order by (coalesce(d.count,0) / c.count) desc
limit 1


579.

SELECT
    e1.id, 
    e1.month,  
    (select sum(e2.salary) from employee e2 where e2.id = e1.id and e2.month >= e1.month-2 and e2.month <= e1.month group by e2.id) "Salary"
from
    employee e1 
where
    e1.month not in (select max(e3.month) from employee e3 where e3.id = e1.id)
group by e1.id, e1.month
order by e1.id asc, e1.month desc


580.

Select
    a.dept_name,
    coalesce(count(student_id), 0) student_number
from
    department a 
left join
    student b
on
    (a.dept_id = b.dept_id)
group by a.dept_name
order by student_number desc, a.dept_name asc;


584.

select
    a.name
from
    customer a
left outer join
    customer b 
on
    (a.referee_id = b.id)
where
    ifnull(a.referee_id, -1) != 2
order by a.id


585.

select
    sum(tiv_2016)
from
    insurance a 
    left outer join 
    (select
          b.lat, 
          b.lon 
     from
          insurance b 
     group by b.lat, b.lon 
     having count(*) > 1) c 
         on (a.lat = c.lat and a.lon = c.lon) 
     left outer join
     (select
           d.tiv_2015 
      from
           insurance d 
      group by d.tiv_2015 
      having count(*) > 1) e 
         on (a.tiv_2015 = e.tiv_2015)
where
    c.lat is null and
    c.lon is null and
    e.tiv_2015 is not null;


586.

select
 customer_number 
from
 (select customer_number, count(order_number) order_count 
  from orders group by customer_number) a 
order by order_count desc limit 1

select
 customer_number 
from orders1 
group by customer_number 
having count(order_number) = (
     select max(order_count) from (
        select count(order_number) order_count from orders1 
        group by customer_number) a
)


595.

SELECT name, population, area
from World
where area > 3000000 
UNION
SELECT name, population, area
from World
where population > 25000000


596.

select class
from courses
group by class
having count(distinct student) >=5


597.

SELECT (CASE WHEN ROUND(accepted.count/requested.count, 2) is NULL THEN 0.0
			ELSE ROUND(accepted.count/requested.count, 2) END) AS accept_rate
from (select count(1) count from (select distinct requester_id, accepter_id from request_accepted) a) accepted,
	 (select count(1) count from (select distinct sender_id, send_to_id from friend_request) b) requested
where 1 = 1


601.

SELECT T1.*
FROM STADIUM T1, STADIUM T2, STADIUM T3
WHERE T1.PEOPLE>=100 AND T2.PEOPLE>=100 AND T3.PEOPLE>=100
AND 
(
(T1.ID - T2.ID = 1 and T1.ID - T3.ID = 2 AND T2.ID - T3.ID = 1)
    OR
(T2.ID - T1.ID = 1 and T2.ID - T3.ID = 2 AND T1.ID - T3.ID = 1)
    OR
(T3.ID - T2.ID = 1 AND T3.ID - T1.ID = 2 AND T2.ID - T1.ID = 1)
)


602.

SELECT
    a.requester_id id, 
    (SELECT
        count(1) 
    FROM
        request_accepted b 
    WHERE
        b.accepter_id = a.requester_id OR
        b.requester_id = a.requester_id
    ) num 
FROM
    request_accepted a 
ORDER BY
    num DESC
LIMIT 1


603.

SELECT DISTINCT a.seat_id
from CINEMA a
INNER JOIN CINEMA b
ON ABS(a.seat_id - b.seat_id) = 1
where a.FREE = 1 AND b.free = 1
order by a.seat_id


610.

SELECT
    x, 
    y, 
    z, 
    IF(x + y > z AND y + z > x AND z + x > y, 'Yes', 'No') triangle 
FROM
    triangle;


612.

SELECT
round(min(sqrt(pow(a.x-b.x,2)+pow(a.y-b.y,2))),2) as shortest
FROM point_2d a, point_2d b
WHERE a.x <> b.x OR a.y <> b.y


613.

SELECT
min(abs(a.x-b.x)) as shortest
FROM point a, point b
WHERE a.x <> b.x


614.

SELECT distinct b.follower, c.count as num
from follow b
JOIN
(select a.followee, count (distinct a.follower) count
from follow a
group by a.followee) c
ON (b.follower = a.followee)
order by b.follower


615.

Select
    pay_month,
    department_id, 
    case when dept_avg > comp_avg then 'higher' when dept_avg < comp_avg then 'lower' else 'same' end comparison
from (
        select  date_format(b.pay_date, '%Y-%m') pay_month, a.department_id, avg(b.amount) dept_avg,  d.comp_avg
        from employee a 
        inner join salary b
            on (a.employee_id = b.employee_id) 
        inner join (select date_format(c.pay_date, '%Y-%m') pay_month, avg(c.amount) comp_avg 
                    from salary c 
                    group by date_format(c.pay_date, '%Y-%m')) d 
            on ( date_format(b.pay_date, '%Y-%m') = d.pay_month)
group by date_format(b.pay_date, '%Y-%m'), department_id, d.comp_avg) final


618.

SELECT
  America,
  Asia,
  Europe
FROM
  (SELECT
     row_number() OVER (PARTITION BY continent order by name) AS asid,
     name AS Asia
   FROM
     student
   WHERE
     continent = 'Asia'
   ) AS t1
  RIGHT JOIN
  (SELECT
     row_number() OVER (PARTITION BY continent order by name) AS amid,
     name AS America
   FROM
     student
   WHERE
     continent = 'America'
   ) AS t2 
  ON asid = amid
  LEFT JOIN
  (SELECT
     row_number() OVER (PARTITION BY continent order by name) AS euid,
     name AS Europe
   FROM
     student
   WHERE
     continent = 'Europe'
  ) AS t3 
  ON amid = euid;


619.

SELECT MAX(Num) as Num
from 
(
SELECT Num
from number
group by Num
having count(*)=1
) as a


620.

SELECT *
from cinema
where mod(id, 2) = 1 AND description!="boring"
Order by rating desc


626.

SELECT 
(CASE WHEN MOD(ID,2)!= 0 AND COUNTS != ID THEN ID+1
      WHEN MOD(ID,2)!= 0 AND COUNTS = ID THEN ID
 ELSE ID-1
 END ) as id,
STUDENT
from seat,
(SELECT COUNT(*) as counts
from Seat) as seat_counts
ORDER BY id asc


627.

UPDATE SALARY
SET SEX = IF (SEX ="m","f","m")


1179.

Select t.id,
MIN(CASE WHEN t.month='Jan' THEN t.revenue Else Null End) As 'Jan_Revenue',
MIN(CASE WHEN t.month='Feb' THEN t.revenue Else Null End) As 'Feb_Revenue',
MIN(CASE WHEN t.month='Mar' THEN t.revenue Else Null End) As 'Mar_Revenue',
MIN(CASE WHEN t.month='Apr' THEN t.revenue Else Null End) As 'Apr_Revenue',
MIN(CASE WHEN t.month='May' THEN t.revenue Else Null End) As 'May_Revenue',
MIN(CASE WHEN t.month='Jun' THEN t.revenue Else Null End) As 'Jun_Revenue',
MIN(CASE WHEN t.month='Jul' THEN t.revenue Else Null End) As 'Jul_Revenue',
MIN(CASE WHEN t.month='Aug' THEN t.revenue Else Null End) As 'Aug_Revenue',
MIN(CASE WHEN t.month='Sep' THEN t.revenue Else Null End) As 'Sep_Revenue',
MIN(CASE WHEN t.month='Oct' THEN t.revenue Else Null End) As 'Oct_Revenue',
MIN(CASE WHEN t.month='Nov' THEN t.revenue Else Null End) As 'Nov_Revenue',
MIN(CASE WHEN t.month='Dec' THEN t.revenue Else Null End) As 'Dec_Revenue'
From Department t
Group by t.id

