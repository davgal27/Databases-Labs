-- QUESTION 1
-- i
CREATE OR REPLACE FUNCTION getIntNoArg()

RETURNS int as $$
DECLARE
    num int;
BEGIN
    num := 20;
    RETURN num;
END;
$$ LANGUAGE plpgsql;

SELECT getIntNoArg();

-- ii : set of records of emp table (scott db)
CREATE OR REPLACE FUNCTION getEmpNoArg()

RETURNS setof scott.emp AS $$
BEGIN
    RETURN QUERY 
	SELECT * from scott.emp;
END;
$$ LANGUAGE plpgsql;

SELECT getEmpNoArg();

-- iii
CREATE OR REPLACE FUNCTION getIntArg(input_num int)
RETURNS int AS $$
BEGIN
    RETURN input_num;
END;
$$ LANGUAGE plpgsql;

SELECT getIntArg(15);

-- iv
CREATE OR REPLACE FUNCTION getEmpArg(input_dept int)

RETURNS setof scott.emp AS $$
BEGIN
    RETURN QUERY 
	SELECT * from scott.emp
	WHERE deptno = input_dept;
END;
$$ LANGUAGE plpgsql;

SELECT getEmpArg(10);
-- Source: Slides on PlpgSQL
-- QUESTION 2 
CREATE OR REPLACE FUNCTION q2(num int)

RETURNS int AS $$
BEGIN
    RETURN num;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM scott.emp
WHERE deptno = q2(10);
-- Source: PlpgSQL slides

-- QUESTION 3
-- function 1 (out)
CREATE OR REPLACE FUNCTION q3(out num int)
AS $$
BEGIN
    num := 6;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM q3();
-- function 2 (no out)
CREATE OR REPLACE FUNCTION q3_noOut(num int)
RETURNS int AS $$
BEGIN
    RETURN 5;
END;
$$ LANGUAGE plpgsql;

SELECT q3_noOut(1);


-- QUESTION 4. 
CREATE OR REPLACE FUNCTION print_to_client(message text)

RETURNS void AS $$
BEGIN
    RAISE NOTICE '%', message;
END;
$$ LANGUAGE plpgsql;

SELECT print_to_client('hello world');
--Source: https://www.postgresql.org/docs/current/plpgsql-control-structures.html#PLPGSQL-STATEMENTS-RAISE
-- QUESTION 5
CREATE OR REPLACE FUNCTION print_job_count(input_job text)

RETURNS void AS $$
DECLARE 
	emp_count int;
	job_exists boolean;
BEGIN
	SELECT EXISTS (
		SELECT 1 FROM scott.emp WHERE job = input_job
	) INTO job_exists;

	IF NOT job_exists THEN 
		RAISE EXCEPTION 'Job name "%" not found', input_job;
	END IF;
	
	SELECT COUNT (*) INTO emp_count
	FROM scott.emp
	WHERE job = input_job;

	IF emp_count = 0 THEN 
		RAISE EXCEPTION 'No employees with job type: "%" found!', input_job;
    ELSE
		RAISE NOTICE 'Employees with job type: "%" found!. Number found: %', input_job, emp_count;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT print_job_count('CLERK');
-- Source: https://www.tutorialspoint.com/postgresql/postgresql_functions.htm

-- QUESTION 6
CREATE OR REPLACE FUNCTION getBigFactorial(fn bigint) RETURNS bigint as $$
 DECLARE
    product bigint;
    minus1  bigint;
 BEGIN
    if (fn < 1) then
    RAISE EXCEPTION 'Error: Argument less than 1!';
        return null;
    end if;
    if (fn > 20) then
        RAISE EXCEPTION 'Error: computing factorial; numeric value out of range';
    end if;
    minus1 := fn - 1;
    if (minus1>0)
    then
       product := fn * getBigFactorial(minus1);
       if (product > 9223372036854775807 or product < -9223372036854775808) then
        RAISE EXCEPTION 'Error: computing factorial; numeric value out of range';
        return null;
       end if;
       return product;
    end if;
    return fn;
 END;
 $$ language plpgsql;
 select getBigFactorial(21)
-- Source: https://www.postgresql.org/docs/current/datatype-numeric.html

-- QUESTION 7
CREATE OR REPLACE FUNCTION scott.printdeptemps(deptid integer)
	RETURNS integer AS
$BODY$
DECLARE
    deptCNT int := 0;
    deptrec scott.dept%rowtype;
    emprec scott.emp%rowtype;
    cursor_deptemp cursor(cdeptid integer)
        IS SELECT empno, ename, job, sal
           FROM scott.emp
           WHERE deptno = cdeptid
           ORDER BY ename;
BEGIN
    -- check if deptid is reasonable & really exists
    IF deptID < 0 THEN
        RAISE NOTICE 'Surely no such deptno %', deptID;
        RETURN null;
    ELSE
        SELECT deptno
        INTO deptCNT
        FROM scott.dept
        WHERE deptno = deptID;

        IF not FOUND THEN
            RAISE NOTICE 'No such deptno %', deptID;
            RETURN null;
        ELSE
            SELECT *
            INTO deptrec
            FROM scott.dept
            WHERE deptno = deptID;
        END IF;
    END IF;

    -- print header
    -- department details
    RAISE NOTICE 'Department name is: % (%) and is located in % .',
        deptrec.dname, deptrec.deptno, deptrec.loc;

    -- print employee details
    -- open & loop cursor
    FOR emprec IN cursor_deptemp(deptID)
    LOOP
        RAISE NOTICE 'Employee % (%) works as % Euro %.',
            emprec.ename, emprec.empno,
            emprec.job, emprec.sal;
    END LOOP;

    -- print footer
    --    number of employees
    SELECT count(*)
    INTO deptCNT
    FROM scott.emp
    WHERE deptno = deptid;

    RAISE NOTICE 'There are % employee/s working with % department.',
        deptCNT, deptrec.dname;

    RETURN deptCNT;
END;
$BODY$
LANGUAGE plpgsql;
-- testing
SELECT scott.printdeptemps(10);

