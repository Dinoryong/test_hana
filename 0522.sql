--그룹화 함수
--부서 번호 별로 평균 급여 값 출력
--부서 번호 확인
SELECT DISTINCT DEPTNO FROM EMP;
--각 부서 번호에서 근무하는 직원 출력
SELECT * FROM EMP WHERE DEPTNO = 10;
SELECT * FROM EMP WHERE DEPTNO = 20;
SELECT * FROM EMP WHERE DEPTNO = 30;
--각 부서 번호에서 근무하는 직원들의 평균 급여 출력
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 10;
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 20;
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 30;
--집합연산자 UNION / UNION ALL
SELECT '10' AS DEPTNO, AVG(SAL) FROM EMP WHERE DEPTNO = 10
UNION
SELECT '20' AS DEPTNO, AVG(SAL) FROM EMP WHERE DEPTNO = 20
UNION
SELECT '30' AS DEPTNO, AVG(SAL) FROM EMP WHERE DEPTNO = 30;
--GROUP BY 절을 이용하여 재현
SELECT DEPTNO, AVG(SAL) FROM EMP GROUP BY DEPTNO;
SELECT DEPTNO, AVG(SAL) FROM EMP GROUP BY DEPTNO ORDER BY DEPTNO;
SELECT DEPTNO, AVG(SAL) FROM EMP GROUP BY DEPTNO ORDER BY DEPTNO ASC;
--2개의 열을 이용하여 GROUP BY
SELECT DEPTNO, JOB, AVG(SAL) FROM EMP GROUP BY DEPTNO, JOB;
SELECT DEPTNO, JOB, AVG(SAL) FROM EMP GROUP BY DEPTNO, JOB ORDER BY DEPTNO ASC, JOB ASC;
--GROUP BY 에 사용하는 열 이름을 SELECT 절에서도 동일하게 사용
--GROUP BY 에 사용하지 않는 열 이름을 SELECT 절에서 사용하게 되면 ERROR 발생
SELECT DEPTNO, ENAME, AVG(SAL) FROM EMP GROUP BY DEPTNO; 
--GROUP BY ~ HAVING (조건)
SELECT DEPTNO, JOB, AVG(SAL) FROM EMP GROUP BY DEPTNO, JOB ORDER BY DEPTNO ASC, JOB ASC;
--평균 급여 2000 이상 => 전체 사원 14명을 가지고 그룹화
SELECT DEPTNO, JOB, AVG(SAL) FROM EMP 
    GROUP BY DEPTNO, JOB
    HAVING AVG(SAL) >= 2000
    ORDER BY DEPTNO ASC, JOB ASC;
--직책이 CLERK 인 경우 출력
SELECT DEPTNO, JOB, AVG(SAL) FROM EMP
    GROUP BY DEPTNO, JOB
    HAVING JOB = 'CLERK'
    ORDER BY DEPTNO ASC, JOB ASC;
--WHERE절과 비교 => 사원 6명을 가지고 그룹화
SELECT DEPTNO, JOB FROM EMP WHERE SAL >= 2000;
SELECT DEPTNO, JOB, AVG(SAL) FROM EMP WHERE SAL >= 2000
    GROUP BY DEPTNO, JOB
    HAVING AVG(SAL) >= 2000
    ORDER BY DEPTNO ASC, JOB ASC;
--그룹화와 관련된 함수 = GROUP BY 와 함께 사용하는 함수
--먼저 GROUP BY 로 결과 출력
SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL) FROM EMP
    GROUP BY DEPTNO, JOB
    ORDER BY DEPTNO ASC, JOB ASC;
--ROLLUP : 열의 개수 + 1 개의 결과 출력
--1) A + B = 부서번호 + 직책 으로 GROUP BY
--2) A = 부서번호 로 GROUP BY
--3) 전체 
SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL) FROM EMP
    GROUP BY ROLLUP(DEPTNO, JOB);
--CUBE : 2의 열의 개수 제곱 개의 결과 출력
--1) A + B = 부서번호 + 직책 으로 GROUP BY
--2) A = 부서번호 로 GROUP BY
--3) B = 직책으로 GROUP BY
--4) 전체
SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL) FROM EMP
    GROUP BY CUBE(DEPTNO, JOB);
--ROLLUP 을 일부 열만 가지고 사용
--1) A + B = 부서번호 + 직책 으로 GROUP BY
--2) A = 부서번호 로 GROUP BY
--전체는 나오지 않음
SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL) FROM EMP
    GROUP BY DEPTNO, ROLLUP(JOB);
--1) A + B = 부서번호 + 직책 으로 GROUP BY
--2) A = 직책 으로 GROUP BY
--전체는 나오지 않음
SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL) FROM EMP
    GROUP BY JOB, ROLLUP(DEPTNO);




--LISTAGG:
SELECT NAME FROM EMP;
SELECT DEPTNO, ENAME FROM EMP GROUP BY DEPTNO, ENAME ORDER BY DEPTNO ASC, ENAME ASC;
--부서 별로 사원 이름을 알파벳 순서대로 나열한 다음 이름과 이름 사이에 ', ' 로 연결시켜 출력
SELECT DEPTNO,
    LISTAGG(ENAME, ', ')
    WITHIN GROUP(ORDER BY ENAME ASC) AS ENAME
    FROM EMP
    GROUP BY DEPTNO;
--부서 별로 사원 이름을 급여가 높은 순서대로 나열한 다음 이름과 이름 사이에 ', ' 로 연결시켜 출력
SELECT DEPTNO,
    LISTAGG(ENAME, ', ')
    WITHIN GROUP(ORDER BY SAL DESC) AS ENAME
    FROM EMP
    GROUP BY DEPTNO;
--PIVOT : 행을 열로 바꾼다
SELECT DEPTNO, JOB, MAX(SAL) FROM EMP GROUP BY DEPTNO, JOB ORDER BY DEPTNO ASC, JOB ASC;
--부서 번호를 행에서 열로 바꾼다
SELECT * FROM (SELECT DEPTNO, JOB, SAL FROM EMP)
    PIVOT(MAX(SAL) FOR DEPTNO IN (10, 20, 30))
    ORDER BY JOB;
--직책을 행에서 열로 바꾼다
SELECT * FROM (SELECT DEPTNO, JOB, SAL FROM EMP)
    PIVOT(MAX(SAL) FOR JOB IN ('ANALYST' AS ANALYST,
                                'CLERK' AS CLERK,
                                'MANAGER' AS MANAGER,
                                'PRESIDENT' AS PRESIDENT,
                                'SALESMAN' AS SALESMAN)) 
    ORDER BY DEPTNO;
--DECODE 문으로 PIVOT 테이블 만들어 보자


--PIVOT 테이블을 다시 UNPIVOT

