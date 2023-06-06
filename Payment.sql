
-------------CAR INDUSTRY DATABASE-----------------------

Create or alter procedure Payment(
       @PhoneNo varchar(MAX)=Null,
       @Payment_Method Varchar(30)=Null,
	   @initial_amount Decimal(10,2)=Null,
	   @Card_No BigInt=Null,
	   @Expire_Month int=Null,
	   @Expire_Year int=Null,
	   @CVV int=Null
)
as
begin
    Declare @OrderID int=(Select OrderID 
	                      from OrderTable OT
						  join CustomerTable CT on OT.CustomerID=CT.CustomerID
						  where CT.Phone=@PhoneNo)
    Declare @Amount  int=(Select TotalPrice 
	                      from OrderTable OT
						  join CustomerTable CT on OT.CustomerID=CT.CustomerID
						  where CT.Phone=@PhoneNo)
If Exists (Select * 
	           from OrderTable OT
			   join CustomerTable CT on OT.CustomerID=CT.CustomerID
			   where CT.Phone=@PhoneNo)
Begin
  if @PhoneNo is Not null and @Payment_Method is Not Null and @initial_amount is Not Null and
     @Card_No is Not Null and @Expire_Month is Not Null and @Expire_Year is Not Null and @CVV is Not Null
		        if @Payment_Method='Credit Card'
				Begin
				     DECLARE @ROI FLOAT = 5.00,
					         @Tenure NUMERIC(18,2) = 60,
							 @EMI MONEY;
                         SET @ROI = (@ROI/100)/12;
						 SET @EMI = ROUND(((@Amount-@initial_amount) * @ROI * POWER((1 + @ROI), @Tenure)) / (POWER((1 + @ROI), @Tenure) - 1),3);
				         
						 insert into FinanceTable(OrderID,LoanAmount,InterestRate,MonthlyPayment,LoanTerm,
						 LoanStartDate,LoanEndDate)
				         select @OrderID,@Amount-@initial_amount,5.20,@EMI,@Tenure,CURRENT_TIMESTAMP,
						 DateAdd(Year,5,CURRENT_TIMESTAMP);

						 insert into TransactionTable(OrderID,Amount,TransactionDate,PaymentMethod,CardHolderName,
						 CardNumber,ExpiryMonth,ExpiryYear,CVV,BillingAddress,BillingCity,BillingState,BillingZipCode)
		              	 select @OrderID,@Amount,CURRENT_TIMESTAMP,@Payment_Method,
						 (Select Concat(FirstName,LastName) from CustomerTable where Phone=@PhoneNo),
						 @Card_No,@Expire_Month,@Expire_Year,@CVV,C.Address,C.City,C.State,C.ZipCode
						 from CustomerTable c
						 where Phone=@PhoneNo;

						 Select * from TransactionTable;
						 Select * from FinanceTable;
                End
                else
		              print 'Enter the Correct Payment Method';
else
  if @PhoneNo is Not null and @Payment_Method is Not Null and @initial_amount is Null
                 if @Payment_Method='Cash' 
				 Begin
	                    insert into TransactionTable(OrderID,Amount,TransactionDate,PaymentMethod,CardHolderName,
						CardNumber,ExpiryMonth,ExpiryYear,CVV,BillingAddress,BillingCity,BillingState,BillingZipCode)
		              	select @OrderID,@Amount,CURRENT_TIMESTAMP,@Payment_Method,
						0,0,0,0,0,0,0,0,0;

						Select * from TransactionTable;
                 End
                 else
	                    print 'Enter the Correct Payment Method'
   else
	  print 'Please Enter Full Payment Details & Card Details';
End
Else
     print 'Yor are not order any car';
End



begin tran
Exec Payment '8756744877','Cash',Null

begin tran
Exec Payment '8756744877','Credit Card',50000,8767456376543543,4,2044,333



rollback


Select * from CustomerTable
Select * from TransactionTable
Select * from FinanceTable
Select * from InsuranceTable
Select * from WarrantyTable


DBCC Checkident('TransactionTable',reseed,2)
DBCC Checkident('FinanceTable',reseed,2)

--------------------------------------------------------------------------------------------------


Select * from CarTable
Select * from CustomerTable
Select * from Registration
Select * from EmployeeTable
Select * from EventTable
Select * from FeedbackTable
Select * from InsuranceTable
Select * from FinanceTable
Select * from InventoryTable
Select * from MarketingCampaignTable
Select * from OrderTable
Select * from SalespersonTable
Select * from SalesTable
Select * from ServiceTable
Select * from SupplierTable
Select * from TestDriveTable
Select * from TransactionTable
Select * from WarrantyTable
Select * from OME_Sales



Update FinanceTable set LoanStartDate=CURRENT_TIMESTAMP,LoanEndDate=DATEADD(Year,5,CURRENT_TIMESTAMP)

rollback




