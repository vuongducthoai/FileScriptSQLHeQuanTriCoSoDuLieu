--10.3. Hướng dẫn thực hành
USE QLSV
--1. In ra các số nguyên lẻ từ 1 đến 10:
DECLARE @t1 INT 
SET @t1 = 1
WHILE @t1 < 10
  BEGIN 
     PRINT @t1 
	 SET @t1 = @t1 + 1
   END
  GO



--2.Đếm số sinh viên có nơi sinh ở Hưng Yên, nếu số sinh viên lớn hơn 10 thì 
--hiển thị thông tin của sinh viên đó. Ngược lại, hiển thị toàn bộ thông tin 
--của bảng Sinhvien
DECLARE @so_luong INT 
SELECT @so_luong = COUNT(MaSV)
FROM SinhVien
WHERE noisinh  = N'Hưng Yên'

IF(@so_luong >= 10) 
 SELECT * 
 FROM SinhVien 
 WHERE noisinh = N'Hưng Yên'
ELSE 
  SELECT masv, hoten, gioitinh 
  FROM SinhVien



--3. Cho bảng sau 
--Tạo database 
CREATE DATABASE QLCH 
USE QLCH

CREATE TABLE Ban(
	mahoadon INT,
	mahang INT,
	trigiaban DECIMAL(18,2),
	primary key(mahoadon, mahang)

)


CREATE TABLE Mua(
	mahoadon INT,
	mahang INT,
	trigiamua DECIMAL(18,2),
	primary key(mahoadon, mahang)

)


--Giam gia 20% doi voi nhưng mat hang có giá bán trên 50.000
IF EXISTS(SELECT trigiaban FROM Ban WHERE trigiaban >  50000)
BEGIN 
	UPDATE Ban 
	SET trigiaban = trigiaban - trigiaban * 0.2
	WHERE trigiaban > 50000
END


--Tăng giá mua 20% cho những mặt hàng, tang cho den khi tri gia mua lon nhat lon hon 80.000
DECLARE @lon_nhat INT
SELECT @lon_nhat = MAX(trigiamua) FROM Mua 
WHILE (@lon_nhat < 80000)
	UPDATE MUA 
	SET trigiamua = trigiamua + trigiamua * 0.2
 SELECT @lon_nhat = MAX(trigiamua) FROM Mua	
 

--4. Hien thong thong tin cua sinh vien: masv, hoten, gioitinh sao cho neu gioi tinh = 0 thì hien 
--thi la 'Nu', nguoc lai hien thi 'Nam'

SELECT masv, hoten, gioitinh = 
	CASE 
		WHEN gioitinh = 0 THEN N'Nữ'
		ELSE N'Nam'
	END
	FROM SinhVien



--10.4. Bài tập tự làm 
--Bai1: Viet doan chuong trinh thuc hien cong n so nguyen dau tien (n tuy y)
/*
DECLARE @n INT = 10
DECLARE @sum INT = 0;
DECLARE @i INT =  1;

WHILE @i <= @n
BEGIN 
  SET @sum = @sum + @i;
  SET @i = @i + 1;
END

SELECT @sum AS Total
*/


--Bai2:  Viet chuong trinh dung de tinh giai thua cua mot so nguyen n tuy y 
DECLARE @n INT = 5
DECLARE @i INT = 1
DECLARE @GT INT = 1

WHILE @i <= @n
BEGIN 
	SET @GT = @GT * @i
	SET @i = @i + 1
END 

SELECT @GT as GiaiThua



--Bai3: Viết đoạn chương trình in ra thời khóa biểu học tập trong một tuần của bạn
DECLARE @Ngay NVARCHAR(10);
DECLARE @ThoiGian NVARCHAR(20);
DECLARE @MonHoc NVARCHAR(100);

DECLARE @Thu INT = 1;  

WHILE @Thu <= 7
BEGIN
    -- Xác định ngày trong tuần
    SET @Ngay = CASE @Thu
                    WHEN 1 THEN N'Thứ 2'
                    WHEN 2 THEN N'Thứ 3'
                    WHEN 3 THEN N'Thứ 4'
                    WHEN 4 THEN N'Thứ 5'
                    WHEN 5 THEN N'Thứ 6'
                    WHEN 6 THEN N'Thứ 7'
                    WHEN 7 THEN N'Chủ nhật'
                 END;

    IF @Thu = 1
    BEGIN
        PRINT @Ngay;
        PRINT N'8:00 - 10:00: Toán';
        PRINT N'10:30 - 12:00: Lý';
        PRINT N'14:00 - 16:00: Hóa';
    END
    ELSE IF @Thu = 2
    BEGIN
        PRINT @Ngay;
        PRINT N'8:00 - 10:00: Văn';
        PRINT N'10:30 - 12:00: Anh';
        PRINT N'14:00 - 16:00: Lịch sử';
    END
    ELSE IF @Thu = 3
    BEGIN
        PRINT @Ngay;
        PRINT N'8:00 - 10:00: Sinh học';
        PRINT N'10:30 - 12:00: Địa lý';
    END
    ELSE IF @Thu = 4
    BEGIN
        PRINT @Ngay;
        PRINT N'8:00 - 10:00: Hóa';
        PRINT N'10:30 - 12:00: Toán';
    END
    ELSE IF @Thu = 5
    BEGIN
        PRINT @Ngay;
        PRINT N'8:00 - 10:00: Lý';
        PRINT N'10:30 - 12:00: Văn';
    END
    ELSE IF @Thu = 6
    BEGIN
        PRINT @Ngay;
        PRINT N'8:00 - 10:00: Anh';
        PRINT '10:30 - 12:00: Tin học';
    END
    ELSE IF @Thu = 7
    BEGIN
        PRINT @Ngay;
        PRINT N'Ngày nghỉ';
    END

    SET @Thu = @Thu + 1;
END


--Bai4: 
--a. Tính số lượng sinh viên trong bảng sinh viên. Nếu số lượng sinh viên >100 thì in 
--ra chuỗi ‘Số lượng sinh viên đã vượt 100!’. Ngược lại, in ra chuỗi ‘Số lượng sinh 
--viên hợp lệ’
DECLARE @so_luong INT 
SELECT @so_luong = COUNT (MaSV)
FROM SinhVien 

IF(@so_luong >= 100)
	PRINT N'Số lượng sinh viên đã vượt qua 100!'
ELSE 
     PRINT N'Số lượng sinh viên hợp lệ'



--b.Hiển thị thông tin của các môn học gồm: Mamonhoc, tenmonhoc, tinhchat. Trong 
--đó, giá trị của cột tinhchat dựa vào số tín chỉ của môn học đó:
--Nếu sotc>=6 thì tính chất môn là ‘Thực tập, đồ án’
--Nếu sotc >=4 and sotc<6 thì tính chất môn là ‘Cơ sở ngành, chuyên ngành’
--Trường hợp còn lại tính chất môn là ‘Cơ bản’

SELECT mamonhoc, tenmonhoc, tinhchat = 
	CASE 
		WHEN sotc >= 6 THEN N'Thực tập đồ án'
		WHEN sotc >= 4 AND sotc < 6 THEN N'Cở sở ngành, chuyên ngành'
		ELSE N'Cơ bản'
	END
FROM Monhoc

--c.. Hiển thị thông tin của các sinh viên gồm: Masv, hoten, diemTBl1, Xeploai của mỗi 
--sinh viên thuộc kì 1.
SELECT sv.masv,
	   sv.hoten,
	   (SUM(d.Diemlan1 * m.sotc) * 1.0) / SUM(m.sotc) AS diemTBL1,
	   XepLoai = 
	   CASE 
			WHEN (SUM(d.Diemlan1 * m.sotc) * 1.0) / SUM(m.sotc) >= 9 THEN N'Xuất sắc'
			WHEN (SUM(d.Diemlan1 * m.sotc) * 1.0) / SUM(m.sotc) >= 8 THEN N'Giỏi'
			WHEN (SUM(d.Diemlan1 * m.sotc) * 1.0) / SUM(m.sotc) >= 7 THEN N'Khá'
			WHEN (SUM(d.Diemlan1 * m.sotc) * 1.0) / SUM(m.sotc) >= 6 THEN N'Trung bình'
			ELSE N'Yếu'
	   END
FROM SinhVien sv
JOIN DiemThi d on sv.masv = d.masv
JOIN MonHoc m ON m.mamonhoc = d.mamonhoc
WHERE d.kihoc = 1
GROUP BY sv.masv, sv.hoten


--d. Hãy thực hiện việc in ra các thông tin về lỗi khi thực hiện các câu lệnh sau và chỉ ra lỗi ở
--dòng lệnh nào:
DECLARE @st NVARCHAR(5)
SELECT @st = SOTC FROM Monhoc
PRINT CONVERT(DATETIME, @st)  -- Sai o dong nay vì không thể convert kiểu dữ liệu string sang kiểu datetime


--e. Dùng cấu trúc lặp WHILE thực hiện nhập vào bảng T1, 18 bản ghi có nội dung như sau:
CREATE TABLE T1 (MA INT PRIMARY KEY, TEN NVARCHAR(50))
SELECT * FROM T1

DECLARE @soluong INT = 18
DECLARE @i INT = 1
WHILE @i < @soluong 
BEGIN 
   INSERT INTO T1 
   VALUES (@i, N'Bản ghi thứ ' + CAST(@i AS NVARCHAR(10)))
   SET @i = @i + 1
END

--f. Thêm 1 cột Diadiem vào bảng KHOA Cập nhật dữ liệu trên cột địa điểm của bảng 
--khoa dựa vào mã khoa như sau:
--- Những khoa có mã là ‘CNTT’, ‘KT’, ‘MTK’, ‘NN’ thì địa điểm là ‘CS2’
--- Những khoa có mã là ‘CK’, ‘ĐT’, ‘ĐL’, ’HMT’ thì địa điểm là ‘CS1’
--- Còn lại các khoa có mã khác thì địa điểm là ‘CS3
ALTER TABLE Khoa 
ADD DiaDiem NVARCHAR(100)

UPDATE Khoa 
SET DiaDiem = 
	CASE 
	   WHEN MaKhoa IN ('CNTT', 'KT', 'MKT', 'NN') THEN 'CS1'
	   WHEN MaKhoa IN ('CK', 'ĐT', 'ĐL', 'HMT') THEN 'CS2'
	   ELSE 'CS3'
	END
