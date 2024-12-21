--12.3 Huong dan thuc hanh 
--Bai1: Viet thu tuc luu tinh tong 10 so nguyen dau tien 
--Cach 1 
CREATE PROC SP_tong10 
AS 
BEGIN 
   DECLARE @tong INT, @i INT 
   SET @tong = 0
   SET @i = 1 
   WHILE @i < 10 
      BEGIN 
	     SET @tong = @tong + @i
		 SET @i = @i + 1
	 END 
  PRINT N'Tổng của 10 số nguyên đâu tiên là: ' + CAST(@tong AS CHAR(3))
END

EXEC  SP_tong10


--Cach 2: Truyen tham so 
CREATE PROC SP_tongNts(@n INT)
AS
BEGIN 
   DECLARE @tong INT, @i INT
   SET @tong = 0
   SET @i = 1
   WHILE @i <= @n 
     BEGIN 
	     SET @tong = @tong + @i 
		 SET @i = @i + 1
	END 
   PRINT N'Tổng của 10 số nguyên đầu tiên là: ' + CAST(@tong as char(3))
end 

EXEC SP_tongNts 20

--Bai2: viết thủ tục hiện thị thông tin về các sinh viên và về các lớp có 
--trong CSDL
CREATE PROC Sp_Select 
AS 
BEGIN 
  SELECT * FROM SINHVIEN 
  SELECT * FROM LOp 
END 

EXEC Sp_Select

--Bai3: , viết thủ tục thêm thông tin sinh viên vào bảng sinh viên. Biết 
--rằng, thông tin của sinh viên cần nhập được nhận từ các giá trị thông qua các tham số.
CREATE PROC SP_ThemSinhVien 
 @mssv NVARCHAR(10),
 @hoten NVARCHAR(30),
 @ngaysinh smalldatetime, 
 @gioitinh bit,
 @noisinh NVARCHAR(30),
 @malop nvarchar(10)
AS
BEGIN 
	IF(EXISTS(SELECT * FROM SinhVien s WHERE s.masv = @mssv))
	BEGIN 
		PRINT N'Mã số sinh viên ' + @mssv + N'đã tồn tại'
		return -1
	END 
	IF(NOT EXISTS(SELECT * FROM Lop L WHERE L.malop = @malop))
	BEGIN 
	   PRINT N'Mã số lớp ' + @maLop + N' chưa tồn tại'
	   RETURN -1
	END 

	INSERT INTO SinhVien (masv, hoten, ngaysinh, gioitinh, noisinh, malop)
	VALUES(@mssv, @hoten, @ngaysinh, @gioitinh, @noisinh, @malop)
	RETURN 0
END 

EXEC SP_ThemSinhVien 'sv11', N'Nguyễn Văn D', '1990-09-08', 0, N'Thái Bình', 'L02'



--Bai4: Viết thủ tục tính tổng 2 số 
CREATE PROC sp_CongHaiSo(
	@a INT,
	@b INT,
	@c INT OUTPUT 
)
AS  
  SELECT @c = @a + @b 
--Thuc thi thu tuc 
DECLARE @tong INT 
SELECT @tong = 0
EXECUTE sp_CongHaiSo 100 , 80, @tong OUTPUT 
SELECT @tong


--Bai5: , viết thủ tục để tính số lượng sinh viên của mỗi lớp (mặc định là 
--lớp có mã ‘SEK21.2’)
CREATE PROC Soluong_Phong_DEfault
	@TSMalop NVARCHAR(10) = 'SEK21.2',
	@SLSV INT OUTPUT 
AS
	SELECT @SLSV = COUNT(MASV)
	FROM LOP as l LEFT JOIN SinhVien as s
	ON l.malop = s.malop
	WHERE l.malop = @TSMalop

--Goi thu tuc 
DECLARE @dem INT 
SELECT @dem = 0 
--Truong hop nhap gia tri cua tham so mac dinh 
--EXEC Soluong_Phong_DEfault @SLSV =  @dem OUTPUT 
EXEC Soluong_Phong_DEfault 'L07' , @dem OUTPUT 
SELECT @dem


--Bai6: Viet thu tuc lay ra danh sach sinh vien theo ma lop
CREATE PROC spDanhSachSinhVien 
	@maLop VARCHAR(10)
	WITH ENCRYPTION
AS
BEGIN 
   IF(NOT EXISTS(SELECT * FROM SinhVien S WHERE s.malop = @maLop))
   BEGIN 
	   PRINT N'Mã số lớp ' + @maLop + N'chưa tồn tại'
	   RETURN -1
   END 
   SELECT * FROM SinHVien s WHERE s.malop = @maLop
END 

EXEC spDanhSachSinhVien 'L01'


--Bai7: Viet ham tinh tong so luong sinh vien cua mot lop. Biet rang ham co tham 
--so truyen vao la ma lop.
CREATE FUNCTION Fn_SoLuong_SV (@tsMaLop NVARCHAR(10))
RETURNS  INT 
AS 
  BEGIN 
     DECLARE @SLSV INT; 
	 SELECT @SLSV = COUNT(masv)
	 FROM SinhVien
	 WHERE malop = @tsMaLop
	 RETURN (@SLSV)
END

--Su dung ham (Ham xuat hien trong bieu thuc)
SELECT dbo.Fn_SoLuong_SV('L06')

--Hoac su dung trong mot biet thuc truy van 
SELECT MaLop, COUNT(masv) AS SLSV
FROM SinhVien 
GROUP BY malop
HAVING COUNT(masv) > dbo.Fn_SoLuong_SV('L05')


--Bai 8: Viet ham co tham so truyen vao la ma lop va tra ra thong tin la
-- danh sach sinh vien thuoc lop do. Biet rang, thong tin hien thi gom: 
--Masv, hoten, Ngaysinh

IF object_id('Fn_DSsv_lop', 'FN') IS NOT NULL
	DROP FUNCTION Fn_DSsv_lop

GO 
CREATE FUNCTION Fn_DSsv_lop (@tsMALOP NVARCHAR(10))
  RETURNS TABLE 
  AS   
    RETURN (
		SELECT Masv, hoten, ngaysinh
		FROM SinhVien
		WHERE malop = @tsMALOP
	)
GO

SELECT * FROM Fn_DSsv_lop('L01')
 


 --Bai9: Viết hàm thông kê số lượng sinh viên của mỗi lớp của một khóa. Biết rằng, hàm trả
--ra các thông tin là danh sách các lớp của khóa tương ứng gồm: Malop, tenlop, slsv (đây 
--là cột phải tính toán).
CREATE FUNCTION Fn_thongkeSV_LOP1(@khoa INT)
	RETURNS @bangtk TABLE 
		(
			Malop NVARCHAR(10),
			tenlop NVARCHAR(30),
			slsv tinyint
		)
BEGIN 
	IF @KHOA = 0
	  INSERT INTO @bangtk 
	  SELECT LOP.malop, tenlop, COUNT(MASV)
	  from LOP INNER JOIN SinhVien 
	  ON Lop.malop = SinhVien.malop
	  GROUP BY LOP.malop, tenlop
	ELSE 
	  	INSERT INTO @bangtk 
		SELECT LOP.MALOP, tenlop, COUNT(MASV)
		FROM LOP INNER JOIN sinhVien
		ON LOP.MALOP=SINHVIEN.MALOP
		WHERE khoa=@khoa 
		GROUP BY LOP.MALOP, tenlop
	RETURN
END 



SELECT * FROM [dbo].Fn_thongkeSV_LOP(11) 

SELECT * FROM [dbo].Fn_thongkeSV_LOP (0)
