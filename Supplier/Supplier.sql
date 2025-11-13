Create Database Supplier;
use Supplier;

CREATE TABLE Supplier (
  sid   VARCHAR(10) PRIMARY KEY,
  sname VARCHAR(100) NOT NULL,
  city  VARCHAR(50)
);

CREATE TABLE Parts (
  pid   VARCHAR(10) PRIMARY KEY,
  pname VARCHAR(100) NOT NULL,
  color VARCHAR(20)
);

CREATE TABLE Catalog (
  sid  VARCHAR(10),
  pid  VARCHAR(10),
  cost DECIMAL(10,2),
  PRIMARY KEY (sid, pid),
  FOREIGN KEY (sid) REFERENCES Supplier(sid),
  FOREIGN KEY (pid) REFERENCES Parts(pid)
);

INSERT INTO Supplier VALUES
('S1','Acme Widget Suppliers','New York'),
('S2','Smith Co.','London'),
('S3','Jones Ltd.','Paris'),
('S4','Blake Supplies','Paris'),
('S5','Clark & Sons','London');

INSERT INTO Parts VALUES
('P1','Bolt','red'),
('P2','Screw','blue'),
('P3','Washer','red'),
('P4','Nut','green'),
('P5','Gasket','red'),
('P6','Bracket','black');

INSERT INTO Catalog VALUES
('S1','P1',5.00),
('S1','P2',2.00),
('S1','P3',1.50),
('S1','P5',2.20),
('S2','P1',4.50),
('S2','P3',1.40),
('S3','P1',5.50),
('S3','P4',3.00),
('S4','P5',2.20),
('S4','P3',1.60),
('S5','P6',7.00);

SELECT * FROM Supplier;
SELECT * FROM Parts;
SELECT * FROM Catalog;

SELECT DISTINCT p.pname AS "Parts with Suppliers"
FROM Parts p
JOIN Catalog c ON p.pid = c.pid;

SELECT s.sname AS "Suppliers supplying every red part"
FROM Supplier s
WHERE NOT EXISTS (
  SELECT 1
  FROM Parts p
  WHERE p.color = 'red'
    AND NOT EXISTS (
      SELECT 1 FROM Catalog c
      WHERE c.pid = p.pid AND c.sid = s.sid
    )
);

SELECT p.pname AS "Parts only supplied by Acme"
FROM Parts p
WHERE EXISTS (
  SELECT 1 FROM Catalog c JOIN Supplier s ON c.sid = s.sid
  WHERE c.pid = p.pid AND s.sname = 'Acme Widget Suppliers'
)
AND NOT EXISTS (
  SELECT 1 FROM Catalog c JOIN Supplier s ON c.sid = s.sid
  WHERE c.pid = p.pid AND s.sname <> 'Acme Widget Suppliers'
);

SELECT DISTINCT c.sid AS "Suppliers charging above average"
FROM Catalog c
JOIN (
  SELECT pid, AVG(cost) AS avg_cost
  FROM Catalog
  GROUP BY pid
) a ON c.pid = a.pid
WHERE c.cost > a.avg_cost;

SELECT p.pname AS "Part Name", s.sname AS "Supplier (Highest Price)", c.cost AS "Cost"
FROM Parts p
JOIN Catalog c ON p.pid = c.pid
JOIN Supplier s ON c.sid = s.sid
WHERE c.cost = (
  SELECT MAX(cost) FROM Catalog WHERE pid = p.pid
)
ORDER BY p.pname;
