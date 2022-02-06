WITH t1 AS(SELECT SUBSTRING(date, 1, 2) as day, SUBSTRING(date, 3, 4) as month, SUBSTRING(date, 7, 5) as yr
FROM sf_crime_data)

SELECT yr, month, day,
yr || month || day date_fmt
FROM t1