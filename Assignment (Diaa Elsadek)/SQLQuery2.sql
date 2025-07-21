
-- Part 01

-- 1

USE ITI

CREATE or ALTER FUNCTION dbo.GetStudentCountt (@deptId int) 
returns int
begin
		declare @count int
		select @count=Count(*)
		from student S
		where s.Dept_Id = @deptId
		return @count
end

select dbo.GetStudentCountt(30)

-- 2

USE MyCompany

CREATE or ALTER PROCEDURE CheckEmployeesInProjectP1
as
begin
    DECLARE @empCount INT

    SELECT @empCount = COUNT(*)
    FROM Works_for WF
    JOIN Project P ON WF.Pno = P.Pnumber
    WHERE P.Pname = 'p1'

    IF @empCount >= 3
    BEGIN
        Select 'The number of employees in the project p1 is 3 or more'
		-- Print 'The number of employees in the project p1 is 3 or more'
    END
    ELSE
    BEGIN
        Select 'The following employees work for the project p1'
		-- Print 'The following employees work for the project p1'

        SELECT E.Fname, E.Lname
        FROM Employee E
        JOIN Works_for WF ON E.SSN = WF.Essn
        JOIN Project P ON WF.Pno = P.Pnumber
        WHERE P.Pname = 'p1'
    END
end

EXEC CheckEmployeesInProjectP1


-- 3

USE MyCompany

CREATE or ALTER PROCEDURE ReplaceEmployeeInProject
    @OldEmpNo INT,
    @NewEmpNo INT,
    @ProjectNo INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Project WHERE Pnumber = @ProjectNo)
    BEGIN
        SELECT 'Error : Project number does not exist' AS Message;
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Employee WHERE SSN = @NewEmpNo)
    BEGIN
        SELECT 'Error : New employee does not exist' AS Message;
        RETURN;
    END

    IF EXISTS (
        SELECT 1 FROM Works_for
        WHERE Essn = @NewEmpNo AND Pno = @ProjectNo
    )
    BEGIN
        SELECT 'Error : New employee is already assigned to this project' AS Message;
        RETURN;
    END

    DELETE FROM Works_for
    WHERE Essn = @OldEmpNo AND Pno = @ProjectNo;

    INSERT INTO Works_for (Essn, Pno)
    VALUES (@NewEmpNo, @ProjectNo);

    SELECT 'Replacement done successfully' AS Message;
END;

EXEC ReplaceEmployeeInProject @OldEmpNo = 521634, @NewEmpNo = 223344, @ProjectNo = 300;
EXEC ReplaceEmployeeInProject @OldEmpNo = 669955, @NewEmpNo = 521634, @ProjectNo = 600;
