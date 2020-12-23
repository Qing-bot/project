USE BakMovie

--1
SELECT m.MovieID, m.Title, m.[Description], 'Reviews Movie' = CAST(COUNT(r.MovieID) AS VARCHAR) + ' Review(s)'
FROM Movie m, Review r, [User] u
WHERE m.MovieID = r.MovieID
AND
r.UserID = u.UserID
AND
(
u.City LIKE 'Bandung'
OR
r.[Recommendation status] LIKE 'Not Recommended'
)
GROUP BY m.MovieID, m.Title, m.[Description]


--2
SELECT mg.GenreID, mg.[Name], 'Total Movie' = COUNT(m.MovieID) 
FROM [Movie Genre] mg, [Movie Genre Details] mgd, Movie m
WHERE mg.GenreID = mgd.GenreID
AND
mgd.MovieID = m.MovieID
AND
m.Director BETWEEN 'DIR004' AND 'DIR008'
AND
DATEPART(month, m.ReleaseDate) = 2
GROUP BY mg.GenreID, mg.[Name]


--3
SELECT d.DirectorID , d.[Name], 'Local Phone' = REPLACE(d.PhoneNumber, LEFT(d.PhoneNumber, 1), '0'), 'Movie Sold' = SUM(std.Quantity), 'Total Transaction' = COUNT(sth.SalesID)
FROM Director d, Movie m, [Sales Transaction Details] std, [Sales Transaction Header] sth
WHERE d.DirectorID = m.Director
AND
m.MovieID = std.MovieID
AND
std.SalesID = sth.SalesID
AND
d.DirectorID BETWEEN 'DIR003' AND 'DIR009'
GROUP BY d.DirectorID, d.[Name], d.PhoneNumber
HAVING SUM(std.Quantity) > 20

--4
SELECT u.NickName, 'User City' = UPPER(u.City), 'Total Movie Purchased' = SUM(std.Quantity), 'Movie Owned' = COUNT(m.MovieID)
FROM [User] u, [Sales Transaction Header] sth, [Sales Transaction Details] std, Movie m
WHERE u.UserID = sth.UserID
AND
sth.SalesID  = std.SalesID
AND
std.MovieID = m.MovieID
AND
u.UserID LIKE 'USR002' OR u.UserID LIKE 'USR003'
AND
DATEPART(MONTH, m.ReleaseDate) % 2 = 1
GROUP BY u.NickName, u.City

--5
SELECT 'Numeric User ID' = RIGHT(t1.UserID, 3), 'NickName' = UPPER(t1.NickName), t1.City
FROM(
		SELECT std.MovieID, std.SalesID, u.UserID, u.City, u.NickName, std.Quantity, 'rata2' = AVG(std.Quantity)
		FROM [User] u, [Sales Transaction Header] sth, [Sales Transaction Details] std
		WHERE u.UserID = sth.UserID
		AND
		sth.SalesID = std.SalesID
		GROUP BY std.MovieID, std.SalesID, u.UserID, u.City, u.NickName, std.Quantity
		HAVING std.Quantity > SUM(std.Quantity)/COUNT(std.Quantity)
	)AS t1
WHERE t1.NickName LIKE '%l%'


--6
	SELECT m.MovieID, m.Title, p.[Name], 'Publisher Email' = LEFT(p.Email, CHARINDEX('@', p.Email))
	FROM
	(
		SELECT 'Jumlah' = SUM(std.Quantity)
		FROM [Sales Transaction Details] std, [Sales Transaction Header] sth
		WHERE std.SalesID = sth.SalesID
		AND
		DATEPART(DAY, sth.TransactionDate) = 22
	) AS t1, [Sales Transaction Details] std, [Sales Transaction Header] sth, Movie m, Publisher p
	WHERE
	std.SalesID = sth.SalesID
	AND
	std.MovieID = m.MovieID
	AND
	m.Publisher = p.PublisherID
	AND
	std.Quantity > t1.Jumlah



--7
	SELECT d.DirectorID, d.[Name], 'Movie Title' = LOWER(m.Title), 'Total Genre' = CAST(COUNT(mg.GenreID) AS VARCHAR) + ' Genre(s)'
	FROM Director d, Movie m, [Movie Genre] mg, [Movie Genre Details] mgd
	WHERE d.DirectorID = m.Director
	AND
	m.MovieID = mgd.MovieID
	AND
	mg.GenreID = mgd.GenreID
	AND
	DATEPART(DAY, m.ReleaseDate) < 30
	AND
	DATEPART(MONTH, m.ReleaseDate) = 9
	GROUP BY d.DirectorID, d.[Name], m.Title

--8
	SELECT u.NickName, 'User Firstname' = LEFT(u.FullName, CHARINDEX(' ', u.FullName)), 'Total Quantity' = SUM(std.Quantity)
	FROM
	(
		SELECT 'Jumlah' = MAX(std.Quantity)
		FROM [Sales Transaction Details] std, [Sales Transaction Header] sth
		WHERE std.SalesID = sth.SalesID
		AND
		DATEPART(DAY, sth.TransactionDate) = 20	
	) AS t1, [Sales Transaction Details] std, [Sales Transaction Header] sth, [User] u
	WHERE
	std.SalesID = sth.SalesID
	AND
	u.UserID = sth.UserID
	AND
	std.Quantity >= t1.Jumlah
	GROUP BY u.NickName, u.FullName


--9
GO
CREATE VIEW CustomUserViewer AS

	SELECT u.UserID, u.NickName, 'Maximum Quantity' = MAX(std.Quantity), 'Minimum Quantity' = MIN(std.Quantity)
	FROM [Sales Transaction Details] std, [Sales Transaction Header] sth, [User] u
	WHERE u.UserID = sth.UserID
	AND
	sth.SalesID = std.SalesID
	AND
	DATEPART(DAY, sth.TransactionDate) = 19
	AND u.NickName LIKE '%h%'
	GROUP BY u.UserID, u.NickName

	--SELECT * FROM CustomUserViewer

--10
GO
CREATE VIEW CustomPublisherViewer AS

	SELECT p.[Name], m.Title, 'Release Date' = CONVERT(NVARCHAR, m.ReleaseDate, 105), 'Total Purchase' = SUM(std.Quantity), 'Minimum Purchase' = MIN(std.Quantity)
	FROM [Sales Transaction Details] std,  Movie m, Publisher p
	WHERE std.MovieID = m.MovieID
	AND
	m.Publisher = p.PublisherID 
	AND
	p.City LIKE 'Jakarta'
	AND
	DATEPART(month, m.ReleaseDate) = 7
	GROUP BY p.[Name], m.Title, m.ReleaseDate

	--SELECT * FROM CustomPublisherViewer