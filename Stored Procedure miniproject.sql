--Mini Project Title: Student Management System
--Step 1:
--Create Table

CREATE TABLE Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    Course NVARCHAR(100),
    Marks INT
);


--Step 2: Stored Procedures

--1)Insert Student
CREATE PROCEDURE AddStudent
    @FullName NVARCHAR(100),
    @Email NVARCHAR(100),
    @Course NVARCHAR(100),
    @Marks INT
AS
BEGIN
    INSERT INTO Students (FullName, Email, Course, Marks)
    VALUES (@FullName, @Email, @Course, @Marks);
END;

--2)Get All Students
CREATE PROCEDURE GetAllStudents
AS
BEGIN
    SELECT * FROM Students;
END;

--3)Get Student by ID
CREATE PROCEDURE GetStudentByID
    @StudentID INT
AS
BEGIN
    SELECT * FROM Students WHERE StudentID = @StudentID;
END;

--4)Update Student Marks
CREATE PROCEDURE UpdateStudentMarks
    @StudentID INT,
    @NewMarks INT
AS
BEGIN
    UPDATE Students
    SET Marks = @NewMarks
    WHERE StudentID = @StudentID;
END;

--5)Delete Student
CREATE PROCEDURE DeleteStudent
    @StudentID INT
AS
BEGIN
    DELETE FROM Students WHERE StudentID = @StudentID;
END;

--Step 3: Call (Use) the Stored Procedures
EXEC AddStudent 'Ravi Patil', 'ravi@gmail.com', 'Maths', 85;
EXEC AddStudent 'Sneha Deshmukh', 'sneha@gmail.com', 'Science', 90;

--Get All Students
EXEC GetAllStudents;

--Get Student by ID
EXEC GetStudentByID @StudentID = 1;

--Update Student Marks
EXEC UpdateStudentMarks @StudentID = 1, @NewMarks = 95;

--Delete Student
EXEC DeleteStudent @StudentID = 2;

