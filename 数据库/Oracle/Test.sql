select * from emp e left join dept d on e.deptno=d.deptno;
select * from emp;
select * from dept;
select * from emp e right join dept d on e.deptno=d.deptno;
select * from emp e inner join dept d on e.deptno=d.deptno;
select * from dept d inner join emp e on d.deptno=e.deptno;
select * from emp e left join dept d on e.deptno=d.deptno where d.deptno is null;
insert into emp(EMPNO,ENAME,JOB) values(7896,'chjg','boss');
insert into emp(empno,ename,job) values(1234,'chjg1','boss1');/*sql��䲻���ִ�Сд��ֵ���ִ�Сд*/
update emp e set e.deptno=(99) where e.ename='chjg';
delete from emp e where e.ename='chjg';
select * from emp e right join dept d on e.deptno=d.deptno where e.deptno is null;/*�ұߵ�ȫ����Ҳ�����ұߵĶ��м������Ĺ���*/
select count(empno)from emp;/*ͳ��*/
select *  from tab;/*�鿴��ǰ�û��µı�*/
SELECT * FROM emp WHERE sal BETWEEN 1500 AND 3000;/*���ں�����Ҳ����ʹ��*/
SELECT * FROM emp WHERE ename LIKE '_M%';/*ģ����ѯ��_ƥ��һ��������ַ���%ƥ�����ⳤ�ȵ��ַ�*/
SELECT * FROM emp WHERE ename LIKE '%';
SELECT * FROM emp WHERE sal <> 1500;
SELECT * FROM emp WHERE sal !=1500;
SELECT * FROM emp ORDER BY deptno ASC;/*Ĭ������ ASC ������ DESC*/
SELECT * FROM emp ORDER BY deptno,sal ASC;/*���Զ�������*/
SELECT 1 FROM dual;/*��ȡ���������֣�������α��*/
SELECT UPPER('chjg')FROM dual;/*Сд���д*/
SELECT LOWER ('CHJG')FROM dual;/*��д��Сд*/
SELECT INITCAP('chjg')FROM dual;/*����ĸ��д*/
SELECT CONCAT(UPPER('hello'),INITCAP('chjg')) FROM dual;/*�ַ���������*/
SELECT 'hello'||'world' FROM dual;/*����concat���ܿ����ݿ⣬˫���߿��ԣ����м�����*/
SELECT SUBSTR('helloworldchjg',1,8) FROM dual;/*������1��ʼ*/
SELECT SUBSTR('helloworldchjg',0,8) FROM dual;/*������1��ʼ*/
SELECT SUBSTR('helloworldchjg',8)FROM dual;/*һ�����ֵĻ����Ǵ����������ʼ������*/
SELECT LENGTH('helloworldchjg')FROM dual;/*�ַ����ĳ���ͳ��*/
SELECT REPLACE('helloworld','l','chjg')FROM dual;/*��һ����Դ�ַ������ڶ����Ǳ��滻���ַ��������������滻���ַ���,
���ж��ͬ���ı��滻���ַ��������ᱻ�滻��*/
/*��ֵ����*/


SELECT ROUND(12.78)FROM dual;/*��������*/
SELECT ROUND(12.78654,2) FROM dual;/*�������룬������λС��*/
SELECT TRUNC(12.79951)FROM dual;/*ֱ��ȥ��С������*/
SELECT TRUNC(12.7555,2)FROM dual;/*����С�������λ�����ǲ�����������*/
SELECT MOD(10,3)FROM dual;/*ȡ��*/



/*���ں���*/
SELECT  SYSDATE FROM dual;
SELECT TRUNC((SYSDATE - hiredate)/7 )FROM emp;/*sysdate ϵͳ���ڡ�
����-���� �õ�����������*/
SELECT ename,TRUNC(months_between(SYSDATE,hiredate))FROM emp;/* months_between  ��������ȡ����ʱ����ڵ�����*/
SELECT add_months(SYSDATE,3)FROM dual;/*��12��һλ*/
SELECT next_day(SYSDATE,'������')FROM dual;/*��һ������*/
SELECT last_day(SYSDATE)FROM dual;/*�������һ��*/




/*ת������*/
SELECT ENAME,
       TO_CHAR(HIREDATE, 'yyyy') ��,
       TO_CHAR(HIREDATE, 'mm') ��,
       TO_CHAR(HIREDATE, 'dd') ��
  FROM EMP;
SELECT hiredate FROM emp;
SELECT to_char(SYSDATE,'yyyy-mm-dd HH24:mi:ss')FROM dual;/*24Сʱ��*/
SELECT to_char(SYSDATE,'yyyy-mm-dd HH:mi:ss')FROM dual;/*��ͨ12Сʱ��*/
SELECT ename, to_char(hiredate,'yyyy-mm-dd')FROM emp;/*��ʽ��ת�����ڲ���10�Ļ���ǰ��0*/
SELECT ename,to_char(hiredate,'fmyyyy-mm-dd')FROM emp;/*���fm���Խ��ǰ���������*/



SELECT ename,sal FROM emp;
SELECT ename,to_char(sal,'999,999')FROM emp;
SELECT ename,to_char(sal,'$999,999')FROM emp;
SELECT ename,to_char(sal,'l999,999')FROM emp;/*l=local ���ص���˼*/

/*to_number����ת��*/
SELECT to_number('10')+to_number('10')FROM dual;/*ת�����ַ��������������͵�*/

/*����ת��*/
SELECT to_date('1997-02-10 12:30:56','yyyy-mm-dd HH24:mi:ss')FROM dual;/*���ã��ص�*/

/*ͨ�ú���*/
SELECT ename ,sal,NVL(sal,0)pcomm FROM emp;

SELECT ename ,sal*12+NVL(comm,0) FROM emp;/*nvl ��ֵȡ�����õĲ��������Ҳ����������
���oracle��һ������Ϊ����ô��ʾ�ڶ���������ֵ�������һ��������ֵ��Ϊ�գ�����ʾ��һ������������ֵ��
*/
/*decode���� ������if else*/
SELECT DECODE(9,1,'����1',2,'����2','����')FROM dual;/*��һ����������Ҫ���жϵĲ���*/
SELECT ENAME,
       DECODE(JOB, 'CLERK', 'ҵ��Ա','SALESMAN','����','boss')
FROM EMP;


/*case when ��decode������ͬ*/
SELECT ename ,(CASE WHEN job='CLERK'THEN 'ҵ��Ա'
                  WHEN job='SALEMAN'THEN '����'
                  ELSE '��ҵ'
                  END)cjob
 FROM EMP; 


/*������ϲ�ѯ*/
----�����ӣ������Ӳ�ѯ����һ�ű�Ҫ��ѯȫ��������ʱ(������Ϊ����һ�ű�����ݹ�������ɸѡ��) �����ӷ���������
----ȫ��������߾��������ӣ����ұ߾���������
SELECT * FROM dept d,emp e WHERE d.deptno=e.deptno(+);/*�����ӣ���ȫ����Ķ�������'+'*/

SELECT E.EMPNO, E.ENAME, E1.EMPNO, E1.ENAME
  FROM EMP E, EMP E1
 WHERE E.MGR= E1.EMPNO(+);

/* join �൱�ڡ���������  on �൱��where*/
SELECT * FROM emp e JOIN dept d ON e.deptno=d.deptno;


/*���麯��*/

SELECT COUNT(empno) empnum FROM emp;

SELECT ename FROM emp e WHERE e.sal=(SELECT MIN(sal) FROM emp);/*min��������ֱ�ӷ��ڵȺŵĺ��棬Ӧ����Ϊһ����ѯ�������*/
/*max()   ͬ�� */

/*avg()ƽ������*/
SELECT ROUND(AVG(sal)) avsal FROM emp;/*��������ĺ�������Ƕ�� ƽ������*/ /*ȡ������  trunc */
SELECT MOD(SUM(sal),32)FROM emp WHERE emp.deptno=20;/*ȡ�ຯ��Ƕ��һ����ͺ���*/


SELECT *  FROM emp ORDER BY deptno;

SELECT COUNT(empno) FROM emp GROUP BY(deptno);
SELECT AVG(sal)abgsal,COUNT(empno) ,deptno FROM emp GROUP BY(deptno);

/*ORACLE�в���ʶ������*/
/*����ͳ�Ƶ�ʱ����������з��麯�����⣬����б�����group by ������У�Ҳ����˵�����е���ǰ�������
����û�е�ǰ����Բ�������*/

SELECT COUNT(*),deptno FROM emp GROUP BY deptno;/*group by ����ǰ����еĽ���������ں����group by ���ж���*/
SELECT COUNT(*) FROM emp;
SELECT COUNT(*), d.deptno ,d.dname FROM emp e,dept d WHERE e.deptno=d.deptno GROUP BY d.dname,d.deptno; /*group by ǰ��Ҫ������к������Ҫ�ж���*/
SELECT COUNT(*) empnum,d.deptno,d.dname FROM emp e,dept d WHERE e.deptno=d.deptno GROUP BY d.dname,d.deptno HAVING COUNT(*)>5;/*�����ŷ��飬���Ҳ�����������5��*/


/*���ƽ�����ʴ���2000 �Ĳ��� */
/*SELECT AVG(sal),d.dname FROM emp e,dept d GROUP BY d.dname HAVING AVG(sal)>2000;*/
/*SELECT AVG(sal),d.dname FROM emp e,dept d WHERE e.deptno=d.deptno GROUP BY d.dname HAVING AVG(sal)>2000;*/
SELECT AVG(sal),e.deptno FROM emp e,dept d WHERE e.deptno=d.deptno GROUP BY e.deptno HAVING AVG(sal)>2000;
SELECT AVG(sal),e.deptno FROM emp e,dept d GROUP BY e.deptno HAVING AVG(sal)>2000;

/*��ʾ��������Ա���������Լ�����ͬһ������Ա�����¹��ʵ��ܺͣ�
����Ҫ�������ͬһ�����¹����ܺʹ���5000��������¹����ܺ͵��������С�*/
 SELECT e.job,SUM(e.sal) FROM emp e WHERE e.job!='SALESMAN'GROUP BY e.job HAVING SUM(e.sal)>5000 ;
 
/*Ƕ���Ӳ�ѯ*/
SELECT e1.empno,e1.ename FROM emp e1 WHERE e1.sal >(SELECT e.sal FROM emp e WHERE e.empno='7654');/*һ����ѯ�����Ϊ����һ����������*/

/*��ѯ���ȹ�Ա7654�Ĺ��ʸߣ�ͬʱ���º�7788�Ĺ���һ����Ա��*/

SELECT * FROM emp e WHERE e.sal>(SELECT e1.sal FROM emp e1 WHERE e1.empno=7654) AND e.job=(SELECT e2.job FROM emp e2 WHERE e2.empno=7788);

/* Ҫ���ѯÿ�����ŵ���͹��ʺ���͹��ʵĹ�Ա�Ͳ������� */

/* SELECT * FROM emp e2 WHERE e2.sal=(SELECT MIN(e.sal) ,e.deptno FROM emp e GROUP BY e.deptno) a */
SELECT e.sal, e.ename,d.dname FROM emp e,dept d,(SELECT MIN(e.sal)minsal ,e.deptno FROM emp e GROUP BY e.deptno)a WHERE e.sal=a.minsal AND e.deptno=d.deptno;

/*��ѯ�������к�ÿ��������͹��ʵ�Ա��������ȵ��� */
--in�ؼ��־���Ҫ��ʹ�ã���Ϊ���ܱȽϵͣ�����ʹ��exists�����棬�������ܱȽϸ�
SELECT * FROM emp e WHERE e.sal IN (SELECT MIN(e1.sal) FROM emp e1 GROUP BY e1.deptno); 

/*exists��not exists*/
/*exists ���Ӳ�ѯ����0 ���ʾ�������ʽ��false�������0 ��Ϊtrue һ��exists�Ӳ�ѯһ��Ҫ������ѯ������ѯ*/
SELECT * FROM dept d WHERE NOT EXISTS(SELECT * FROM emp e WHERE e.deptno=d.deptno);/*��ѯ����Ա���Ĳ���*/
/*union �����������������ظ��С�   ȥ���ظ�������*/
SELECT * FROM emp e WHERE e.sal>1000
UNION
SELECT * FROM emp e1 WHERE e1.sal>2000;

/*union all ��ȥ�أ�ֻ�ǽ���������������*/
SELECT * FROM emp e WHERE e.sal>1000
UNION ALL
SELECT * FROM emp e1 WHERE e1.sal>2000;

/*Ҫ�ϲ����е���������Ҫ����һ�£��������Բ�һ�£������ϲ�����������һ��*/


/*
insert into ����������������������values(......);
update ���� set ����������=������������������where ����
delete from ���� where ���� ��from����ʡ�ԣ���������mysql�в�����ʡ�ԣ�
*/

CREATE TABLE myemp AS SELECT * FROM emp;

/*����*/
SELECT * FROM myemp;
---��ɾ�Ķ�Ҫ���������������ύ�����ݿ��е����ݲſ��������ĸı䡣
DELETE FROM myemp m WHERE m.empno=1234;
COMMIT;
INSERT INTO myemp(empno,ename,job ) VALUES(1234,'chjg','boss');
COMMIT;
INSERT INTO myemp(empno,ename,job) VALUES(1235,'chjg1','boss');
COMMIT;

DELETE FROM myemp WHERE empno=1234
ROLLBACK;
/*update�޸����ݵ�ʱ�����ݻᱻ��ס��*/

/*add �����
alter table persion add(address varchar2(50));

modify �޸���
alter table persion modify(address varchar2(5));
*/

/*�������*/
CREATE TABLE person(
ID NUMBER(10),
p_name VARCHAR(20),
age NUMBER(3),
birthday DATE,
address VARCHAR(50)
)

SELECT * FROM persion;

ALTER TABLE persion MODIFY(address VARCHAR2(50));

INSERT INTO persion VALUES(1,'chjg',21,to_date('1996-02-10','yyyy-mm-dd'),'xian');

/* �ضϱ� truncate û��ȷ�ϣ����ܻع� 
delete person ��
truncate table person ��
*/
  /*check key ���Լ��

  create table person(
  pid number(4),
  gender number(1)��
  constraint person_check_ck check��gender in��1,2����  /* constraint  �����Ǽ��ı���*/
  )
  */

/*

create table order_detail(
       detail_id      number(10) ,
       order_id   number(10),
       item_name  varchar2(10),
       quantity   number(10),
      constraint order_detail_detail_id_pk primary key(detail_id),
      constraint order_detail_order_id_fk foreign key(order_id) references orders(order_id)
);

*/

/*rownum ��ҳ
rownum ��֧�ִ��ں�
*/

SELECT ROWNUM,t.* FROM emp t WHERE ROWNUM <6;

/*��ҳ����
1.��ѯȫ��������
2.�õ�һ�εĽ������Ϊһ�ű��޶�������rownum < �����кţ������Ҫ��rownum��Ϊ�����
3.�Եڶ����Ľ������Ϊһ�ű��޶������ǵڶ�����rownum�д��ڿ�ʼ�кţ��������*
*/

SELECT * FROM (SELECT ROWNUM rw,a.* FROM (SELECT * FROM emp) a WHERE ROWNUM<11) b WHERE b.rw>6;

/*��ͼ�����Ƿ�װһ�����ӵ����

create view as ���

grant connect,resource,dba to scott; //sys�û���scott�û�����Ȩ��
*/
SELECT * FROM emp e WHERE e.deptno=20;
---������ͼ
/*������ͼ��ʱ���ѯ��sql�������ظ�������*/
CREATE VIEW view_20 AS SELECT * FROM emp e WHERE e.deptno=20;

select * from view_20;/*�����ѯ*/
--�����͸�����ͼ
CREATE OR REPLACE VIEW view_d20 AS SELECT * FROM myemp t WHERE t.deptno=20;

SELECT  * FROM emp;
/*�޸���ͼ��ʵ���޸Ķ�Ӧ�ı��е����ݣ�������ͼ�������޸�*/
UPDATE view_d20 t SET t.ename='ʷ��˹' WHERE t.empno=7369;

SELECT * FROM myemp;

/*����ֻ����ͼ*/

CREATE OR REPLACE VIEW view_a20 AS SELECT * FROM myemp e WHERE e.deptno=20 WITH READ ONLY; 

UPDATE view_a20 t SET t.ename='ʷ��˹' WHERE t.empno=7369; 

/*����
���в�û�а��κεı��������ǿ��Ը��κα�ʹ�á�
*/
CREATE SEQUENCE seqpersonid;
--��һ��ֵ
SELECT seqpersonid.nextval FROM dual;
---��ǰ��ֵ
SELECT seqpersonid.currval FROM dual;
SELECT * FROM person;
INSERT INTO person VALUES(seqpersonid.nextval,'kkkk',23,to_date('1998-02-10','yyyy-mm-dd'),'shanxi');
/*��������һ�����ݽṹ�����Խ���io�Ĵ��� 
create index ������ on ������������
*/

/*plsql
sql���ԵĴ����֧����
DECLARE
pname varchar2(10);
BEGIN
  pname :='zhangsan';
  dbms_output.put_line(pname);
EXCEPTION

END;
*/
/*
������������
*/
DECLARE
pname varchar2(10);
page NUMBER(3):=20;
BEGIN
  pname :='zhangsan';
  dbms_output.put_line(pname);
  dbms_output.put_line(page);
END;

/*������������*/
DECLARE
pname myemp.ename%TYPE;
BEGIN
  SELECT t.ename INTO pname FROM myemp t WHERE t.empno=7369;
  dbms_output.put_line(pname);
  END;
  /*��¼�ͱ�������Ӧjava�еĶ���������*/
  
  DECLARE
prec myemp%ROWTYPE;
BEGIN
  SELECT * INTO prec FROM myemp t WHERE t.empno=7369;
  dbms_output.put_line(prec.ename ||'    '||prec.sal);
  END;
  
/*
if ��֧
  1.
if ���� then ���1��
  ���2��
  end if ��
2.
if ���� then �������1��
  else �������2
    
3.
if ���� then �������1��
  elsif �������2 then
  else
    ���
    end if��
    end
*/

DECLARE 
pnum NUMBER(4):=&NUM;
BEGIN
  IF pnum<5 THEN 
    dbms_output.put_line('С��5');
    END IF;
    END;
    
    
    
    
DECLARE 
pnum NUMBER(4):=&NUM;
BEGIN
  IF pnum=1 THEN 
    dbms_output.put_line('����1');
    ELSE
      dbms_output.put_line('�Ҳ���1');
      END IF;
    END;
    
    
DECLARE 
pnum NUMBER(4):=&NUM;
BEGIN
  IF pnum=1 THEN 
    dbms_output.put_line('����1');
    ELSIF pnum=2 THEN 
      dbms_output.put_line('����2');
      ELSE
        dbms_output.put_line('����');
      END IF;
    END;
    
    
    /* loop ѭ��
    declare
     begin 
       while ������� loop
	
end loop;

    
    */
    
    DECLARE
    total NUMBER(4):=0;
    BEGIN
      while  total<100 LOOP
	    total:=total+1;
      dbms_output.put_line(total);
end loop;
END;

/*�α��൱��java�еļ���
�����ַ���һ��Ҫ��||˫����

*/
DECLARE
CURSOR c1 IS SELECT * FROM emp;
prec emp%ROWTYPE;
BEGIN
  OPEN c1;
  LOOP
    FETCH c1
    INTO prec;
    EXIT WHEN c1%NOTFOUND;
    dbms_output.put_line(prec.empno||'  '||prec.ename);
    END LOOP;
    CLOSE c1;
    END;
    


/*�洢����   һ��sql��伯 procedure     ������ύҪ���ڵ��ö�����*/
----�����ж������ֵ��ʹ���������
CREATE OR REPLACE  PROCEDURE helloworld AS
BEGIN 
  dbms_output.put_line('hello,world');
  END;

/*���Դ洢���� */
BEGIN 
helloworld;
  END;


/*�洢����function �з���ֵ*/

