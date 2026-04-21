SQL Practice: Employees Earning More Than Their Managers



📌 Problem Statement



Given an employee table where each employee has a manager, write a query to find employees who earn more than their managers.



🧱 Table Structure



CREATE TABLE emp (

&#x20;   emp\_id INT,

&#x20;   emp\_name VARCHAR(10),

&#x20;   salary INT,

&#x20;   manager\_id INT

);



📥 Sample Data



INSERT INTO emp VALUES (1,'Ankit',10000,4);

INSERT INTO emp VALUES (2,'Mohit',15000,5);

INSERT INTO emp VALUES (3,'Vikas',10000,4);

INSERT INTO emp VALUES (4,'Rohit',5000,2);

INSERT INTO emp VALUES (5,'Mudit',12000,6);

INSERT INTO emp VALUES (6,'Agam',12000,2);

INSERT INTO emp VALUES (7,'Sanjay',9000,2);

INSERT INTO emp VALUES (8,'Ashish',5000,2);

\------------------------------------------

🔍 Approach



This problem involves comparing an employee's salary with their manager’s salary.



Since both employees and managers exist in the same table, we use a self join.



Key Idea:

Treat the emp table as:

e → Employee

m → Manager



Join condition:



e.manager\_id = m.emp\_id



Then compare salaries:



e.salary > m.salary



✅ SQL Query



SELECT 

&#x20;   e.emp\_id,

&#x20;   e.emp\_name,

&#x20;   m.emp\_name AS manager\_name,

&#x20;   e.salary,

&#x20;   m.salary AS manager\_salary

FROM emp e

INNER JOIN emp m 

&#x20;   ON e.manager\_id = m.emp\_id

WHERE e.salary > m.salary;



📊 Explanation



Column	Description

emp\_id	Employee ID

emp\_name	Employee Name

manager\_name	Name of the manager

salary	Employee's salary

manager\_salary	Manager's salary

Step-by-step:

Self Join:

We join the table with itself to map employees to their managers.

Alias Usage:

e → employee

m → manager

Join Condition:

Links each employee to their manager.

Filter Condition:

Only select employees whose salary is greater than their manager.

🎯 Output Insight



This query returns employees who are earning more than their managers, which is useful for:



Detecting salary anomalies

HR analytics

Organizational insights



💡 Key Concepts Used



Self Join

Table Aliasing

Filtering with WHERE

Relational mapping within the same table



🚀 How to Run



Create the table

Insert sample data

Execute the query



📁 Suggested Repo Structure



sql-practice/

│

├── employee\_salary\_comparison.sql

└── README.md



🧠 Learning Outcome



After this problem, you should be comfortable with:



Writing self joins

Comparing hierarchical data

Understanding real-world relational queries

