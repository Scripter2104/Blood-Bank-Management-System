REM   Script: Maiitra
REM   blood bank

CREATE TABLE Check_ups ( 
    Vol_ID INT PRIMARY KEY, 
    First_Name VARCHAR(50), 
    Middle_Name VARCHAR(50), 
    Last_Name VARCHAR(50), 
    Weight DECIMAL(5,2), 
    DOB DATE 
);

CREATE TABLE Blood_Bank ( 
    Blood_Bank_ID NUMBER PRIMARY KEY, 
    BB_Name VARCHAR2(50), 
    BB_Location VARCHAR2(100), 
    Capacity NUMBER 
);

CREATE TABLE Bank_Blood_Type ( 
    Blood_Bank_ID NUMBER, 
    Blood_Type VARCHAR2(5), 
    Cost NUMBER(10,2), 
    PRIMARY KEY (Blood_Bank_ID, Blood_Type), 
    CONSTRAINT fk_blood_bank_2 FOREIGN KEY (Blood_Bank_ID) REFERENCES Blood_Bank(Blood_Bank_ID) 
);

CREATE TABLE Organization_Blood_Bank (
    Organization VARCHAR2(100) PRIMARY KEY,
    Blood_Bank_ID NUMBER,
    CONSTRAINT fk_Blood_Bank FOREIGN KEY (Blood_Bank_ID) REFERENCES Blood_Bank(Blood_Bank_ID)
);

CREATE TABLE Blood_Donation_Camp (
    Organization VARCHAR2(100),
    Camp_ID NUMBER,
    Location VARCHAR2(100),
    Start_Date DATE,
    End_Date DATE,
    PRIMARY KEY (Organization, Camp_ID),
    CONSTRAINT fk_Org_Blood_Donation_Camp FOREIGN KEY (Organization) REFERENCES Organization_Blood_Bank(Organization)
);;

CREATE TABLE Camp_Contact ( 
    Organization VARCHAR2(100), 
    Camp_ID NUMBER, 
    Contact_info VARCHAR2(100), 
    PRIMARY KEY (Organization, Camp_ID, Contact_info), 
    CONSTRAINT fk_blood_donation_camp_3 FOREIGN KEY (Organization, Camp_ID) REFERENCES Blood_Donation_Camp(Organization, Camp_ID) 
);

CREATE TABLE Nurse ( 
    Nurse_ID NUMBER PRIMARY KEY, 
    First_Name VARCHAR2(50), 
    Middle_Name VARCHAR2(50), 
    Last_Name VARCHAR2(50), 
    DOB DATE, 
    Organization VARCHAR2(100), 
    Camp_ID NUMBER, 
    CONSTRAINT fk_blood_donation_camp FOREIGN KEY (Organization,Camp_ID) REFERENCES Blood_Donation_Camp(Organization,Camp_ID) 
);

CREATE TABLE Nurse_Contact ( 
    Nurse_ID NUMBER, 
    Contact_info VARCHAR2(100), 
    PRIMARY KEY (Nurse_ID, Contact_info), 
    CONSTRAINT fk_nurse_contact FOREIGN KEY (Nurse_ID) REFERENCES Nurse(Nurse_ID) 
);

CREATE TABLE Donor ( 
    Donor_ID NUMBER PRIMARY KEY, 
    First_Name VARCHAR2(50), 
    Middle_Name VARCHAR2(50), 
    Last_Name VARCHAR2(50), 
    DOB DATE, 
    Nurse_ID NUMBER, 
    CONSTRAINT fk_nurse FOREIGN KEY (Nurse_ID) REFERENCES Nurse(Nurse_ID) 
);

CREATE TABLE Donor_Contact ( 
    Donor_ID NUMBER, 
    Contact_info VARCHAR2(100), 
    PRIMARY KEY (Donor_ID, Contact_info), 
    CONSTRAINT fk_donor_contact FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID) 
);

CREATE TABLE Blood (
    Donor_ID NUMBER,
    Organization VARCHAR2(100),
    Camp_ID NUMBER,
    Blood_Type VARCHAR2(5),
    Haemoglobin NUMBER(5,2),
    Red_blood_cells NUMBER(5,2),
    White_blood_cells NUMBER(5,2),
    Platelets NUMBER(5,2),
    Plazma NUMBER(5,2),
    Donation_Date DATE,
    PRIMARY KEY (Donor_ID),
    CONSTRAINT fk_donor FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID),
    CONSTRAINT fk_blood_donation_camp_2 FOREIGN KEY (Organization, Camp_ID) REFERENCES Blood_Donation_Camp(Organization, Camp_ID)
);;

CREATE TABLE Hospital ( 
    Hospital_ID NUMBER PRIMARY KEY, 
    Hospital_Name VARCHAR2(50), 
    Hos_Address VARCHAR2(100) 
);

CREATE TABLE Hospital_Contact ( 
    Hospital_ID NUMBER, 
    Contact_Info VARCHAR2(100), 
    PRIMARY KEY (Hospital_ID, Contact_Info), 
    CONSTRAINT fk_hospital_contact FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID) 
);

CREATE TABLE Hospital_Email ( 
    Hospital_ID NUMBER, 
    Hos_Email VARCHAR2(100), 
    PRIMARY KEY (Hospital_ID, Hos_Email), 
    CONSTRAINT fk_hospital_email FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID) 
);

CREATE TABLE Orders ( 
    Blood_Bank_ID NUMBER, 
    Hospital_ID NUMBER, 
    Issue_Date DATE, 
    Blood_Type VARCHAR2(25), 
    Blood_Quantity NUMBER, 
    PRIMARY KEY (Blood_Bank_ID, Hospital_ID), 
    CONSTRAINT fk_blood_bank_3 FOREIGN KEY (Blood_Bank_ID) REFERENCES Blood_Bank(Blood_Bank_ID), 
    CONSTRAINT fk_hospital FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID) 
);

CREATE TABLE Patient ( 
    Hospital_ID NUMBER, 
    Patient_ID NUMBER, 
    First_Name VARCHAR2(50), 
    Middle_Name VARCHAR2(50), 
    Last_Name VARCHAR2(50), 
    Sex CHAR(1), 
    Blood_Type VARCHAR2(5), 
    Date_Admitted DATE, 
    Date_Discharged DATE, 
    PRIMARY KEY (Hospital_ID, Patient_ID), 
    CONSTRAINT fk_hospital_2 FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID) 
);

CREATE TABLE Patient_Contact ( 
    Hospital_ID NUMBER, 
    Patient_ID NUMBER, 
    Contact_Info VARCHAR2(100), 
    PRIMARY KEY (Hospital_ID, Patient_ID, Contact_Info), 
    CONSTRAINT fk_patient_contact FOREIGN KEY (Hospital_ID, Patient_ID) REFERENCES Patient(Hospital_ID, Patient_ID) 
);

CREATE OR REPLACE FUNCTION Duration_Of_Camp(  
    Organization IN Blood_Donation_Camp.Organization%TYPE,  
    Camp_ID IN Blood_Donation_Camp.Camp_ID%TYPE  
)  
RETURN NUMBER 
IS  
    days NUMBER(4);  
BEGIN  
    SELECT End_Date - Start_Date  
    INTO days  
    FROM Blood_Donation_Camp  
    WHERE Organization = Duration_Of_Camp.Organization  
    AND Camp_ID = Duration_Of_Camp.Camp_ID;  
      
    RETURN days;  
EXCEPTION  
    WHEN NO_DATA_FOUND THEN  
        RETURN NULL;  
    WHEN OTHERS THEN  
        RETURN NULL;  
END;
/

CREATE OR REPLACE PROCEDURE Check_Blood_Availability 
( blood_type IN VARCHAR2 ) 
IS 
 
    CURSOR blood_bank_cursor IS 
        SELECT bb.BB_Name 
        FROM Blood_Bank bb 
        JOIN Bank_Blood_Type bbt ON bb.Blood_Bank_ID = bbt.Blood_Bank_ID 
        WHERE bbt.Blood_Type = blood_type; 
 
    blood_bank_name Blood_Bank.BB_Name%TYPE; 
    blood_found BOOLEAN := FALSE;  
 
BEGIN 
 
    FOR blood_bank_rec IN blood_bank_cursor LOOP 
        DBMS_OUTPUT.PUT_LINE('Blood bank with blood type ' || blood_type || ' is available: ' || blood_bank_rec.BB_Name); 
        blood_found := TRUE;  
    END LOOP; 
 
EXCEPTION 
 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('No blood banks found for blood type ' || blood_type || '.'); 
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: Multiple blood banks found for blood type ' || blood_type || '.'); 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('An error occurred while checking blood availability.'); 
 
END;
/

CREATE OR REPLACE PROCEDURE get_blood_counts  
(  
    p_blood_bank_id IN NUMBER,    
    p_blood_type    IN VARCHAR2  
)    
IS  
    v_total_count   NUMBER := 0;    
    v_camp_id       NUMBER;    
    v_organization  VARCHAR2(100);    
    v_blood_count   NUMBER; 
 
    CURSOR camp_cursor IS   
        SELECT Camp_ID, Organization    
        FROM Blood_Donation_Camp    
        WHERE Organization IN (SELECT Organization FROM Organization_Blood_Bank WHERE Blood_Bank_ID = p_blood_bank_id);   
 
    CURSOR blood_count_cursor (c_camp_id NUMBER, c_organization VARCHAR2, c_blood_type VARCHAR2) IS   
        SELECT COUNT(*) AS blood_count   
        FROM Blood    
        WHERE Camp_ID = c_camp_id    
          AND Organization = c_organization    
          AND Blood_Type = c_blood_type;   
 
BEGIN    
 
    FOR rec IN camp_cursor LOOP    
        v_camp_id := rec.Camp_ID;    
        v_organization := rec.Organization;   
           
        OPEN blood_count_cursor(v_camp_id, v_organization, p_blood_type);   
        FETCH blood_count_cursor INTO v_blood_count;  
 
        v_total_count := v_total_count + v_blood_count;  
               
        IF blood_count_cursor%NOTFOUND THEN   
            DBMS_OUTPUT.PUT_LINE('No data found for blood type ' || p_blood_type || ' in camp ID ' || v_camp_id || ' and organization ' || v_organization);   
        ELSIF blood_count_cursor%ROWCOUNT > 1 THEN   
            DBMS_OUTPUT.PUT_LINE('Error: Multiple rows found for blood type ' || p_blood_type || ' in camp ID ' || v_camp_id || ' and organization ' || v_organization);   
        ELSE   
            DBMS_OUTPUT.PUT_LINE('Total blood count for blood type ' || p_blood_type || ': ' || v_total_count);    
        END IF;   
             
        CLOSE blood_count_cursor;   
             
    END LOOP;    
 
EXCEPTION  
    WHEN NO_DATA_FOUND THEN   
        DBMS_OUTPUT.PUT_LINE('No data found for blood type ' || p_blood_type || ' in camp ID ' || v_camp_id || ' and organization ' || v_organization);   
    WHEN TOO_MANY_ROWS THEN   
        DBMS_OUTPUT.PUT_LINE('Error: Multiple rows found for blood type ' || p_blood_type || ' in camp ID ' || v_camp_id || ' and organization ' || v_organization);    
    WHEN OTHERS THEN   
        DBMS_OUTPUT.PUT_LINE('An error occurred while processing camps.');  
 
END;
/

CREATE OR REPLACE FUNCTION FindAge(date_of_birth IN DATE)  
RETURN NUMBER IS  
BEGIN  
    IF date_of_birth IS NULL THEN 
        RETURN NULL; 
    END IF; 
 
    RETURN ROUND(MONTHS_BETWEEN(SYSDATE, date_of_birth) / 12);  
EXCEPTION   
    WHEN OTHERS THEN  
        RETURN NULL;  
END;
/

CREATE OR REPLACE TRIGGER eligibility  
BEFORE INSERT ON Donor 
FOR EACH ROW 
DECLARE  
    donor_weight DECIMAL(5,2); 
    donor_date_of_birth DATE; 
    donor_age INT; 
BEGIN 
    SELECT Weight INTO donor_weight FROM Check_ups WHERE Vol_ID = :new.Donor_ID; 
    SELECT DOB INTO donor_date_of_birth FROM Check_ups WHERE Vol_ID = :new.Donor_Id; 
 
    donor_age := FindAge(donor_date_of_birth); 
 
    IF donor_age >= 18 AND donor_age <= 65 AND donor_weight >= 50 THEN 
        NULL; 
    ELSE 
        RAISE_APPLICATION_ERROR(-20000, 'Not eligible to donate blood'); 
    END IF; 
END;
/

CREATE OR REPLACE TRIGGER prevent_donor_deletion 
BEFORE DELETE ON Donor 
FOR EACH ROW 
DECLARE 
    v_blood_count NUMBER; 
BEGIN 
    SELECT COUNT(*) 
    INTO v_blood_count 
    FROM Blood 
    WHERE Donor_ID = :OLD.Donor_ID; 
 
    IF v_blood_count > 0 THEN 
        RAISE_APPLICATION_ERROR(-20002, 'Cannot delete Donor record as there are associated Blood records.'); 
    END IF; 
END;
/

CREATE OR REPLACE TRIGGER enforce_blood_bank_capacity  
BEFORE INSERT ON Orders  
FOR EACH ROW  
DECLARE  
    v_current_count NUMBER;  
    v_capacity NUMBER; 
BEGIN  
    SELECT Capacity  
    INTO v_capacity  
    FROM Blood_Bank  
    WHERE Blood_Bank_ID = :NEW.Blood_Bank_ID;  
     
    SELECT COUNT(*)  
    INTO v_current_count  
    FROM Orders  
    WHERE Blood_Bank_ID = :NEW.Blood_Bank_ID;  
  
    IF v_current_count >= v_capacity THEN  
        RAISE_APPLICATION_ERROR(-20001, 'Blood bank capacity exceeded. Cannot insert more orders.');  
    END IF;  
END; 
/

CREATE OR REPLACE TRIGGER check_issue_date 
BEFORE INSERT ON Orders 
FOR EACH ROW 
BEGIN 
    IF :NEW.Issue_Date > SYSDATE THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Issue date cannot be in the future'); 
    END IF; 
END;
/

CREATE OR REPLACE TRIGGER check_blood_quantity  
BEFORE INSERT OR UPDATE ON Orders  
FOR EACH ROW  
DECLARE  
    v_available_quantity NUMBER;  
BEGIN  
    SELECT COUNT(*) 
    INTO v_available_quantity 
    FROM Blood b 
    JOIN Blood_Bank bb ON b.Organization = bb.BB_Name 
    WHERE b.Blood_Type = :NEW.Blood_Type 
    AND bb.Blood_Bank_ID = :NEW.Blood_Bank_ID; 
 
    IF v_available_quantity = 0 OR v_available_quantity < :NEW.Blood_Quantity THEN  
        RAISE_APPLICATION_ERROR(-20001, 'Requested quantity exceeds available blood quantity for the given blood type in the Blood_Bank.');  
    END IF;  
END; 
/

CREATE OR REPLACE TRIGGER check_donor_eligibility   
BEFORE INSERT ON Blood   
FOR EACH ROW   
DECLARE   
    v_last_donation_date DATE;   
BEGIN   
    SELECT MAX(Donation_Date)   
    INTO v_last_donation_date   
    FROM Blood   
    WHERE Donor_ID = :NEW.Donor_ID;   
     
    IF v_last_donation_date IS NOT NULL AND v_last_donation_date > SYSDATE - 56 THEN    
        RAISE_APPLICATION_ERROR(-20001, 'Donor is not eligible to donate blood within 56 days of their last donation.');   
    END IF;   
END;
/

CREATE OR REPLACE PACKAGE Blood_Bank_Package AS

  FUNCTION calculate_available_blood_bags(p_Blood_Bank_ID IN NUMBER) RETURN NUMBER;

  PROCEDURE print_max_blood_banks(p_Blood_Type VARCHAR2);

  CURSOR blood_bank_cursor(p_Blood_Type VARCHAR2) IS
    SELECT b.BB_Name AS Blood_Bank_Name
    FROM Blood_Bank b
    JOIN Bank_Blood_Type bb ON b.Blood_Bank_ID = bb.Blood_Bank_ID
    WHERE bb.Blood_Type = p_Blood_Type
    AND bb.Cost = (SELECT MAX(Cost) FROM Bank_Blood_Type WHERE Blood_Type = p_Blood_Type);

END Blood_Bank_Package;


CREATE OR REPLACE PACKAGE BODY Blood_Bank_Package AS

  FUNCTION calculate_available_blood_bags(p_Blood_Bank_ID IN NUMBER) RETURN NUMBER IS
    v_Available_Bags NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO v_Available_Bags
    FROM Bank_Blood_Type
    WHERE Blood_Bank_ID = p_Blood_Bank_ID
    GROUP BY Blood_Bank_ID;

    RETURN v_Available_Bags;
  END calculate_available_blood_bags;

  PROCEDURE print_max_blood_banks(p_Blood_Type VARCHAR2) IS
  BEGIN
    FOR r IN blood_bank_cursor(p_Blood_Type) LOOP
      DBMS_OUTPUT.PUT_LINE('Blood Bank with Max Quantity of ' || p_Blood_Type || ': ' || r.Blood_Bank_Name);
    END LOOP;
  END print_max_blood_banks;

END Blood_Bank_Package;


CREATE OR REPLACE PACKAGE Hospital_Package AS

  FUNCTION calculate_avg_length_of_stay(p_Hospital_ID NUMBER) RETURN NUMBER;

  FUNCTION get_admitted_patient_count(p_Hospital_ID NUMBER, p_Start_Date DATE, p_End_Date DATE) RETURN NUMBER;

  PROCEDURE discharge_patient(p_Hospital_ID NUMBER, p_Patient_ID NUMBER, p_Discharge_Date DATE);

END Hospital_Package;



CREATE OR REPLACE PACKAGE BODY Hospital_Package AS

  FUNCTION calculate_avg_length_of_stay(p_Hospital_ID NUMBER) RETURN NUMBER IS
    v_Total_Length NUMBER := 0;
    v_Total_Patients NUMBER := 0;
  BEGIN
    SELECT SUM(Date_Discharged - Date_Admitted)
    INTO v_Total_Length
    FROM Patient
    WHERE Hospital_ID = p_Hospital_ID
    AND Date_Discharged IS NOT NULL;

    SELECT COUNT(*)
    INTO v_Total_Patients
    FROM Patient
    WHERE Hospital_ID = p_Hospital_ID
    AND Date_Discharged IS NOT NULL;

    IF v_Total_Patients > 0 THEN
      RETURN v_Total_Length / v_Total_Patients;
    ELSE
      RETURN 0;
    END IF;
  END calculate_avg_length_of_stay;

  FUNCTION get_admitted_patient_count(p_Hospital_ID NUMBER, p_Start_Date DATE, p_End_Date DATE) RETURN NUMBER IS
    v_Patient_Count NUMBER := 0;
  BEGIN
    SELECT COUNT(*)
    INTO v_Patient_Count
    FROM Patient
    WHERE Hospital_ID = p_Hospital_ID
    AND Date_Admitted BETWEEN p_Start_Date AND p_End_Date;

    RETURN v_Patient_Count;
  END get_admitted_patient_count;

  PROCEDURE discharge_patient(p_Hospital_ID NUMBER, p_Patient_ID NUMBER, p_Discharge_Date DATE) IS
  BEGIN
    UPDATE Patient
    SET Date_Discharged = p_Discharge_Date
    WHERE Hospital_ID = p_Hospital_ID
    AND Patient_ID = p_Patient_ID;
  END discharge_patient;

END Hospital_Package;



CREATE OR REPLACE FUNCTION get_camp_total_donations(
    p_camp_id IN Blood.Camp_ID%TYPE,
    p_organization IN Blood.Organization%TYPE
)
RETURN NUMBER
IS
    v_total_donations NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total_donations
    FROM Blood
    WHERE Camp_ID = p_camp_id
      AND Organization = p_organization;

    RETURN v_total_donations;
END;



CREATE OR REPLACE FUNCTION get_donor_total_donations(
    p_donor_id IN Donor.Donor_ID%TYPE
)
RETURN NUMBER
IS
    v_total_donations NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total_donations
    FROM Blood
    WHERE Donor_ID = p_donor_id;

    RETURN v_total_donations;
END;



CREATE OR REPLACE PROCEDURE percentage_donation 
IS 
    total_participation INT; 
    total_donation INT; 
    donation_percentage NUMBER;
BEGIN 
    
    SELECT COUNT(*) INTO total_participation FROM check_ups; 
 
    SELECT COUNT(*) INTO total_donation 
    FROM donor d 
    JOIN blood b ON b.donor_id = d.donor_id; 
    
    donation_percentage := (total_donation / total_participation) * 100; 

    DBMS_OUTPUT.PUT_LINE('Percentage of donations out of total participation is: ' || donation_percentage); 
END;


CREATE OR REPLACE PROCEDURE display_available_blood_bags(
    p_Blood_Type VARCHAR2,
    p_Result OUT SYS_REFCURSOR
) IS
    l_Blood_Bank_ID Bank_Blood_Type.Blood_Bank_ID%TYPE;
    l_Blood_Bank_Name VARCHAR2(100);
    l_Blood_Type Bank_Blood_Type.Blood_Type%TYPE;
    l_Available_Bags NUMBER;
BEGIN
    OPEN p_Result FOR
    SELECT bb.Blood_Bank_ID, bb.BB_Name AS Blood_Bank_Name,
           bbt.Blood_Type, COUNT(*) AS Available_Bags
    FROM Bank_Blood_Type bbt
    JOIN Blood_Bank bb ON bbt.Blood_Bank_ID = bb.Blood_Bank_ID
    WHERE bbt.Blood_Type = p_Blood_Type
    GROUP BY bb.Blood_Bank_ID, bb.BB_Name, bbt.Blood_Type;

    DBMS_OUTPUT.PUT_LINE('Available blood bags for blood type ' || p_Blood_Type || ':');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    LOOP
        FETCH p_Result INTO
            l_Blood_Bank_ID,
            l_Blood_Bank_Name,
            l_Blood_Type,
            l_Available_Bags;
        EXIT WHEN p_Result%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Blood Bank ID: ' || l_Blood_Bank_ID || ', Blood Bank Name: ' || l_Blood_Bank_Name || ', Blood Type: ' || l_Blood_Type || ', Available Bags: ' || l_Available_Bags);
    END LOOP;

    CLOSE p_Result;
END display_available_blood_bags;


