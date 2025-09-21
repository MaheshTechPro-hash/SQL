-- Departments Table
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY IDENTITY(1,1),
    DeptName VARCHAR(50) NOT NULL
);

SELECT * FROM Departments;

-- Employees Table
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    HireDate DATE,
    Salary DECIMAL(10,2),
    DeptID INT FOREIGN KEY REFERENCES Departments(DeptID)
);
SELECT * FROM Employees;

-- Projects Table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY IDENTITY(1,1),
    ProjectName VARCHAR(100),
    DeptID INT FOREIGN KEY REFERENCES Departments(DeptID)
);
SELECT * FROM Projects;

-- EmployeeProjects (Many-to-Many Relation)
CREATE TABLE EmployeeProjects (
    EPID INT PRIMARY KEY IDENTITY(1,1),
    EmpID INT FOREIGN KEY REFERENCES Employees(EmpID),
    ProjectID INT FOREIGN KEY REFERENCES Projects(ProjectID),
    Role VARCHAR(50)
);
SELECT * FROM EmployeeProjects;

-- Departments
INSERT INTO Departments (DeptName) VALUES
('IT'),
('HR'),
('Finance');

-- Employees
INSERT INTO Employees (FirstName, LastName, Email, Phone, HireDate, Salary, DeptID) VALUES
('Rahul', 'Patil', 'rahul.patil@example.com', '9876543210', '2020-01-15', 50000, 1),
('Sneha', 'Sharma', 'sneha.sharma@example.com', '9765432109', '2021-03-10', 60000, 1),
('Amit', 'Kumar', 'amit.kumar@example.com', '9988776655', '2019-07-20', 45000, 2),
('Priya', 'Desai', 'priya.desai@example.com', '9123456789', '2022-05-05', 70000, 3);

-- Projects
INSERT INTO Projects (ProjectName, DeptID) VALUES
('Website Development', 1),
('HR Portal', 2),
('Payroll System', 3);

-- EmployeeProjects
INSERT INTO EmployeeProjects (EmpID, ProjectID, Role) VALUES
(1, 1, 'Backend Developer'),
(2, 1, 'Frontend Developer'),
(3, 2, 'HR Coordinator'),
(4, 3, 'Finance Analyst');


--List all employees with their department
SELECT e.FirstName, e.LastName, d.DeptName
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID;


--Show employees working on "Website Development"
SELECT e.FirstName, e.LastName, p.ProjectName, ep.Role
FROM Employees e
JOIN EmployeeProjects ep ON e.EmpID = ep.EmpID
JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE p.ProjectName = 'Website Development';



--Find total salary per department
SELECT d.DeptName, SUM(e.Salary) AS TotalSalary
FROM Departments d
JOIN Employees e ON d.DeptID = e.DeptID
GROUP BY d.DeptName;


--Employees hired after 2020
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE HireDate > '2020-01-01';

-- Employees who earn more than the average salary
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

--Departments that have employees earning above 60,000
SELECT DeptName
FROM Departments
WHERE DeptID IN (
    SELECT DeptID FROM Employees WHERE Salary > 60000
);

--Find the highest paid employee in each department (correlated subquery)
SELECT FirstName, LastName, Salary, DeptID
FROM Employees e1
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees e2
    WHERE e1.DeptID = e2.DeptID
);

--List employees who are not assigned to any project
SELECT FirstName, LastName
FROM Employees
WHERE EmpID NOT IN (
    SELECT EmpID FROM EmployeeProjects
);

--Show department with the maximum number of employees
SELECT DeptName
FROM Departments
WHERE DeptID = (
    SELECT TOP 1 DeptID
    FROM Employees
    GROUP BY DeptID
    ORDER BY COUNT(EmpID) DESC
);
