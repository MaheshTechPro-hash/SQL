CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName NVARCHAR(50),
    Marks INT
);

INSERT INTO Students VALUES
(1, 'Rahul', 85),
(2, 'Sneha', 72),
(3, 'Amit', 90),
(4, 'Priya', 65);


CREATE FUNCTION dbo.fn_StudentsBonusMSTVF()
RETURNS @Result TABLE
(
    StudentID INT,
    StudentName NVARCHAR(50),
    Marks INT,
    MarksWithBonus INT,
    HighScorer BIT
)
AS
BEGIN
    -- Insert rows into table variable
    INSERT INTO @Result
    SELECT 
        StudentID,
        StudentName,
        Marks,
        Marks + 5 AS MarksWithBonus,
        CASE WHEN Marks + 5 >= 90 THEN 1 ELSE 0 END AS HighScorer
    FROM Students;

    RETURN;
END;


SELECT * FROM dbo.fn_StudentsBonusMSTVF();
