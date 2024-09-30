# Blood Bank Management System

## Project Overview
This Blood Bank Management System is a SQL-based project developed as part of our Database Management System course. The system is designed to efficiently manage blood donation processes, donor information, inventory tracking, and hospital interactions for a blood bank.

## Team Members
- Yash Vikram Solanki
- Maiitra Nischal Patel
- Khushi SanjivBhai Patel 

## Database Design
### ER Diagram
We have created a comprehensive Entity-Relationship (ER) diagram that illustrates the relationships between various entities in our blood bank system, such as donors, blood units, recipients, hospitals, and donation camps.

### Normalization
The database schema has been normalized to reduce data redundancy and improve data integrity. We have applied normalization techniques up to the Third Normal Form (3NF) to ensure efficient data storage and minimize anomalies.

## Database Objects

### Tables
1. Check_ups
2. Donor
3. Donor_Contact
4. Nurse
5. Nurse_Contact
6. Blood
7. Blood_Donation_Camp
8. Camp_Contact
9. Bank_Blood_Type
10. Orders
11. Blood_Bank
12. Hospital
13. Hospital_Contact
14. Hospital_Email
15. Patient
16. Patient_Contact

### Procedures
1. Check_Blood_Availability
2. get_blood_counts
3. percentage_donation
4. display_available_blood_bags

### Functions
1. Duration_Of_Camp
2. FindAge
3. get_camp_total_donations
4. get_donor_total_donations

### Triggers
1. eligibility
2. prevent_donor_deletion
3. enforce_blood_bank_capacity
4. check_issue_date
5. check_blood_quantity
6. check_donor_eligibility

### Packages
1. Blood_Bank_Package
2. Hospital_Package

## Technologies Used
- Database: Oracle Database
- SQL Developer: For database management and query execution

## How to Use
1. Install Oracle Database and SQL Developer
2. Execute the provided DDL commands to create the database schema
3. Run the procedures, functions, triggers, and package creation scripts
4. Use the provided SQL files to manage and retrieve information about donors, blood units, hospitals, and patients

## Key Features
- Efficient management of blood donation camps
- Tracking of donor eligibility and donation history
- Hospital and patient management
- Blood inventory tracking
- Automated checks for blood availability and donor eligibility
