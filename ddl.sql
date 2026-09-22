-- ================================================================
-- PART B. DDL TASK (RUN IN THIS ORDER)
-- ================================================================

CREATE TABLE airline_info (
    airline_id       INT PRIMARY KEY,
    airline_code     VARCHAR(30) NOT NULL,
    airline_name     VARCHAR(50) NOT NULL,
    airline_country  VARCHAR(50) NOT NULL,
    created_at       TIMESTAMP NOT NULL,
    updated_at       TIMESTAMP NOT NULL,
    info             VARCHAR(50) NOT NULL
);

CREATE TABLE airport (
    airport_id    INT PRIMARY KEY,
    airport_name  VARCHAR(50) NOT NULL,
    country       VARCHAR(50) NOT NULL,
    state         VARCHAR(50) NOT NULL,
    city          VARCHAR(50) NOT NULL,
    created_at    TIMESTAMP NOT NULL,
    updated_at    TIMESTAMP NOT NULL
);

CREATE TABLE passengers (
    passenger_id            INT PRIMARY KEY,
    first_name              VARCHAR(50) NOT NULL,
    last_name               VARCHAR(50) NOT NULL,
    date_of_birth           DATE NOT NULL,
    gender                  VARCHAR(50) NOT NULL,
    country_of_citizenship  VARCHAR(50) NOT NULL,
    country_of_residence    VARCHAR(50) NOT NULL,
    passport_number         VARCHAR(20) NOT NULL,
    created_at              TIMESTAMP NOT NULL,
    updated_at              TIMESTAMP NOT NULL
);

CREATE TABLE flights (
    flight_id               INT PRIMARY KEY,
    sch_departure_time      TIMESTAMP NOT NULL,
    sch_arrival_time        TIMESTAMP NOT NULL,
    departing_airport_id    INT NOT NULL,
    arriving_airport_id     INT NOT NULL,
    departing_gate          VARCHAR(50) NOT NULL,
    arriving_gate           VARCHAR(50) NOT NULL,
    airline_id              INT NOT NULL,
    act_departure_time      TIMESTAMP NOT NULL,
    act_arrival_time        TIMESTAMP NOT NULL,
    created_at              TIMESTAMP NOT NULL,
    updated_at              TIMESTAMP NOT NULL
);

CREATE TABLE booking (
    booking_id        INT PRIMARY KEY,
    flight_id         INT NOT NULL,
    passenger_id      INT NOT NULL,
    booking_platform  VARCHAR(50) NOT NULL,
    created_at        TIMESTAMP NOT NULL,
    updated_at        TIMESTAMP NOT NULL,
    status            VARCHAR(50) NOT NULL,
    price             DECIMAL(7,2) NOT NULL
);

CREATE TABLE baggage_check (
    baggage_check_id  INT PRIMARY KEY,
    check_result      VARCHAR(50) NOT NULL,
    created_at        TIMESTAMP NOT NULL,
    updated_at        TIMESTAMP NOT NULL,
    booking_id        INT NOT NULL,
    passenger_id      INT NOT NULL
);

CREATE TABLE baggage (
    baggage_id     INT PRIMARY KEY,
    weight_in_kg   DECIMAL(4,2) NOT NULL,
    created_at     TIMESTAMP NOT NULL,
    updated_at     TIMESTAMP NOT NULL,
    booking_id     INT NOT NULL
);

CREATE TABLE boarding_pass (
    boarding_pass_id  INT PRIMARY KEY,
    booking_id        INT NOT NULL,
    seat              VARCHAR(50) NOT NULL,
    boarding_time     TIMESTAMP NOT NULL,
    created_at        TIMESTAMP NOT NULL,
    updated_at        TIMESTAMP NOT NULL
);

CREATE TABLE booking_flight (
    booking_flight_id  INT PRIMARY KEY,
    booking_id         INT NOT NULL,
    flight_id          INT NOT NULL,
    created_at         TIMESTAMP NOT NULL,
    updated_at         TIMESTAMP NOT NULL
);

CREATE TABLE security_check (
    security_check_id  INT PRIMARY KEY,
    check_result       VARCHAR(20) NOT NULL,
    created_at         TIMESTAMP NOT NULL,
    updated_at         TIMESTAMP NOT NULL,
    passenger_id       INT NOT NULL
);

-- Required structural changes.
ALTER TABLE airline_info RENAME TO airline;
ALTER TABLE booking RENAME COLUMN price TO ticket_price;
ALTER TABLE flights ALTER COLUMN departing_gate TYPE TEXT;
ALTER TABLE airline DROP COLUMN info;

-- Required relationships.
ALTER TABLE security_check
    ADD CONSTRAINT fk_security_passenger
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id);

ALTER TABLE booking
    ADD CONSTRAINT fk_booking_passenger
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id);

ALTER TABLE baggage_check
    ADD CONSTRAINT fk_baggage_check_passenger
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id),
    ADD CONSTRAINT fk_baggage_check_booking
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id);

ALTER TABLE baggage
    ADD CONSTRAINT fk_baggage_booking
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id);

ALTER TABLE boarding_pass
    ADD CONSTRAINT fk_boarding_pass_booking
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id);

ALTER TABLE booking_flight
    ADD CONSTRAINT fk_booking_flight_booking
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id),
    ADD CONSTRAINT fk_booking_flight_flight
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id);

ALTER TABLE flights
    ADD CONSTRAINT fk_flights_departing_airport
    FOREIGN KEY (departing_airport_id) REFERENCES airport(airport_id),
    ADD CONSTRAINT fk_flights_arriving_airport
    FOREIGN KEY (arriving_airport_id) REFERENCES airport(airport_id),
    ADD CONSTRAINT fk_flights_airline
    FOREIGN KEY (airline_id) REFERENCES airline(airline_id);

-- The task explicitly requests Flights -> Booking_flight. The following FK
-- is also implied by the flight_id column in Booking and is recommended.
ALTER TABLE booking
    ADD CONSTRAINT fk_booking_flight_direct
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id);

-- Optional verification queries for screenshots.
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT tc.table_name, tc.constraint_name, tc.constraint_type
FROM information_schema.table_constraints AS tc
WHERE tc.table_schema = 'public'
ORDER BY tc.table_name, tc.constraint_type;

SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'flights'
ORDER BY ordinal_position;
