--Bai1: Viet thu tuc luu tinh tong 10 so nguyen dau tien 
--Cach 1
CREATE PROC SP_tong10
AS 
BEGIN 
     DECLARE @tong int, @i int
	 SET @tong = 0
	 SET @i = 1
	 WHILE @i <= 10
	     BEGIN 
		    SET @tong = @tong + @i
			SET @i = @i + 1
		END 
	PRINT N'Tổng của 10 số nguyên đầu tiên là: ' + CAST(@tong as char(3))
	END 

	EXEC SP_tong10

--Cach 2 
CREATE PROC SP_tong10ts(@n int)
AS 
BEGIN 
     DECLARE @tong int, @i int 
	 SET @tong = 0
	 SET @i = 1
	 WHILE @i <= @n
	    BEGIN 
		    SET @tong = @tong + @i
			SET @i = @i + 1
		END 
	PRINT N'Tổng của 10 số nguyên đầu tiên là:' + CAST(@tong as char(3))
END 

EXEC SP_tong10ts  12
EXEC SP_tong10ts  10


--Bai 2 2: Mở CSDL QLSV, viết thủ tục hiện thị thông tin về các sinh viên và về các lớp có 
--trong CSDL
CREATE PROC SP_Select 
AS 
BEGIN
   SELECT * FROM SINHVIEN 
   SELECT * FROM LOP 
END 

EXEC SP_Select


--Bai3: Mở CSDL QLSV, viết thủ tục thêm thông tin sinh viên vào bảng sinh viên. Biết 
--rằng, thông tin của sinh viên cần nhập được nhận từ các giá trị thông qua các tham số.

CREATE PROC SP_ThemSinhVien 
  @mssv nvarchar(10),
  @hoten nvarchar(30),
  @ngaysinh smalldatetime, 
  @gioitinh bit,
  @noisinh nvarchar(30),
  @malop nvarchar(10)
AS
BEGIN 
IF(EXISTS(SELECT * FROM SinhVien s WHERE s.masv = @mssv))
BEGIN 
    PRINT N'Mã số sinh viên ' + @mssv + N' đã tồn tại'
	return -1
END 
IF(NOT EXISTS(SELECT * FROM Lop L WHERE L.malop = @maLop))
BEGIN 
   PRINT N'Mã số lớp ' + @maLop + N' chưa tồn tại'
   RETURN -1
END 
 
INSERT INTO SinhVien(masv, hoten, ngaysinh, gioitinh, noisinh, malop)
VALUES(@mssv, @hoten, @ngaysinh, @gioitinh, @noisinh, @malop)
RETURN 0 
END 


EXEC SP_ThemSinhVien 'sv10', N'Nguyễn Văn A', '1997-09-08', 0, N'Thái Bình', 'SEK18.6'


--Bai4: Viet thu tuc tinh tong 2 so 
CREATE proc sp_CongHaiSo(
	@a INT ,
	@b INT ,
	@c INT OUTPUT)
AS 
   SELECT @c = @a + @b

-- Thuc thi loi goi thu tuc 
DECLARE @tong INT
SELECT @tong = 0
EXECUTE sp_CongHaiSo 100, 80, @tong OUTPUT
SELECT @tong 

--De xoa thu tuc 
DROP PROC sp_CongHaiSo

--Bai5: Viet thu tuc de tinh tong so luong sinh vien cua moi lop(mac dinh lop co ma 'SEK21.2')
CREATE PROC Soluong_Phong_DEfault
	@TSMalop nvarchar(10) = 'SEK21.2',
	@SLSV INT OUTPUT 
AS
	SELECT @SLSV = COUNT(MASV)
	FROM Lop LEFT JOIN SinhVien
	ON lop.malop = SinhVien.malop
	WHERE Lop.malop = @TSMalop
GO 



--Goi thu tuc 
DECLARE @dem INT
SELECT @dem = 0
--Truong hop nhan gia tri cua tham so mac dinh 
--EXEC Soluong_Phong_DEfault @SLSV = @dem OUTPUT 
EXEC SoLuong_Phong_Default 'L07', @dem OUTPUT
SELECT @dem

--Bai 6: Viet thu tuc lay ra danh sach sinh vien theo ma lop
CREATE PROC spDanhSachSinhVien	
	@maLop VARCHAR(10)
	WITH ENCRYPTION 
AS
BEGIN 
    IF(NOT EXISTS(SELECT * FROM SINHVIEN S WHERE S.malop = @maLop))
	BEGIN 
	     PRINT N'Mã số lớp ' + @maLop + N' chưa tồn tại'
		 RETURN -1
    END 
	SELECT * FROM SinhVien s WHERE S.malop = @maLop
	/*proceduce luôn trả về 0 nếu không RETURN*/
END

EXEC spDanhSachSinhVien 'L01'


--Bai7: Viet ham tinh tong so luong sinh vien cua mot lop. Biet rang ham co tham 
--so truyen vao la ma lop.

CREATE FUNCTION Fn_SoLuong_SV (@tsMaLOP NVARCHAR(10))
RETURNS INT 
AS
BEGIN 
	DECLARE @SLSV INT;
	SELECT @SLSV = COUNT(masv)
	FROM SinhVien
	WHERE malop = @tsMaLOP
	RETURN (@SLSV)
END
--Su dung ham (Ham xuat hien trong bieu thuc)
SELECT dbo.Fn_SoLuong_SV('L06')

--Hoac su dung trong mot biet thuc truy van
SELECT MaLop, COUNT(masv) as SLSV
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
		RETURN 
		(SELECT Masv, hoten, ngaysinh
		FROM SinhVien
		WHERE malop = @tsMALOP
		)
GO
--Su dung ham tra ket qua bang như la TABLE 
SELECT * FROM Fn_DSsv_lop('L01')

--Bai 9: Viet hàm thông kê số lượng sinh viên của mỗi lớp của một khóa. Biết rằng, hàm trả 
-- ra các thông tin là danh sách các lớp của khóa tương ứng gồm: Malop, tenlop, slsv(đây là cột phải tính toán)
CREATE FUNCTION Fn_thongkeSV_LOP (@khoa smallint)
	RETURNS @bangtk TABLE
		(Malop NVarCHAR(10),
		tenlop NvarCHAR(30),
		slsv tinyint)
BEGIN
	IF @KHOA =0
		INSERT INTO @bangtk 
		SELECT LOP.MALOP, tenlop, COUNT(MASV)
		FROM LOP INNER JOIN sinhVien
		ON LOP.MALOP=SINHVIEN.MALOP
		GROUP BY LOP.MALOP, tenlop
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





--Bai tap tu lam 
--1. Tinh tong so luong lop cua khoa co mã là 'CNTT'
CREATE PROC sp_SLLop 
	@TenKhoa NVARCHAR(50),
	@SLLop INT OUTPUT 
AS
BEGIN 
	SELECT @SLLop = COUNT(*)
	FROM Lop as l INNER JOIN Khoa as k  
	ON l.makhoa = k.makhoa
	WHERE k.tenkhoa = @TenKhoa
END 

--Goi thu tuc 
DECLARE @dem INT
SELECT @dem = 0
EXEC sp_SLLop 'CNTT', @dem OUTPUT
SELECT @dem

--2.Tính số lượng sinh viên, số lượng lớp theo mã khoa 
CREATE PROC sp_SLSV_SLL (@maKhoa NVARCHAR(50))
AS 
		SELECT k.makhoa, COUNT(s.masv) as 'SLSV', COUNT(l.malop) as 'SLL'
		FROM Sinhvien as s INNER JOIN Lop as l 
		ON s.malop = l.malop
		INNER JOIN Khoa as k ON k.makhoa = l.makhoa
		WHERE k.makhoa = @maKhoa
		GROUP BY k.makhoa

EXEC sp_SLSV_SLL 'K01'

--Tinh diem trung binh lan 1 cua hoc ki 1 cua mot sinh vien bat ki 
CREATE PROCEDURE sp_DiemTB
@masv NVARCHAR(50)
AS
BEGIN
    DECLARE @DTB INT;

    -- Tính điểm trung bình
    SELECT @DTB = AVG(diemLan1)
    FROM DiemThi 
    WHERE masv = @masv;  -- Chỉ tính điểm trung bình của sinh viên có mã @masv

    -- Trả về điểm trung bình
    SELECT @DTB AS DiemTB;
END
GO

EXEC sp_DiemTB 'SV01';

--4.Hiển thị thông tin của các sinh viên thuộc một khoa và một khóa bất kì.
CREATE PROCEDURE sp_DSSV_4
@tenKhoa NVARCHAR(50), 
@khoa SMALLINT
AS
BEGIN
    -- Truy vấn thông tin sinh viên theo khoa và khóa
    SELECT s.masv, s.hoten, s.ngaysinh, s.gioitinh, s.noisinh
    FROM SinhVien AS s
    INNER JOIN Lop AS l ON s.malop = l.malop
    INNER JOIN Khoa AS k ON l.makhoa = k.makhoa
    WHERE k.tenkhoa = @tenKhoa 
    AND l.khoa = @khoa
END
GO

EXEC sp_DSSV_4 'CNTT', 8;



--5.Hiển thị thông tin về mã sinh viên, họ tên của các sinh viên thuộc khoa có mã 
--khoa là “CNTT“ có nhiều hơn 3 môn có điểm dưới trung bình
CREATE PROC DSSV_C5
@tenKhoa NVARCHAR(50),
@soLan INT 
AS 
BEGIN 
	SELECT s.masv, s.hoten
	FROM SinhVien s 
	INNER JOIN Lop l ON s.malop = l.malop
	INNER JOIN Khoa k ON l.makhoa = k.makhoa
	WHERE k.tenkhoa = @tenKhoa
	AND (
		select COUNT(*)
		FROM DiemThi dt 
		WHERE dt.masv = s.masv
		AND dt.diemlan1 < 5
	) > @soLan
END 
GO 

EXEC DSSV_C5 'CNTT', 3



--6. Hiển thị thông tin của các sinh viên thuộc Khoa nào và Khóa học nào phải học nhiều môn nhất trong toàn trường
--sinh viên đó đã có điểm môn học tương ứng
WITH MonHocCounts AS (
    -- Bước 1: Tính số môn học mà mỗi sinh viên đã có điểm
    SELECT 
        s.masv, 
        l.makhoa, 
        l.khoa, 
        COUNT(dt.mamonhoc) AS soMon
    FROM 
        SinhVien s
    INNER JOIN Lop l ON s.malop = l.malop
    LEFT JOIN DiemThi dt ON s.masv = dt.masv
    GROUP BY 
        s.masv, l.makhoa, l.khoa
),
MaxMonHoc AS (
    -- Bước 2: Tìm số lượng môn học lớn nhất trong toàn trường
    SELECT 
        MAX(soMon) AS maxMonHoc
    FROM 
        MonHocCounts
)
-- Bước 3: Lọc ra các sinh viên thuộc khoa và khoá học có số môn học lớn nhất
SELECT 
    s.masv, 
    s.hoten, 
    l.makhoa, 
    l.khoa, 
    mh.soMon
FROM 
    MonHocCounts mh
INNER JOIN SinhVien s ON mh.masv = s.masv
INNER JOIN Lop l ON s.malop = l.malop
INNER JOIN MaxMonHoc mm ON mh.soMon = mm.maxMonHoc
ORDER BY 
    mh.soMon DESC;



--7. Hiển thị thông tin của các sinh viên của một lớp bất kì đã học nhiều môn nhất. 
--(sinh viên đó đã có điểm lần 1 )
WITH MonHocCounts AS (
    -- Bước 1: Tính số môn học mà mỗi sinh viên đã có điểm
    SELECT 
        s.masv, 
        l.makhoa, 
        l.khoa, 
        COUNT(dt.mamon) AS soMon
    FROM 
        SinhVien s
    INNER JOIN Lop l ON s.malop = l.malop
    LEFT JOIN DiemThi dt ON s.masv = dt.masv
    WHERE dt.diem IS NOT NULL  -- Chỉ tính những môn đã có điểm
    GROUP BY 
        s.masv, l.makhoa, l.khoa
),
MaxMonHoc AS (
    -- Bước 2: Tìm số lượng môn học lớn nhất trong toàn trường
    SELECT 
        MAX(soMon) AS maxMonHoc
    FROM 
        MonHocCounts
)
-- Bước 3: Lọc ra các sinh viên có số môn học bằng với số môn học lớn nhất
SELECT 
    s.masv, 
    s.hoten, 
    l.makhoa, 
    l.khoa, 
    mh.soMon
FROM 
    MonHocCounts mh
INNER JOIN SinhVien s ON mh.masv = s.masv
INNER JOIN Lop l ON s.malop = l.malop
INNER JOIN MaxMonHoc mm ON mh.soMon = mm.maxMonHoc
ORDER BY 
    mh.soMon DESC;


--8. Hiển thị thông tin những môn học thuộc Khoa 'CNTT', khóa K21 hiện nay chưa 
-- có sinh viên nào học (sinh viên chưa có điểm)
SELECT m.mamon, m.tenmon
FROM MonHoc m
INNER JOIN Lop l ON m.malop = l.malop
INNER JOIN Khoa k ON l.makhoa = k.makhoa
WHERE k.tenkhoa = 'CNTT'
  AND l.khoa = 'K21'
  AND NOT EXISTS (
      SELECT 1
      FROM DiemThi dt
      WHERE dt.mamon = m.mamon
  )
ORDER BY m.mamon;

--9.Nhập thông tin vào bảng diemthi thỏa mãn điều kiện mã sinh viên và mã môn 
--học phải tồn tại trong bảng sinh viên và môn học.
CREATE PROCEDURE InsertDiemThi
    @masv NVARCHAR(50),
    @mamon NVARCHAR(10),
    @diem DECIMAL(3, 1)
AS
BEGIN
    -- Kiểm tra nếu mã sinh viên tồn tại trong bảng SinhVien
    IF EXISTS (SELECT 1 FROM SinhVien WHERE masv = @masv)
    BEGIN
        -- Kiểm tra nếu mã môn học tồn tại trong bảng MonHoc
        IF EXISTS (SELECT 1 FROM MonHoc WHERE mamon = @mamon)
        BEGIN
            -- Chèn dữ liệu vào bảng DiemThi nếu cả hai mã sinh viên và mã môn học đều tồn tại
            INSERT INTO DiemThi (masv, mamon, diem)
            VALUES (@masv, @mamon, @diem);
            PRINT 'Dữ liệu đã được chèn thành công!';
        END
        ELSE
        BEGIN
            PRINT 'Mã môn học không tồn tại!';
        END
    END
    ELSE
    BEGIN
        PRINT 'Mã sinh viên không tồn tại!';
    END
END;
GO


--10.Xóa thông tin của sinh viên có mã bất kì

--11. Cập nhật thông tin về địa điểm của khoa có mã ‘CNTT’.



--12. 
CREATE PROCEDURE CreateSoBaoDanh
AS
BEGIN
    -- Khai báo con trỏ
    DECLARE @masv NVARCHAR(50);
    DECLARE @hoten NVARCHAR(100);
    DECLARE @ngaysinh DATE;
    DECLARE @rowNum INT = 1; -- Biến đếm số báo danh

    -- Tạo con trỏ để duyệt qua từng sinh viên
    DECLARE student_cursor CURSOR FOR
    SELECT masv, hoten, ngaysinh
    FROM SinhVien
    ORDER BY masv;  -- Sắp xếp theo mã sinh viên (có thể thay đổi tùy yêu cầu)

    -- Mở con trỏ
    OPEN student_cursor;

    -- Lấy giá trị đầu tiên từ con trỏ
    FETCH NEXT FROM student_cursor INTO @masv, @hoten, @ngaysinh;

    -- Vòng lặp duyệt qua các sinh viên
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Tạo số báo danh từ giá trị đếm (rowNum)
        DECLARE @soBaoDanh NVARCHAR(10);
        SET @soBaoDanh = 'SBD' + CAST(@rowNum AS NVARCHAR(10));

        -- Cập nhật số báo danh vào bảng SinhVien hoặc bảng liên quan
        -- Nếu muốn cập nhật vào bảng SinhVien (giả sử có cột SoBaoDanh)
        UPDATE SinhVien
        SET SoBaoDanh = @soBaoDanh
        WHERE masv = @masv;

        -- In số báo danh để kiểm tra
        PRINT 'Mã sinh viên: ' + @masv + ', Họ tên: ' + @hoten + ', Số báo danh: ' + @soBaoDanh;

        -- Tăng biến đếm
        SET @rowNum = @rowNum + 1;

        -- Lấy giá trị tiếp theo
        FETCH NEXT FROM student_cursor INTO @masv, @hoten, @ngaysinh;
    END

    -- Đóng con trỏ
    CLOSE student_cursor;
    DEALLOCATE student_cursor;
END;
GO


--13.
CREATE PROCEDURE sp_ThemMonHoc
    @mamonhoc NVARCHAR(10),
    @tenmonhoc NVARCHAR(100),
    @sotiet INT
AS
BEGIN
    -- Kiểm tra nếu mã môn học đã tồn tại
    IF EXISTS (SELECT 1 FROM MonHoc WHERE mamonhoc = @mamonhoc)
    BEGIN
        PRINT N'Mã môn học đã tồn tại!';
        RETURN -1;
    END

    -- Kiểm tra định dạng mã môn học (phải bắt đầu bằng 'MH' và tiếp theo là 6 chữ số)
    IF NOT @mamonhoc LIKE 'MH[0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        PRINT N'Mã môn học không đúng định dạng, phải là "MH" theo sau 6 chữ số!';
        RETURN -2;
    END

    -- Thực hiện thêm dữ liệu vào bảng MonHoc
    INSERT INTO MonHoc (mamonhoc, tenmonhoc, sotiet)
    VALUES (@mamonhoc, @tenmonhoc, @sotiet);

    PRINT N'Môn học đã được thêm thành công!';
END;
GO



----------------------Viết hàm thực hiện các công việc sau -----------------------
--Cau 1: Tinh giai thua cua mot so nguyen bat ki
CREATE FUNCTION dbo.Fn_GiaiThua (@n INT)
RETURNS INT 
AS 
BEGIN 
	DECLARE @result INT  = 1
	DECLARE @i INT = 1;
	WHILE @i <= @n 
	BEGIN 
		SET @result = @result * @i;
		SET @i = @i + 1;
	END 
	RETURN @result
END;


SELECT dbo.Fn_GiaiThua(10)

--Cau 2 :Tính số ngày của một tháng trong một năm bất kì.
CREATE FUNCTION dbo.Fn_TinhSoNgay(
	@Nam INT
)
RETURNS @bangNgay TABLE 
       (
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

SELECT * FROM dbo.Fn_TinhSoNgay(2024);

SELECT * FROM Lop

--3.Tinh tong so luong sinh vien cua mot lop thuoc mot khoa bat ki
CREATE FUNCTION Fn_SLSV_C3(
	@tenLop NVARCHAR(50),
	@tenKhoa NVARCHAR(50)
)
RETURNS INT 
AS 
BEGIN 
	DECLARE @result INT
	SELECT  @result = COUNT(s.masv) 
	FROM SinhVien as s 
	INNER JOIN Lop as l ON s.malop = l.malop
	INNER JOIN Khoa as k ON l.makhoa = k.makhoa
	WHERE k.tenkhoa = @tenKhoa AND l.tenlop = @tenLop
	GROUP BY  l.malop, tenlop
	return @result
END

SELECT dbo.Fn_SLSV_C3(N'Lớp G', 'CNTT')



--4.Hien thi thong tin cua cac sinh vien thuoc khoa có mã 'CNTT' và lớp có mã là 'TK 10.4'. Biết rằng,
-- thông tin hiển thị bao gồm: Mã sinh viên, họ tên, tuổi của sinh viên.

CREATE FUNCTION Fn_DSSV_C4()
RETURNS TABLE 
AS 
	RETURN (
	SELECT s.masv, s.hoten,  DATEDIFF(YEAR, NgaySinh, GETDATE())  as Tuoi
	FROM SinhVien as s 
	INNER JOIN Lop as l ON s.malop = l.malop
	INNER JOIN Khoa as k ON k.makhoa = l.makhoa
	WHERE k.tenkhoa = 'CNTT' AND l.malop = N'L07'
	)

SELECT * FROM dbo.Fn_DSSV_C4()



--5.Viết hàm tạo ra mã sinh viên tự động tiếp theo của một mã sinh viên đã biết. 
--Ví dụ, mã hiện tại SV001 thì mã tiếp theo sẽ là SV002
CREATE FUNCTION dbo.fn_TaoMaSinhVienTiepTheo (@MaSinhVien NVARCHAR(10))
RETURNS NVARCHAR(10)
AS
BEGIN
    DECLARE @Prefix NVARCHAR(2) = 'SV';      -- Phần tiền tố (SV)
    DECLARE @CurrentNumber INT;               -- Phần số của mã sinh viên
    DECLARE @NextNumber INT;                  -- Phần số tiếp theo
    DECLARE @NextMaSinhVien NVARCHAR(10);     -- Mã sinh viên tiếp theo

    -- Lấy phần số cuối của mã sinh viên (giả sử mã có định dạng SV001, SV002, ...)
    SET @CurrentNumber = CAST(SUBSTRING(@MaSinhVien, 3, LEN(@MaSinhVien) - 2) AS INT);

    -- Tăng số lên 1
    SET @NextNumber = @CurrentNumber + 1;

    -- Tạo mã sinh viên tiếp theo
    SET @NextMaSinhVien = @Prefix + RIGHT('000' + CAST(@NextNumber AS NVARCHAR(3)), 3);

    -- Trả về mã sinh viên tiếp theo
    RETURN @NextMaSinhVien;
END
GO


--6. 
CREATE FUNCTION DSSV_C6(@MaLop NVARCHAR(50))
RETURNS TABLE 
AS 
	RETURN (
		SELECT s.masv, s.hoten, s.gioitinh, s.ngaysinh, s.noisinh
		FROM SinhVien as s 
		INNER JOIN Lop as l ON s.malop = l.malop
		WHERE l.malop  = @MaLop
	)

SELECT * FROM dbo.DSSV_C6('L02')




