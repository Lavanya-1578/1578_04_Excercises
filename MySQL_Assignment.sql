use training
show tables
create table demography
 (CustID  int(11) not null auto_increment,
  Name varchar(20) ,
  Age int(11) ,
  Gender varchar(1),
  constraint cust_key primary key (CustID)
 );
 
 insert into demography values(1,'John',25,'M');
 insert into demography values(2,'Pawan',26,'M'),(3,'Hema',31,'F');

insert into demography(Name,Gender) values('Rekha','F'); 

select * from demography;

update demography set Age=NULL where custid=1;

select * from demography where age is null

truncate table demography

drop table demography

---------------------------------------------



select account_id,cust_id,avail_balance from account where status='ACTIVE' and avail_balance>2500

select * from account where year(open_date)=2002;

select account_id ,avail_balance,pending_balance from account where avail_balance!=pending_balance

select account_id,product_cd from account where account_id in(1,10,23,27)

select account_id,avail_balance from account where avail_balance between 100 and 200
---------------------------------------------------------------------------------------------

select count(*) from account

select * from account limit 2;

select * from account limit 3,2;

desc individual
select year(birth_date),month(birth_date),day(birth_date),weekday(birth_date) from individual
select substr('Please find the substring in this string',17,9) 
select abs(-25.76823),-25.7623,round(-25.7623,2)
select current_date + interval 30 day
select substr(fname,1,3),substr(lname,-3,3),fname,lname from individual
select upper(fname) from individual where length(fname)=5
desc account
select max(avail_balance),avg(avail_balance) from account where cust_id=1
--------------------------------------------------------------------------------
select count(1),cust_id from account group by cust_id having count(1)>2

select distinct a.cust_id from account as a where a.cust_id in (select cust_id from account group by cust_id having 
count(cust_id)>2)
select fname,birth_date from individual order by birth_date desc
desc account
select count(1),year(open_date),avg(avail_balance) from account 
group by year(open_date) having avg(avail_balance)>200 order by year(open_date) asc
select product_cd,max(pending_balance) from account where product_cd in(select product_cd from 
account where product_cd in('CHK','SAV','CD') group by product_cd) group by product_cd
-----------------------------------------------------
select a.fname,a.title,b.name from employee a inner join department b on (a.dept_id=b.dept_id) 
select a.name,b.name from product a left join product_type b on(a.product_type_cd=b.product_type_cd)
select concat(e1.fname," ",e1.lname),e.fname from employee e inner join employee e1 on e.emp_id=e1.superior_emp_id 
select fname,lname from employee as e where superior_emp_id in (select emp_id from employee where fname='Susan ' and lname='Hawthorne')
desc employee
select fname,lname from employee e where dept_id in(select dept_id from department where dept_id=1) and 
emp_id in (select superior_emp_id from employee group by  superior_emp_id having count(superior_emp_id)>1)

  