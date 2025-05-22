
# Library_Managment_SQL
📚 Library Management System using SQL
this project is a simple yet structured implementation of a library management system using sql. it covers table creation, relationships among entities, and a series of practical tasks like data insertion, updates, and reporting using queries. this system is intended to showcase database design, normalization, and querying skills for academic or portfolio purposes.

📌 schema design
the database includes the following tables:

branch

employees

books

members

issued_status

return_status

they are interconnected with appropriate foreign key constraints to ensure referential integrity.

🧠 sql concepts used in the project
this library management system project showcases a comprehensive use of various sql operations essential for relational database design and management. below is the list of key sql concepts used:

create database and create table: to create the database and define schema structure

data types: used to define the kind of data each column can store (e.g., varchar, int, date, float)

primary key and foreign key constraints: ensure data uniqueness and establish table relationships

insert into: to add new records into tables such as books, members, etc.

update: used to modify existing data (e.g., updating member addresses)

delete from: to remove records (e.g., deleting a book issue entry)

select: retrieves data from the tables

where: filters records based on conditions (e.g., books in a specific category)

group by: groups data for aggregation (e.g., count of books issued by each employee)

having: filters grouped records (e.g., employees who issued more than one book)

order by: sorts data in ascending or descending order

joins:

inner join: fetches records with matching values in both tables

left join: fetches all records from one table and matching records from the other

ctas (create table as select): creates new tables based on query results (e.g., book_issued_cnt, branch_performance)

date functions:

current_date: gets the current date

interval: used for calculating date differences (e.g., members registered in the last 180 days)

count, sum: used for aggregating numerical data (e.g., total revenue, count of books)

this wide variety of sql operations not only handles basic data manipulation but also supports advanced analytics and reporting needed in a functional library management system.

![Screenshot 2025-05-15 221815](https://github.com/user-attachments/assets/9f0b40d4-cb8c-445e-af8c-0bdae41f07b0)

⚙️ schema.sql
```sql

-- Create Database
CREATE DATABASE databasename;

-- Create branch table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
    branch_id VARCHAR(5) PRIMARY KEY,
    manager_id VARCHAR(5),
    branch_address VARCHAR(11),
    contact_no VARCHAR(10)
);

-- Create employees table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(50),
    position VARCHAR(20),
    salary INT,
    branch_id VARCHAR(15)
);

-- Create books table
DROP TABLE IF EXISTS books;
CREATE TABLE books (
    isbn VARCHAR(25) PRIMARY KEY,
    book_title VARCHAR(100),
    category VARCHAR(50),
    rental_price FLOAT,
    status VARCHAR(25),
    author VARCHAR(50),
    publisher VARCHAR(50)
);

-- Create members table
DROP TABLE IF EXISTS members;
CREATE TABLE members (
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(25),
    member_address VARCHAR(75),
    reg_date DATE
);

-- Create issued_status table
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status (
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10),
    issued_book_name VARCHAR(75),
    issued_date DATE,
    issued_book_isbn VARCHAR(25),
    issued_emp_id VARCHAR(10)
);

-- Create return_status table
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status (
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10),
    return_book_name VARCHAR(75),
    return_date DATE,
    return_book_isbn VARCHAR(20)
);

-- Creating relationships between tables

ALTER TABLE issued_status
    ADD CONSTRAINT FK_members
    FOREIGN KEY (issued_member_id)
    REFERENCES members(member_id);

ALTER TABLE issued_status
    ADD CONSTRAINT FK_books
    FOREIGN KEY (issued_book_isbn)
    REFERENCES books(isbn);

ALTER TABLE issued_status
    ADD CONSTRAINT FK_employee
    FOREIGN KEY (issued_emp_id)
    REFERENCES employees(emp_id);

ALTER TABLE employees
    ADD CONSTRAINT FK_branch
    FOREIGN KEY (branch_id)
    REFERENCES branch(branch_id);

ALTER TABLE return_status
    ADD CONSTRAINT FK_issued_status
    FOREIGN KEY (issued_id)
    REFERENCES issued_status(issued_id);
 


🧪 tasks.sql

select * from books ;
select * from branch ;
select * from members ;
select * from employees;
select * from issued_status ;
select * from return_status ;

--Task 1. Create a New Book Record
INSERT INTO books (isbn,book_title,category,rental_price,status,author,publisher) 
values('978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00,'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

--Task 2. Update an Existing Member's Address
update members
set member_address = '172 Main St'
where member_id = 'C119';

--Task 3: Delete a Record from the Issued Status Table
delete from issued_status
where issued_id = 'S121';

--Task 4: Retrieve All Books Issued by a Specific Employee
select * from issued_status where issued_emp_id='E101';

--Task 5: List Members Who Have Issued More Than One Book
select issued_emp_id ,count(issued_book_name)
from issued_status
group by issued_emp_id
having  count(issued_book_name)  > 1 ;

--Task 6: Create Summary Tables (CTAS)
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

--Task 7. Retrieve All Books in a Specific Category
select * from books where category = 'Dystopian';

--Task 8: Find Total Rental Income by Category
select category,sum(rental_price)
from books
group by category;

--Task 9: List Members Who Registered in the Last 180 Days
select * from members
where reg_date >=Current_Date - interval'180 days';

--Task 10: List Employees with Their Branch Manager's Name and their branch details
select e.emp_name,
e.position,
b.manager_id,
b.branch_address,
b.contact_no,
e1.emp_name as manager_name 
from employees as e
join branch as b 
on e.branch_id = b.branch_id
left join employees as e1 
on e1.emp_id = b.manager_id ;

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold
create table books_rental_price as
select * from books
where rental_price > 6.00 ;

--Task 12: Retrieve the List of Books Not Yet Returned
select * from issued_status as iss
left join return_status as rs
on iss.issued_id = rs.issued_id 
where rs.return_id is null;

--Task 13: Identify Members with Overdue Books
select 
    m.member_id,
    m.member_name,
    ist.issued_book_name,
    ist.issued_date,
    (CURRENT_DATE - ist.issued_date) as overdue_days
from issued_status as ist
join members as m 
    on m.member_id = ist.issued_member_id
join books as b 
    on b.isbn = ist.issued_book_isbn
left join return_status as rs 
    on ist.issued_id = rs.issued_id
where rs.return_date is null
  and (CURRENT_DATE - ist.issued_date) > 360;

--Task 14: Branch Performance Report
create table branch_performance as
select
b.manager_id,
b.branch_id,
count(ist.issued_book_isbn) as count_issued_books,
count(rs.return_id) as count_returned_books,
sum(bk.rental_price) as total_revenue
from issued_status as ist
join employees as e
on e.emp_id = ist.issued_emp_id
join branch as b
on e.branch_id = b.branch_id
LEFT join return_status as rs
on rs.issued_id = ist.issued_id
join books as bk
on ist.issued_book_isbn = bk.isbn
group by 1 , 2;



 Conclusion
This Library Management System using SQL is more than just a database project—it is a showcase of real-world SQL application that highlights your ability to design, manage, and query a relational database system effectively. Ideal for students, job seekers, and developers building a strong portfolio in backend and database management
