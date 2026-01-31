USE practice_sql;
-- 1.  Count the customer base based on customer type to identify current customer preferences and sort them in descending order
SELECT Customer_Type, Count(*) AS `Number of Customers`
FROM customer
GROUP BY Customer_Type
ORDER BY `Number of Customers` DESC;

-- 2.  Count the customer base based on their status of payment in descending order. 
SELECT Payment_Status, COUNT(*) AS `Customer payment status` 
FROM payment_details
GROUP BY  Payment_Status
ORDER BY `Customer payment status` DESC ; 

-- 3. Count the customer base based on their payment mode in descending order of count.
 SELECT Payment_Mode, COUNT(*) AS `Customer_count` 
FROM payment_details
GROUP BY  Payment_Mode
ORDER BY COUNT(*) DESC ; 

-- 4. Count the customers as per shipment domain in descending order. 
SELECT Shipment_Domain , COUNT(*) AS `Customer_count` 
FROM shipment_details 
GROUP BY  Shipment_Domain
ORDER BY COUNT(*) DESC ; 

-- 5. Count the customer according to service type in descending order of count 
SELECT Service_Type , COUNT(*) AS `Customer_count` 
FROM shipment_details 
GROUP BY  Service_Type
ORDER BY COUNT(*) DESC ; 

-- 6. Explore employee count based on the designation-wise count of employees' IDs in descending order
SELECT Emp_Designation, COUNT(Employee_ID) AS `employee_count`
FROM employee_details
GROUP BY Emp_Designation 
ORDER BY COUNT(Employee_ID) DESC ; 

-- 7. Branch-wise count of employees for efficiency of deliveries in descending order. 
SELECT Emp_Branch, COUNT(*) AS `employee_count`
FROM employee_details
GROUP BY Emp_Branch 
ORDER BY COUNT(*) DESC ; 

-- 8. Finding C_ID, M_ID, and tenure for those customers whose membership is over 10 years.
SELECT m.Membership_ID, c.Customer_ID,
TIMESTAMPDIFF(YEAR, m.Start_date, m.End_date) AS TENURE 
FROM customer c
JOIN membership m 
USING (Membership_ID)
WHERE TIMESTAMPDIFF(YEAR, m.Start_date, m.End_date) >10 
ORDER BY TENURE DESC;

-- 9. Considering average payment amount based on customer type having payment mode as COD in descending order. 
SELECT c.Customer_Type, 
AVG(p.Amount) AS `average_payment_amount`
FROM customer c 
JOIN payment_details p 
USING ( Customer_ID) 
WHERE p.Payment_Mode = "COD" 
GROUP BY c.Customer_Type 
ORDER BY AVG(p.Amount) DESC; 

-- 10. Calculate the average payment amount based on payment mode where the payment date is not null. 
SELECT Payment_Mode, AVG(Amount) AS `average_payment_amount` 
FROM payment_details 
WHERE Payment_Date IS NOT NULL 
GROUP BY Payment_Mode ; 

-- 11. Calculate the average shipment weight based on payment_status where shipment content does not start with "H." 
SELECT p.Payment_Status, 
AVG(s.Shipment_Weight) as `average_shipment_weight` 
FROM payment_details p
JOIN shipment_details s
USING (Shipment_ID) 
WHERE s.Shipping_Content NOT LIKE 'H%'
GROUP BY p. Payment_Status;

-- 12. Retrieve the names and designations of all employees in the 'NY' E_Branch
SELECT Emp_Name,
Emp_Designation
FROM employee_details
WHERE Emp_Branch = 'NY'; 

-- 13. Calculate the total number of customers in each C_TYPE (Wholesale, Retail, Internal Goods). 
SELECT Customer_Type, Count(*) AS `Number of Customers`
FROM customer
GROUP BY Customer_Type;

-- 14. Find the membership start and end dates for customers with 'Paid' payment status.
SELECT m.Start_date, m.End_date, p.Payment_Status
FROM payment_details p
JOIN customer c 
USING ( Customer_ID) 
JOIN membership m 
USING (Membership_ID)
WHERE p.Payment_Status = 'Paid'; 

-- 15. List the clients who have made 'Card Payment' and have a 'Regular' service type.
SELECT c.Customer_Name, 
c.Customer_ID
FROM customer c 
JOIN payment_details p 
USING ( Customer_ID) 
JOIN shipment_details s
USING ( Customer_ID) 
WHERE p.Payment_Mode = 'Card Payment' AND 
s.Service_Type = 'Regular' ; 

-- 16. Calculate the average shipment weight for each shipment domain (International and Domestic).
SELECT Shipment_Domain, 
ROUND(AVG(Shipment_Weight),0) AS `Average_Shipment_Weight` 
FROM shipment_details 
GROUP BY Shipment_Domain ; 

-- 17. Identify the shipment with the highest charges and the corresponding client's name.
SELECT s.Shipment_Charges, s.Shipment_ID, c.Customer_Name
FROM shipment_details s 
JOIN customer c
USING ( Customer_ID) 
ORDER BY s.Shipment_Charges DESC 
LIMIT 1 ; 

-- 18. Count the number of shipments with the 'Express' service type that are yet to be delivered.
SELECT sh.Service_Type, COUNT(*) AS `Express_not_delivered`
FROM shipment_details sh
JOIN status_sh s 
USING (Shipment_ID) 
WHERE sh.Service_Type = 'Express' AND s.Current_Status = 'NOT DELIVERED' 
GROUP BY sh.Service_Type ;  

-- 19. List the clients who have 'Not Paid' payment status and are based in 'CA'.
SELECT c.Customer_ID, c.Customer_Name, c.Customer_Address
FROM customer c
JOIN payment_details p
USING (Customer_ID) 
WHERE c.Customer_Address LIKE '%CALIFORNIA%' AND p.Payment_Status = 'NOT PAID' ; 

-- 20. Retrieve the current status and delivery date of shipments managed by employees with the designation 'Delivery Boy'.
SELECT  s.Shipment_ID, s.Current_Status, s.Delivery_date 
FROM status_sh s
JOIN employee_manages_shipment em
USING ( Shipment_ID)
JOIN employee_details ed
USING (Employee_ID) 
WHERE ed.Emp_Designation = 'Delivery Boy' 
ORDER BY s.Delivery_date ; 

-- 21. Rank customers by total revenue contribution within each customer type
SELECT
    Customer_Type,
    Customer_ID,
    Customer_Name,
    total_revenue,
    DENSE_RANK() OVER (
        PARTITION BY Customer_Type
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM (
    SELECT
        c.Customer_Type,
        c.Customer_ID,
        c.Customer_Name,
        SUM(p.Amount) AS total_revenue
    FROM customer c
    JOIN payment_details p
        ON c.Customer_ID = p.Customer_ID
    GROUP BY
        c.Customer_Type, c.Customer_ID,
        c.Customer_Name) t ;

-- 22. Identify customers whose average payment is above the overall average 
SELECT c.Customer_Name,
AVG(p.Amount) AS avg_amount
FROM customer c
JOIN payment_details p 
USING ( Customer_ID) 
GROUP BY c.Customer_Name
HAVING AVG(p.Amount) > (
    SELECT AVG(Amount)
    FROM payment_details )
ORDER BY avg_amount DESC; 

-- 23. Calculate shipment delivery delay in days and flag delayed shipments 
SELECT Shipment_ID,
timestampdiff(DAY, Sent_date, Delivery_date) as delivery_delay ,
CASE
        WHEN TIMESTAMPDIFF(DAY, Sent_date, Delivery_date) > 3
            THEN 'Delayed'
        ELSE 'On Time'
    END AS delivery_status
FROM status_sh
WHERE Delivery_date IS NOT NULL; 








 