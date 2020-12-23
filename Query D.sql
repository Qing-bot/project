USE BakMovie


GO
CREATE PROCEDURE Sp_SalesTransactions
	@SalesID CHAR(6),
	@UserID CHAR(6),
	@TransactionDate datetime
AS 
BEGIN
	SET NOCOUNT ON
	INSERT INTO [Sales Transaction Header](SalesID, UserID, TransactionDate) VALUES
	(@SalesID, @UserID, @TransactionDate)
END
GO


GO
CREATE PROCEDURE Sp_ReviewTransactions
	@SalesID CHAR(6),
	@UserID CHAR(6),
	@MovieID CHAR(6),
	@Quantity int,
	@TransactionDate datetime
AS 
BEGIN
	SET NOCOUNT ON
	INSERT INTO Review(UserID, MovieId, [Recommendation status], [Review content], [Date]) VALUES
	(@SalesID, @UserID, @MovieID, @Quantity, @TransactionDate)
END
GO

