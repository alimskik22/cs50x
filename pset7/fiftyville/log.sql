-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Find crime scene description
SELECT description
FROM crime_scene_reports
WHERE month = 7 AND day = 28 AND year = 2025 AND street = 'Humphrey Street';

-- ANSWER: Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. Interviews were conducted today with three witnesses who were present at the time – each of their interview transcripts mentions the bakery. Littering took place at 16:36. No known witnesses.

-- Find activity from bakery security logs at 10.15am
SELECT activity
FROM bakery_security_logs
WHERE month = 7 AND day = 28 AND year = 2025 AND hour = 10;


-- Let's see the names and transcripts from interviews
SELECT name, transcript
FROM interviews
WHERE month = 7 AND day = 28 AND year = 2025;

-- Ruth : look for car, bakery parking lot, security footage, within ten minutes
-- Eugene : ATM, Leggett Street, thief withdrawing money
-- Raymond : called, talked less than a minute, take the earliest flight, purchase

-- car

SELECT license_plate, activity, minute
FROM bakery_security_logs
WHERE month = 7 AND day = 28 AND year = 2025 AND hour = 10;



-- ATM
SELECT account_number
FROM atm_transactions
WHERE month = 7 AND day = 28 AND year = 2025 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw' ;

SELECT name, atm_transactions.amount
  FROM people
  JOIN bank_accounts
    ON people.id = bank_accounts.person_id
  JOIN atm_transactions
    ON bank_accounts.account_number = atm_transactions.account_number
 WHERE atm_transactions.year = 2025
   AND atm_transactions.month = 7
   AND atm_transactions.day = 28
   AND atm_transactions.atm_location = 'Leggett Street'
   AND atm_transactions.transaction_type = 'withdraw';



-- Call
SELECT caller, receiver, duration
FROM phone_calls
WHERE month = 7 AND day = 28 AND year = 2025 AND duration < 60;



-- Earliest flight
SELECT abbreviation, full_name, city
  FROM airports
 WHERE city = 'Fiftyville';

SELECT flights.id, full_name, city, flights.hour, flights.minute
  FROM airports
  JOIN flights
    ON airports.id = flights.destination_airport_id
 WHERE flights.origin_airport_id =
       (SELECT id
          FROM airports
         WHERE city = 'Fiftyville')
   AND flights.year = 2025
   AND flights.month = 7
   AND flights.day = 29
 ORDER BY flights.hour, flights.minute;



-- id fiftyville airort?
SELECT id
FROM airports
WHERE city = 'Fiftyville';
-- 8

-- 1st flight 8.20
SELECT passengers.flight_id, name, passengers.passport_number, passengers.seat
  FROM people
  JOIN passengers
    ON people.passport_number = passengers.passport_number
  JOIN flights
    ON passengers.flight_id = flights.id
 WHERE flights.year = 2025
   AND flights.month = 7
   AND flights.day = 29
   AND flights.hour = 8
   AND flights.minute = 20
 ORDER BY passengers.passport_number;



-- check calls 

SELECT name, phone_calls.duration
  FROM people
  JOIN phone_calls
    ON people.phone_number = phone_calls.caller
 WHERE phone_calls.year = 2025
   AND phone_calls.month = 7
   AND phone_calls.day = 28
   AND phone_calls.duration <= 60
 ORDER BY phone_calls.duration;



-- check for receiver
SELECT name, phone_calls.duration
  FROM people
  JOIN phone_calls
    ON people.phone_number = phone_calls.receiver
 WHERE phone_calls.year = 2025
   AND phone_calls.month = 7
   AND phone_calls.day = 28
   AND phone_calls.duration <= 60
   ORDER BY phone_calls.duration;



SELECT name, bakery_security_logs.hour, bakery_security_logs.minute
  FROM people
  JOIN bakery_security_logs
    ON people.license_plate = bakery_security_logs.license_plate
 WHERE bakery_security_logs.year = 2025
   AND bakery_security_logs.month = 7
   AND bakery_security_logs.day = 28
   AND bakery_security_logs.activity = 'exit'
   AND bakery_security_logs.hour = 10
   AND bakery_security_logs.minute >= 15
   AND bakery_security_logs.minute <= 25
 ORDER BY bakery_security_logs.minute;

-- Bruce -> atm, early flight, caller, car
-- NYC
-- Robin -> purchased the ticket
