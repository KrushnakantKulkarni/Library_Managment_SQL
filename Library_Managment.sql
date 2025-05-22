--Create Database 

create database databasename;

--Create a branch Table
DROP TABLE IF EXISTS branch ; 
CREATE TABLE branch
    (
	 branch_id varchar(5) PRIMARY KEY,
	 manager_id  varchar (5),
	 branch_address varchar(11),
	 contact_no varchar(10)
	 );

--create Employees Table
DROP TABLE IF EXISTS employees ;
CREATE TABLE employees
     (
         emp_id	varchar (10) PRIMARY KEY,
		 emp_name varchar (50),
		 position varchar (20),
		 salary	int,
		 branch_id varchar (15) --FK
	 )

--crete Table books
DROP TABLE IF EXISTS books;
CREATE TABLE books
     (
         isbn varchar(25) PRIMARY KEY,
		 book_title	varchar(100),
		 category varchar(50),
		 rental_price float,
		 status	varchar(25),
		 author	varchar(50),
		 publisher varchar(50)
     ) ;

--Create table members
DROP TABLE IF EXISTS members ;
CREATE TABLE members
     ( 
	 member_id varchar(10) PRIMARY KEY,
	 member_name	varchar(25),
	 member_address	 varchar(75),
	 reg_date DATE
	  );

--create table 
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
     (
	 issued_id varchar(10) PRIMARY KEY, --FK
	 issued_member_id varchar(10)	, --FK
	 issued_book_name varchar(75) ,
	 issued_date date ,
	 issued_book_isbn varchar(25) , --FK
	 issued_emp_id varchar(10) --FK
	 )
-- Create Table 
DROP TABLE IF EXISTS return_status ;
CREATE TABLE return_status
     ( 
	 return_id varchar(10) PRIMARY KEY,
	 issued_id	varchar(10) ,
	 return_book_name	varchar(75) ,
	 return_date date,
	 return_book_isbn varchar(20) 
	 )

--Creating relationship between them
---issued_status ---to---- members
alter table issued_status
add constraint FK_members
foreign key (issued_member_id)
references members(member_id) ;

---issued_status--to----books
alter table issued_status
add constraint FK_books
foreign key (issued_book_isbn)
references books(isbn) ;

---issued_status--to---employees
alter table issued_status
add constraint FK_employee
foreign key (issued_emp_id)
references employees(emp_id) ;

---employees--to----branch
alter table employees
add constraint FK_branch
foreign key (branch_id)
references branch(branch_id);

----return_status--to----issued_status
alter table return_status
add constraint FK_issued_status
foreign key (issued_id)
references issued_status(issued_id) ; 

