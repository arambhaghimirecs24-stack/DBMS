CREATE DATABASE BankDB;
USE BankDB;

CREATE TABLE Branch(
branch_name VARCHAR(50) PRIMARY KEY,
branch_city VARCHAR(50),
assets DECIMAL(15,2)
);

CREATE TABLE BankAccount(
accno INT PRIMARY KEY,
branch_name VARCHAR(50),
balance DECIMAL(15,2),
FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

CREATE TABLE BankCustomer(
customer_name VARCHAR(50) PRIMARY KEY,
customer_street VARCHAR(100),
customer_city VARCHAR(50)
);

CREATE TABLE Depositer (
    customer_name VARCHAR(50),
    accno INT,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (customer_name) REFERENCES BankCustomer(customer_name),
    FOREIGN KEY (accno) REFERENCES BankAccount(accno)
);
CREATE TABLE Loan (
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(50),
    amount DECIMAL(15,2),
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

INSERT INTO Branch VALUES
('SBI_ResidencyRoad', 'Bangalore', 50000000),
('SBI_Jayanagar', 'Bangalore', 30000000),
('HDFC_Kormangala', 'Bangalore', 45000000),
('ICICI_MGroad', 'Bangalore', 40000000),
('SBI_Whitefield', 'Bangalore', 35000000);

INSERT INTO BankAccount VALUES
(101, 'SBI_ResidencyRoad', 50000),
(102, 'SBI_ResidencyRoad', 75000),
(103, 'SBI_Jayanagar', 60000),
(104, 'HDFC_Kormangala', 80000),
(105, 'SBI_ResidencyRoad', 55000);

INSERT INTO BankCustomer VALUES
('Ramesh', 'MG Road', 'Bangalore'),
('Suresh', 'Jayanagar', 'Bangalore'),
('Mahesh', 'Indiranagar', 'Bangalore'),
('Anita', 'Koramangala', 'Bangalore'),
('Priya', 'Whitefield', 'Bangalore');

INSERT INTO Depositer VALUES
('Ramesh', 101),
('Ramesh', 102),
('Suresh', 103),
('Mahesh', 104),
('Ramesh', 105);

INSERT INTO Loan VALUES
(201, 'SBI_ResidencyRoad', 200000),
(202, 'SBI_ResidencyRoad', 300000),
(203, 'SBI_Jayanagar', 150000),
(204, 'HDFC_Kormangala', 250000),
(205, 'ICICI_MGroad', 180000);

SELECT branch_name, (assets/100000) AS "assets in lakhs"
FROM Branch;

SELECT d.customer_name, b.branch_name, COUNT(*) AS num_accounts
FROM Depositer d
JOIN BankAccount b ON d.accno = b.accno
GROUP BY d.customer_name, b.branch_name
HAVING COUNT(*) >= 2;

CREATE VIEW BranchLoanSummary AS
SELECT branch_name, SUM(amount) AS total_loans
FROM Loan
GROUP BY branch_name;

SELECT * FROM BranchLoanSummary;
