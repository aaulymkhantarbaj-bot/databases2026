-- ================================================================
-- PART A. 3NF IMPLEMENTATION FOR BOOKING RECEIPTS
-- ================================================================

CREATE TABLE receipt_airline (
    airline_id      INT PRIMARY KEY,
    airline_name    VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE receipt_airport (
    airport_id      INT PRIMARY KEY,
    airport_name    VARCHAR(80) NOT NULL UNIQUE,
    city            VARCHAR(50) NOT NULL
);

CREATE TABLE receipt_flight (
    flight_number         VARCHAR(20) PRIMARY KEY,
    departure_airport_id  INT NOT NULL REFERENCES receipt_airport(airport_id),
    arrival_airport_id    INT NOT NULL REFERENCES receipt_airport(airport_id),
    airline_id            INT NOT NULL REFERENCES receipt_airline(airline_id),
    CHECK (departure_airport_id <> arrival_airport_id)
);

CREATE TABLE receipt_passenger (
    passenger_id       INT PRIMARY KEY,
    passenger_full_name VARCHAR(100) NOT NULL,
    passport_number     VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE receipt_booking (
    booking_id      INT PRIMARY KEY,
    flight_number   VARCHAR(20) NOT NULL REFERENCES receipt_flight(flight_number),
    ticket_price    NUMERIC(10,2) NOT NULL CHECK (ticket_price >= 0)
);

CREATE TABLE receipt_booking_passenger (
    booking_id      INT NOT NULL REFERENCES receipt_booking(booking_id),
    passenger_id    INT NOT NULL REFERENCES receipt_passenger(passenger_id),
    seat_number     VARCHAR(10) NOT NULL,
    PRIMARY KEY (booking_id, passenger_id),
    UNIQUE (booking_id, seat_number)
);

INSERT INTO receipt_airline (airline_id, airline_name) VALUES
(1, 'Air Astana'),
(2, 'SCAT Airlines'),
(3, 'Turkish Airlines');

INSERT INTO receipt_airport (airport_id, airport_name, city) VALUES
(1, 'Almaty International Airport', 'Almaty'),
(2, 'Nursultan Nazarbayev International Airport', 'Astana'),
(3, 'Shymkent International Airport', 'Shymkent'),
(4, 'Istanbul Airport', 'Istanbul'),
(5, 'Aktau International Airport', 'Aktau'),
(6, 'Korkyt Ata Airport', 'Kyzylorda');

INSERT INTO receipt_flight
(flight_number, departure_airport_id, arrival_airport_id, airline_id) VALUES
('KC621', 1, 2, 1),
('DV706', 3, 1, 2),
('TK351', 4, 1, 3),
('KC859', 1, 5, 1),
('DV771', 6, 2, 2);

INSERT INTO receipt_passenger
(passenger_id, passenger_full_name, passport_number) VALUES
(1, 'Aruzhan Bekova', 'N1234501'),
(2, 'Dana Serikova', 'N1234502'),
(3, 'Ali Nurgali', 'N1234503'),
(4, 'Mira Asanova', 'N1234504'),
(5, 'Timur Omarov', 'N1234505'),
(6, 'Ayan Saparov', 'N1234506');

INSERT INTO receipt_booking (booking_id, flight_number, ticket_price) VALUES
(1001, 'KC621', 45000.00),
(1002, 'DV706', 32000.00),
(1003, 'TK351', 125000.00),
(1004, 'KC859', 51000.00),
(1005, 'DV771', 28000.00);

-- Booking 1001 contains two passengers, proving that the former
-- comma-separated value ('12A, 12B') is represented by atomic rows.
INSERT INTO receipt_booking_passenger
(booking_id, passenger_id, seat_number) VALUES
(1001, 1, '12A'),
(1001, 2, '12B'),
(1002, 3, '08C'),
(1003, 4, '21A'),
(1004, 5, '14F'),
(1005, 6, '03D');

-- Reconstruct a receipt-style result from the 3NF tables.
SELECT b.booking_id,
       p.passenger_full_name,
       p.passport_number,
       f.flight_number,
       da.airport_name AS departure_airport_name,
       da.city AS departure_city,
       aa.airport_name AS arrival_airport_name,
       aa.city AS arrival_city,
       al.airline_name,
       bp.seat_number,
       b.ticket_price
FROM receipt_booking AS b
JOIN receipt_flight AS f ON f.flight_number = b.flight_number
JOIN receipt_airline AS al ON al.airline_id = f.airline_id
JOIN receipt_airport AS da ON da.airport_id = f.departure_airport_id
JOIN receipt_airport AS aa ON aa.airport_id = f.arrival_airport_id
JOIN receipt_booking_passenger AS bp ON bp.booking_id = b.booking_id
JOIN receipt_passenger AS p ON p.passenger_id = bp.passenger_id
ORDER BY b.booking_id, bp.seat_number;