-- Department Table
CREATE TABLE Department (
    DeptID INT PRIMARY KEY IDENTITY(1,1),
    DeptName VARCHAR(100) NOT NULL UNIQUE
);

-- Employee Table
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    DeptID INT FOREIGN KEY REFERENCES Department(DeptID),
    HireDate DATE DEFAULT GETDATE()
);

-- Project Table
CREATE TABLE Project (
    ProjectID INT PRIMARY KEY IDENTITY(1,1),
    ProjectName VARCHAR(100) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    DeptID INT FOREIGN KEY REFERENCES Department(DeptID)
);

-- EmployeeProject (Many-to-Many relation)
CREATE TABLE EmployeeProject (
    EmpID INT FOREIGN KEY REFERENCES Employee(EmpID),
    ProjectID INT FOREIGN KEY REFERENCES Project(ProjectID),
    Role VARCHAR(50),
    PRIMARY KEY (EmpID, ProjectID)
);

INSERT INTO Department (DeptName) VALUES ('Development'),('Testing'),('HR');

INSERT INTO Employee (FirstName, LastName, Email, Salary, DeptID) VALUES
('Amit','Sharma','amit@itcompany.com',60000,1),
('Priya','Verma','priya@itcompany.com',55000,2),
('Rahul','Patil','rahul@itcompany.com',70000,1);

INSERT INTO Project (ProjectName, StartDate, EndDate, DeptID) VALUES
('ERP System','2023-01-01','2023-12-31',1),
('Mobile App','2023-04-01','2023-10-31',1),
('Automation Testing','2023-05-01','2023-08-31',2);

INSERT INTO EmployeeProject (EmpID, ProjectID, Role) VALUES
(1,1,'Developer'),
(2,3,'Tester'),
(3,2,'Lead Developer');

-- 1. Get Employees by Department
CREATE PROCEDURE GetEmployeesByDept
    @DeptName VARCHAR(100)
AS
BEGIN
    SELECT E.EmpID, E.FirstName + ' ' + E.LastName AS FullName, E.Email, E.Salary, D.DeptName
    FROM Employee E
    JOIN Department D ON E.DeptID = D.DeptID
    WHERE D.DeptName = @DeptName;
END;
GO

-- 2. Assign Employee to Project
CREATE PROCEDURE AssignEmployeeToProject
    @EmpID INT,
    @ProjectID INT,
    @Role VARCHAR(50)
AS
BEGIN
    INSERT INTO EmployeeProject (EmpID, ProjectID, Role)
    VALUES (@EmpID, @ProjectID, @Role);
END;
GO


-- Function: Get Annual Salary
CREATE FUNCTION fn_GetAnnualSalary (@EmpID INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @Annual DECIMAL(12,2);
    SELECT @Annual = Salary * 12 FROM Employee WHERE EmpID = @EmpID;
    RETURN @Annual;
END;
GO

-- Function: Get Employee Full Name
CREATE FUNCTION fn_GetFullName (@EmpID INT)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @FullName VARCHAR(100);
    SELECT @FullName = FirstName + ' ' + LastName FROM Employee WHERE EmpID = @EmpID;
    RETURN @FullName;
END;
GO


-- Trigger: Prevent Salary Decrease (IT company policy)
CREATE TRIGGER trg_PreventSalaryDecrease
ON Employee
FOR UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN deleted d ON i.EmpID = d.EmpID
        WHERE i.Salary < d.Salary
    )
    BEGIN
        RAISERROR('Salary cannot be decreased for employees!',16,1);
        ROLLBACK TRANSACTION;
    END
END;
GO


-- Use Stored Procedure
EXEC GetEmployeesByDept @DeptName = 'Development';

EXEC AssignEmployeeToProject @EmpID=2, @ProjectID=2, @Role='Tester';

-- Use Function
SELECT dbo.fn_GetAnnualSalary(1) AS AnnualSalary;
SELECT dbo.fn_GetFullName(3) AS FullName;

-- Trigger Test (Try to decrease salary)
UPDATE Employee SET Salary = 40000 WHERE EmpID = 1; -- ❌ will fail
