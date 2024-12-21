USE QLSV
--Huong dan thuc hanh 
--Bai1: Hiển thị thông tin của các lớp chưa có sinh viên nào nhập vào.
-- Cách 1: Sử dụng phép nối LEFT Excluding JOIN
SELECT LOP.malop, tenlop
FROM lop LEFT JOIN sinhvien ON lop.malop = sinhvien.malop
WHERE sinhvien.malop IS NUll

--Cach2: Su dung truy van con 
SELECT malop, TENLOP 
FROM Lop
WHERE malop NOT IN (SELECT malop FROM SinhVien)


--Bai2: Hiện thị thông tin của mỗi sinh viên gồm: MASV, HOTEN, DIEMlan1 thuộc kì học 1 của 
--các môn họ có số tín chỉ >=3 và các sinh viên đó quê ở Hưng Yên.
SELECT SINHVIEN.masv, hoten, diemlan1 
FROM sinhvien INNER JOIN diemthi ON sinhvien.masv = diemthi.masv
INNER JOIN monhoc ON MonHoc.mamonhoc = diemthi.mamonhoc
WHERE kihoc = 1 AND sotc >= 3 AND noisinh = N'Hưng Yên'


--Bai3: Hiển thị 3 môn học có số tín chỉ từ cao xuống thấp 
SELECT TOP(3) MAMONHOC, TENMONHOC, SOTC
FROM MonHoc 
ORDER BY sotc DESC

--Bai4: Thống kê số lượng sinh viên của từng lớp theo giới tính
SELECT malop, [0] as N'Nữ', [1] AS N'Nam'
FROM 
(SELECT malop, masv, gioitinh FROM SinhVien) s 
PIVOT(
	COUNT(masv)
	FOR gioitinh IN 
	([0], [1])
) as pvt 
ORDER BY malop


--Bai5: Tinh tong so luong sinh vien cua moi lop.
--Biet rang thong tin hien thi gom: Malop, Tenlop, SLSV la thuoc tinh tu dat
SELECT l.malop, tenlop, COUNT(s.masv) as SLSV
FROM Lop as l 
INNER JOIN SinhVien as s 
ON l.malop = s.malop
GROUP BY l.malop, tenlop



--Bai 6: : Hiển thị thông tin về các lớp có đông sinh viên nhất. Biết rằng thông tin hiển thị
--gồm: Malop, Tenlop, SLSV. Trong đó, SLSV là thuộc tính tự đặt
SELECT lop.malop, TENLOP, SLSV=COUNT(MASV)
FROM lop LEFT JOIN sinhvien ON lop.malop 
=sinhvien.malop
GROUP BY lop.malop, TENLOP 
HAVING COUNT(MASV)>=ALL (SELECT COUNT(MASV)
FROM sinhvien 
GROUP BY malop)

--Cách 2: Sử dụng mệnh đề TOP(1) kèm theo thuộc tính WITH TIES sẽ lấy ra 
--thông tin của các lớp có số lượng sinh viên bằng với lớp có số lượng sinh viên đông 
--nhất.
SELECT TOP(1) WITH TIES lop.malop, TENLOP,
SLSV=COUNT(MASV)
FROM lop LEFT JOIN sinhvien ON lop.malop 
=sinhvien.malop
GROUP BY lop.malop, TENLOP
ORDER BY COUNT(MASV) DESC


--Bai7: : Tính điểm trung bình lần 1 của mỗi sinh viên, thông tin hiển thị masv, hoten, 
--diemtbl1
SELECT s.MaSV, HOTEN, ROUND(sum(diemlan1 * sotc) / sum(sotc), 1)
FROM SinhVien S INNER JOIN DiemThi D ON S.masv = D.masv
INNER JOIN MONHOC M ON D.mamonhoc = M.mamonhoc
GROUP BY s.masv, hoten


--Bai8: Trong việc quản lý sinh viên, người dùng còn có nhu cầu tính điểm trung bình tất 
--cả các môn của mỗi sinh viên và điểm trung bình chung của tất cả sinh viên như sau:
SELECT HOTEN, TenMonHoc,
ROUND(sum(diemlan1*sotc)/sum(sotc),1)
FROM SINHVIEN S INNER JOIN diemthi D ON S.masv =D.masv 
INNER JOIN MONHOC M ON D.mamonhoc =M.mamonhoc
GROUP BY HOTEN , TENMONHOC WITH ROLLUP

SELECT
 CASE when GROUPING([hoten]) = 1 THEN 'All sinh vien'
ELSE [hoten] END
 AS [Họ tên],
 CASE when GROUPING([tenmonhoc]) = 1 THEN 'All mon hoc'
ELSE [tenmonhoc] END
 AS [tên môn],
 ROUND(sum(diemlan1*sotc)/sum(sotc),1) as Diemtbl1 
FROM SINHVIEN S INNER JOIN diemthi D ON S.masv =D.masv 
INNER JOIN MONHOC M ON D.mamonhoc =M.mamonhoc
GROUP BY HOTEN , TENMONHOC WITH ROLLUP


SELECT
    CASE when GROUPING([hoten]) = 1 THEN 'All sinh vien'
ELSE [hoten] END
  AS [Họ tên],
   CASE when GROUPING([tenmonhoc]) = 1 THEN 'All mon hoc'
ELSE [tenmonhoc] END
   AS [tên môn],
    ROUND(sum(diemlan1*sotc)/sum(sotc),1) as Diemtbl1 
FROM SINHVIEN S INNER JOIN diemthi D ON S.masv = D.masv 
INNER JOIN MONHOC M ON D.mamonhoc =M.mamonhoc
GROUP BY TENMONHOC , HOTEN WITH CUBE


--Bai9: 
CREATE TABLE DBO.KhachHang(
	KhachHang_ID INT IDENTITY PRIMARY KEY,
	Ten NVARCHAR(100),
	Email VARCHAR(100)
)

CREATE TABLE dbo.KhachHangLuu(
KhachHang_ID INT,
Ten NVARCHAR(50),
Email VARCHAR(100)
)

GO
INSERT INTO dbo.KhachHang VALUES(N'Ý Lan','ylan@ylan.com')
INSERT INTO dbo.KhachHang VALUES(N'Tuấn Ngọc','tuanngoc@tuanngoc.com')
INSERT INTO dbo.KhachHang VALUES(N'Thái Hiền','thaihien@thaihien.com')
INSERT INTO dbo.KhachHang VALUES(N'Ngọc Hạ','ngocha@ngocha.com')

SELECT * FROM Khachhang
SELECT * FROM KhachHangLuu

--xoa KHACHHANG_ID = 4 (Ngọc Hạ)
DELETE dbo.Khachhang
OUTPUT DELETED.* INTO dbo.KhachHangLuu
WHERE KhachHang_ID = 4

--cap nhat email cua KhachHang_ID = 3
UPDATE dbo.Khachhang
SET Email = N'me@thaihien.com'
OUTPUT DELETED.* INTO dbo.KhachHangLuu
WHERE KhachHang_ID = 3


--Yeu cau 2: Thiết kế và thao tác với View sử dụng công cụ SQL Server Object Explorer 
--hoặc câu lệnh SQL trên Query Editor.
--Bai10:Thiết kế View có tên View_DSSV để lưu trữ thông tin của sinh viên đó gồm: MaSV, 
--Hoten, Ngaysinh, Gioitinh, Noisinh, Tenlop
--Cu phap tao view dung Query Editor
CREATE VIEW VIEW_DSSV
AS 
  SELECT dbo.sinhvien.masv, dbo.sinhvien.hoten, dbo.sinhvien.ngaysinh, 
    dbo.sinhvien.gioitinh, dbo.sinhvien.noisinh, dbo.lop.tenlop
	FROM dbo.SinhVien INNER JOIN dbo.Lop ON dbo.SinhVien.malop = dbo.Lop.malop

--Bai11: Sua doi View_DSSV thanh View moi khong co cot gioitinh
ALTER VIEW VIEW_DSSV
AS 
	 SELECT dbo.sinhvien.masv, dbo.sinhvien.hoten, dbo.sinhvien.ngaysinh, 
    dbo.sinhvien.noisinh, dbo.lop.tenlop
	FROM dbo.SinhVien INNER JOIN dbo.lop ON dbo.SinhVien.malop = dbo.lop.malop


--Bai12: Su dung con tro de truy van lay tung ban ghi cua ban sinh viên trong bảng sinh viên
--1. Khai bao con trỏ
DECLARE cur_SV CURSOR
--DECLARE cur_SV CURSOR SCROLL
 FOR SELECT MaSV, HoTen, NgaySinh, GioiTinh, NoiSinh
   FROM sinhvien
--2. Sử dụng con trỏ
 --Bước 1: Mở con trỏ
  OPEN cur_SV
 --Bước 2: Truy xuất đến hàng đầu tiên của con trỏ
 FETCH NEXT FROM cur_SV
 --FETCH FIRST FROM cur_SV
 --Bước 3: Duyệt con trỏ 
  WHILE @@fetch_Status = 0
	FETCH NEXT FROM cur_SV
 --Bước 4: Đóng con trỏ 
  CLOSE cur_SV 
 --Bước 5: Giari phóng con trỏ 
 DEALLOCATE cur_SV

 --Bai13: Viết một đoạn chương trình gồm hai giao dịch (1 giao dịch thực hiện sai và một giao 
--dịch thực hiện đúng) thực hiện việc nhập dữ liệu nhập vào bảng t2 chứa khóa ngoại tham 
--chiếu đến bảng t1 của CSDL có tên UTE_TEST
CREATE DATABASE UTE_TEST
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'UTE_TEST')
	DROP DATABASE UTE_TEST
GO 
CREATE DATABASE UTE_TEST

GO 
USE UTE_TEST
GO 
CREATE TABLE t1 (a INT PRIMARY KEY)
CREATE TABLE t2 (a INT REFERENCES t1(a))
GO 
INSERT INTO t1 VALUES (1)
INSERT INTO t1 VALUES (3)
INSERT INTO t1 VALUES (4)
INSERT INTO t1 VALUES (6)
GO
SET XACT_ABORT OFF
-- SET XACT_ABORT ON
BEGIN TRAN
BEGIN TRY
 INSERT t2 SELECT 1
 INSERT t2 SELECT 3 
 INSERT t3 SELECT 100 -- bảng #t3 không tồn tại
COMMIT
END TRY
BEGIN CATCH
 ROLLBACK TRAN
 DECLARE @ErrorMessage VARCHAR(1800)
 SELECT @ErrorMessage = 'Lỗi: ' + ERROR_MESSAGE()
 RAISERROR(@ErrorMessage, 14, 1)
END CATCH

