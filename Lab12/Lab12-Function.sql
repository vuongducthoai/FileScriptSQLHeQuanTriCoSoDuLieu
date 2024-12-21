--Bai tap tu lam 
--Viet ham thuc hien cac cong viec sau 
--1. Tính giai thừa của một số nguyên bất kì.
CREATE FUNCTION dbo.Gn_GiaiThua (@n INT)
RETURNS INT 
AS
BEGIN 
  DECLARE @result INT = 1
  DECLARE @i INT =  1;
  WHILE @i <= @n 
  BEGIN 
	SET @result = @result * @i 
	SET @i = @i + 1;
  END 
  RETURN @result
END 

SELECT dbo.Fn_GiaiThua(10)



--2. Tính số ngày của một tháng trong một năm bất kì.
CREATE FUNCTION dbo.Fn_TinhSoNgay(
	@Nam INT
)
RETURNS @bangNgay TABLE (
	Ngay INT,
	Thang INT
)
BEGIN 
	DECLARE @i INT = 1
	IF ((@Nam % 4 = 0) AND (@Nam % 100 != 0)) OR (@Nam % 400 = 0) 
	BEGIN	
	   while @i <= 12 
	   BEGIN
	     IF @i = 1 OR @i = 3 OR @i = 5 OR @i = 7 OR @i = 8 OR @i = 10 OR @i = 12
		 BEGIN 
	       INSERT INTO @bangNgay 
		   VALUES(@i, 31)
		 END 
		 ELSE IF @i = 2 
		 BEGIN 
		    INSERT INTO @bangNgay
			VALUES (@i, 29)
		 END
		 ELSE
		 BEGIN 
			INSERT INTO @bangNgay
			VALUES (@i, 30)
		 END
	     SET @i = @i + 1;
	  END
	END
	ELSE 
	BEGIN
		 WHILE @i <= 12
		 BEGIN
	     IF @i = 1 OR @i = 3 OR @i = 5 OR @i = 7 OR @i = 8 OR @i = 10 OR @i = 12
		 BEGIN
	       INSERT INTO @bangNgay 
		   VALUES(@i, 31)
		 END
		 ELSE IF @i = 2  
		 BEGIN
		    INSERT INTO @bangNgay
			VALUES (@i, 28)
		 END
		 ELSE
		 BEGIN
			INSERT INTO @bangNgay
			VALUES (@i, 30)
		END
		SET @i = @i + 1
	END
   END
	RETURN
END;


SELECT * FROM dbo.Fn_TinhSoNgay(2024)




--3. Tính số lượng sinh viên của một lớp thuộc một khoa bất kì.
CREATE FUNCTION Fn_SLSV_C3(
	@tenLop NVARCHAR(50),
	@tenKhoa NVARCHAR(50)
)
RETURNS INT 
AS
BEGIN 
  DECLARE @result INT
  SELECT @result = COUNT(s.masv)
  FROM SinhVien as s 
  INNER JOIN Lop as l ON s.malop = l.malop
  INNER JOIN Khoa as k ON l.makhoa = k.makhoa
  WHERE k.tenkhoa = @tenKhoa AND l.tenlop = @tenLop
  GROUP BY l.malop, tenlop
  RETURN @result 
END 

SELECT dbo.Fn_SLSV_C3(N'Lớp G', 'CNTT')




--4. Hiển thị thông tin của các sinh viên thuộc khoa có mã ‘CNTT’ và lớp có mã là 
--‘TK10.4’. Biết rằng, thông tin hiển thị gồm: Mã sinh viên, họ tên, tuổi của sinh 
--viên.
CREATE FUNCTION Fn_DSSV_C4()
RETURNS TABLE 
AS
  RETURN (
	SELECT s.masv, s.hoten, DATEDIFF(YEAR, ngaysinh, GETDATE()) as Tuoi
 	FROM SinhVien as s 
	INNER JOIN Lop as l ON s.malop = l.malop
	INNER JOIN Khoa as k ON k.makhoa = l.makhoa
	WHERE k.tenkhoa = 'CNTT' AND l.malop = N'L07'
  )

  SELECT * FROM dbo.Fn_DSSV_C4()


--5. Viết hàm tạo ra mã sinh viên tự động tiếp theo của một mã sinh viên đã biết. Ví 
--dụ, mã hiện tại SV001 thì mã tiếp theo sẽ là SV002.
CREATE FUNCTION dbo.fn_TaoMaSinhVienTiepTheo (@MaSinhVien NVARCHAR(10))
RETURNS NVARCHAR(10)
AS
BEGIN
    DECLARE @Prefix NVARCHAR(2) = 'SV';      
    DECLARE @CurrentNumber INT;             
    DECLARE @NextNumber INT;                 
    DECLARE @NextMaSinhVien NVARCHAR(10);    

    SET @CurrentNumber = CAST(SUBSTRING(@MaSinhVien, 3, LEN(@MaSinhVien) - 2) AS INT);

    SET @NextNumber = @CurrentNumber + 1;

    SET @NextMaSinhVien = @Prefix + RIGHT('00' + CAST(@NextNumber AS NVARCHAR(2)), 2);

    RETURN @NextMaSinhVien;
END
GO



SELECT dbo.fn_TaoMaSinhVienTiepTheo('SV12')


--6. Viết hàm trả ra danh sách sinh viên của lớp có mã tùy ý.
CREATE FUNCTION DSSV_C6(@MaLop NVARCHAR(50))
RETURNS TABLE 
AS 
   RETURN(
		SELECT s.masv, s.hoten, s.gioitinh, s.ngaysinh, s.noisinh
		FROM SinhVien as s 
		INNER JOIN Lop as l ON s.malop = l.malop
		WHERE l.malop = @MaLop
   )

SELECT * FROM dbo.DSSV_C6('L02')
