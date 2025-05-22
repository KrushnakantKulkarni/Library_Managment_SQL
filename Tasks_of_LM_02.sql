select * from books ;
select * from branch ;
select * from members ;
select * from employees;
select * from issued_status ;
select * from return_status ;

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 

select * from books ;

INSERT INTO books (isbn,book_title,category,rental_price,status,author,publisher) 
values('978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00,'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

--Task 2. Update an Existing Member's Address

select * from members;

update members
set member_address = '172 Main St'
where member_id = 'C119';

--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
delete from issued_status
where issued_id = 'S121';

--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select * from issued_status where issued_emp_id='E101';

--Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_emp_id ,count(issued_book_name)
from issued_status
group by issued_emp_id
having  count(issued_book_name)  > 1 ;

-- CTAS (Create Table As Select)
--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

select * from book_issued_cnt ;

--Data Analysis & Findings
--The following SQL queries were used to address specific questions:

--Task 7. Retrieve All Books in a Specific Category:

select * from books
where category = 'Dystopian';

--Task 8: Find Total Rental Income by Category:
select category,sum(rental_price)
from books
group by category;

--Task 9: List Members Who Registered in the Last 180 Days:
select * from members
where reg_date >=Current_Date - interval'180 days';

--Task 10: List Employees with Their Branch Manager's Name and their branch details:
select * from branch
select * from employees

select e.emp_name,
e.position,
b.manager_id,
b.branch_address,
b.branch_address,
b.contact_no,
e1.emp_name as manager_name 
from employees as e
join branch as b 
on e.branch_id = b.branch_id
left join employees as e1 
on e1.emp_id = b.manager_id ;

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

create table books_rental_price as
select * from books
where rental_price > 6.00 ;

select * from books_rental_price ;

--Task 12: Retrieve the List of Books Not Yet Returned
select * from issued_status as iss
left join return_status as rs
on iss.issued_id = rs.issued_id 
where rs.return_id is null;

--Task 13: Identify Members with Overdue Books
--Write a query to identify members who have overdue books (assume a 360-day return period).
--Display the member's_id, member's name, book title, issue date, and days overdue.

select * from books
select * from members
select * from issued_status 
select * from return_status 

 
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
--Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned,
--and the total revenue generated from book rentals.
select * from branch 
SELECT * from books
select * from members
select * from issued_status 
select * from return_status

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
join
branch as b
on e.branch_id = b.branch_id
LEFT join
return_status as rs
on rs.issued_id = ist.issued_id
join 
books as bk
on ist.issued_book_isbn = bk.isbn
group by 1 , 2;

select * from branch_performance ;

--Task 15: CTAS: Create a Table of Active Members
--Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
--containing members who have issued at least one book in the last 2 months.

