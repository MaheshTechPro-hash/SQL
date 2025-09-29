CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Class NVARCHAR(10),
    Marks INT,
    DOB DATE
);

INSERT INTO Students (StudentID, Name, Class, Marks, DOB) VALUES
(1, 'Rohit Sharma', '10A', 85, '2007-05-12'),
(2, 'Priya Verma',  '10A', 92, '2007-07-22'),
(3, 'Aman Gupta',   '10B', 76, '2006-09-01'),
(4, 'Neha Singh',   '10B', 88, '2007-11-15'),
(5, 'Karan Patel',  '10C', 95, '2006-03-05');
select * from Students


--🔹 Basic Level
--Write a stored procedure to fetch all students.


CREATE PROCEDURE GetAllStudents
AS
BEGIN
    SELECT * FROM Students;
END;


--Create a procedure that accepts StudentID and returns Name and Marks.


CREATE PROCEDURE GetStudentByID
    @StudentID INT
AS
BEGIN
    SELECT Name, Marks 
    FROM Students 
    WHERE StudentID = @StudentID;
END;



--Write a procedure to insert a new student record.

CREATE PROCEDURE InsertStudent
    @StudentID INT,
    @Name NVARCHAR(50),
    @Class NVARCHAR(10),
    @Marks INT,
    @DOB DATE
AS
BEGIN
    INSERT INTO Students VALUES(@StudentID, @Name, @Class, @Marks, @DOB);
END;



--Create a procedure to update Marks of a student by StudentID.


CREATE PROCEDURE UpdateMarks
    @StudentID INT,
    @Marks INT
AS
BEGIN
    UPDATE Students SET Marks = @Marks WHERE StudentID = @StudentID;
END;



--Write a procedure to delete a student using StudentID.


CREATE PROCEDURE DeleteStudent
    @StudentID INT
AS
BEGIN
    DELETE FROM Students WHERE StudentID = @StudentID;
END;




--🔹 Intermediate Level
--Write a procedure that accepts a Marks value and returns all students scoring above it.


CREATE PROCEDURE GetStudentsAboveMarks
    @Marks INT
AS
BEGIN
    SELECT * FROM Students WHERE Marks > @Marks;
END;


--CREATE PROCEDURE GetAverageMarksByClass
CREATE PROCEDURE GetAverageMarksByClass
    @Class NVARCHAR(10)
AS
BEGIN
    SELECT AVG(Marks) AS AvgMarks
    FROM Students
    WHERE Class = @Class;
END;




--Create a procedure to return the top 3 students by Marks.

CREATE PROCEDURE GetTop3Students
AS
BEGIN
    SELECT TOP 3 * 
    FROM Students
    ORDER BY Marks DESC;
END;

--Write a procedure to check if a student exists (return “Exists” / “Not Exists”).
CREATE PROCEDURE CheckStudentExists
    @StudentID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
        PRINT 'Exists';
    ELSE
        PRINT 'Not Exists';
END;




--Create a procedure with default parameter Class = '10A' and return students of that class.

CREATE PROCEDURE GetStudentsByClass
    @Class NVARCHAR(10) = '10A'
AS
BEGIN
    SELECT * FROM Students WHERE Class = @Class;
END;


--🔹 Advanced Level
--Write a procedure with an OUT parameter to return the student with maximum Marks.

CREATE PROCEDURE GetTopper
    @TopperName NVARCHAR(50) OUTPUT
AS
BEGIN
    SELECT TOP 1 @TopperName = Name 
    FROM Students
    ORDER BY Marks DESC;
END;



--Write a procedure that uses a transaction to swap marks between two students.

CREATE PROCEDURE SwapMarks
    @StudentID1 INT,
    @StudentID2 INT
AS
BEGIN
    BEGIN TRANSACTION;
    DECLARE @Marks1 INT, @Marks2 INT;

    SELECT @Marks1 = Marks FROM Students WHERE StudentID = @StudentID1;
    SELECT @Marks2 = Marks FROM Students WHERE StudentID = @StudentID2;

    UPDATE Students SET Marks = @Marks2 WHERE StudentID = @StudentID1;
    UPDATE Students SET Marks = @Marks1 WHERE StudentID = @StudentID2;

    COMMIT TRANSACTION;
END;




--Write a procedure for pagination (inputs: PageNumber, PageSize).

CREATE PROCEDURE GetStudentsByPage
    @PageNumber INT,
    @PageSize INT
AS
BEGIN
    SELECT * 
    FROM Students
    ORDER BY StudentID
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;



--Write a procedure with a cursor to print student names one by one.

CREATE PROCEDURE PrintStudentNames
AS
BEGIN
    DECLARE @Name NVARCHAR(50);
    DECLARE StudentCursor CURSOR FOR SELECT Name FROM Students;

    OPEN StudentCursor;
    FETCH NEXT FROM StudentCursor INTO @Name;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT @Name;
        FETCH NEXT FROM StudentCursor INTO @Name;
    END;

    CLOSE StudentCursor;
    DEALLOCATE StudentCursor;
END;




--Create a procedure that logs student updates into another table (audit table).

CREATE TABLE StudentAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT,
    OldMarks INT,
    NewMarks INT,
    ChangeDate DATETIME DEFAULT GETDATE()
);

CREATE PROCEDURE UpdateMarksWithAudit
    @StudentID INT,
    @NewMarks INT
AS
BEGIN
    DECLARE @OldMarks INT;
    SELECT @OldMarks = Marks FROM Students WHERE StudentID = @StudentID;

    UPDATE Students SET Marks = @NewMarks WHERE StudentID = @StudentID;

    INSERT INTO StudentAudit (StudentID, OldMarks, NewMarks)
    VALUES(@StudentID, @OldMarks, @NewMarks);
END;


