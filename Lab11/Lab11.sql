USE QLSV
--Huong dan thuc hanh 
--Bai1: Hiển thị thông tin của các lớp chưa có sinh viên nào nhập vào.
-- Cách 1: Sử dụng phép nối LEFT Excluding JOIN
SELECT LOP.malop, TENLOP 
FROM lop LEFT JOIN sinhvien ON lop.malop = sinhvien.malop
WHERE sinhvien.malop IS NULL

--Cach2: Su dung truy van con 
SELECT malop, TENLOP
FROM lop 
WHERE malop NOT IN (select malop FROM sinhvien)


--Bai2: Hiện thị thông tin của mỗi sinh viên gồm: MASV, HOTEN, DIEMlan1 thuộc kì học 1 của 
--các môn họ có số tín chỉ >=3 và các sinh viên đó quê ở Hưng Yên.
SELECT SINHVIEN.MASV, HOTEN, DIEMlan1
FROM sinhvien INNER JOIN diemthi 
 ON sinhvien.masv =diemthi.masv 
INNER JOIN monhoc ON monhoc.mamonhoc =diemthi.mamonhoc 
WHERE kihoc =1 AND sotc>=3 AND noisinh=N'Hưng Yên'


--Bai3: Hiển thị 3 môn học có số tín chỉ từ cao xuống thấp 
SELECT TOP(3) MAMONHOC, TENMONHOC, SOTC
FROM MonHoc
ORDER BY sotc DESC



--Bai4: Thống kê số lượng sinh viên của từng lớp theo giới tính
SELECT malop, [0] as N'Nữ', [1] AS N'Nam'
FROM 
(SELECT malop, masv, gioitinh FROM SinhVien) s
PIVOT
(
	COUNT(masv) 
	FOR gioitinh IN 
	([0], [1])
) as pvt 
ORDER BY malop

--Bai5: Tinh tong so luong sinh vien cua moi lop.
--Biet rang thong tin hien thi gom: Malop, Tenlop, SLSV 
-- la thuoc tinh tu dat

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
SELECT s.Masv, HOTEN, ROUND(sum(DIEML1*sotc)/sum(sotc),1)
AS diemTbl1 
FROM SINHVIEN S INNER JOIN DiemThi D ON S.masv =D.masv 
INNER JOIN MONHOC M ON D.mamonhoc =M.mamonhoc
GROUP BY s.masv, HOTEN

--Bai8: Trong việc quản lý sinh viên, người dùng còn có nhu cầu tính điểm trung bình tất 
--cả các môn của mỗi sinh viên và điểm trung bình chung của tất cả sinh viên như sau:
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


CREATE TABLE DBO.Khachhang(
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
CREATE VIEW VIEW_DSSV
AS 
  SELECT dbo.sinhvien.masv, dbo.sinhvien.hoten, dbo.sinhvien.ngaysinh, 
    dbo.sinhvien.gioitinh, dbo.sinhvien.noisinh, dbo.lop.tenlop
	FROM dbo.SinhVien INNER JOIN dbo.Lop ON dbo.SinhVien.malop = dbo.Lop.malop


--Bai11: Sua doi View_DSSV thanh Vie wmoi khong co cot gioitinh
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
 INSERT #t2 SELECT 1
 INSERT #t2 SELECT 3 
 INSERT #t3 SELECT 100 -- bảng #t3 không tồn tại
COMMIT
END TRY
BEGIN CATCH
 ROLLBACK TRAN
 DECLARE @ErrorMessage VARCHAR(1800)
 SELECT @ErrorMessage = 'Lỗi: ' + ERROR_MESSAGE()
 RAISERROR(@ErrorMessage, 14, 1)
END CATCH


--11.4. Bai tap tu lam 
--1 Hiển thị thông tin về các các sinh viên sinh ở Hưng Yên và chưa có điểm môn nào.
--Thông tin gồm MaSV, Hoten, GioiTinh. 

SELECT s.masv, hoten, gioitinh  = 
      CASE WHEN gioitinh = 0 THEN N'Nữ'
	       ELSE N'Nam'
	  END
FROM SinhVien as s 
LEFT JOIN DiemThi as d ON s.masv = d.masv
WHERE s.noisinh = N'Hưng Yên' AND d.masv IS NULL

--2. Hiển thị thông của các sinh viên quê ở Thái Nguyên có tuổi lớn hơn 18 và điểm lần 
--1 của môn ‘CSDL’ lớn hơn 8. Thông tin hiển thị gồm: Mã sinh viên, họ tên, giới 
--tính, nơi sinh, tuổi. (Biết rằng, tuổi của sinh viên được tính đến năm hiện tại)
SELECT s.masv, hoten, gioitinh  = 
      CASE WHEN gioitinh = 0 THEN N'Nữ'
	       ELSE N'Nam'
	  END ,
	  DATEDIFF(YEAR, s.ngaysinh, GETDATE()) as Tuoi
FROM SinhVien as s 
INNER JOIN DiemThi as d ON s.masv = d.masv
INNER JOIN MonHoc as h ON h.mamonhoc = d.mamonhoc
WHERE s.noisinh = N'Thái Nguyên'  AND h.tenmonhoc = 'CSDL' AND d.diemlan1 > 8 AND  DATEDIFF(YEAR, s.ngaysinh, GETDATE()) >= 18



--3. Hiển thị thông tin về các khoa có các sinh viên đã từng học môn học có tên “Hệ
--quản trị CSDL”.
SELECT DISTINCT k.makhoa, k.tenkhoa 
FROM Khoa K 
INNER JOIN Lop as l ON k.makhoa = l.makhoa 
INNER JOIN SinhVien s ON l.malop = s.malop
INNER JOIN DiemThi D ON s.masv = d.masv 
INNER JOIN MonHoc M ON d.mamonhoc = m.mamonhoc 
WHERE m.tenmonhoc = N'Cơ học ứng dụng'


--4. Hien thi thong tin cua 50% sinh vien dau tien co tuoi cao nhat 
SELECT TOP 50 PERCENT * 
FROM SinhVien as s 
ORDER BY DATEDIFF(YEAR, s.ngaysinh, GETDATE())


--5. Thong ke so luong sinh vien theo tung khoa (Su dung GROUP BY, GROUP BY với mốt ố toán tử CUBE,...)
SELECT k.makhoa, k.tenkhoa, s.gioitinh, COUNT(s.masv) AS so_luong_sinhvien
FROM SinhVien s
INNER JOIN Lop as l ON l.malop = s.malop
INNER JOIN Khoa k ON l.makhoa = k.makhoa
GROUP BY CUBE(k.makhoa, k.tenkhoa, s.gioitinh)
ORDER BY k.makhoa, k.tenkhoa, s.gioitinh;


--6. Thực hiện việc xếp loại lực học cho mỗi sinh viên thuộc kì 1. Thông tin gồm: Masv, 
--Hoten, diemtbl1, Xeploai. (diemTbl1 tính theo công thức, sử dụng cấu trúc CASE 
--để thiết lập giá trị cho cột Xeploai theo DiemTBl1) 
SELECT 
    sv.masv, 
    sv.hoten,
    -- Tính toán điểm trung bình (diemTBl1)
    (SUM(d.Diemlan1 * m.sotc) * 1.0) / SUM(m.sotc) AS diemTBl1,
    Xeploai = 
    -- Dựa vào diemTBl1 để xếp loại
    CASE 
        WHEN (SUM(d.Diemlan1 * m.Sotc) * 1.0) / SUM(m.Sotc) >= 9 THEN N'Xuất sắc'
        WHEN (SUM(d.Diemlan1 * m.Sotc) * 1.0) / SUM(m.Sotc) >= 8 THEN N'Giỏi'
        WHEN (SUM(d.Diemlan1 * m.Sotc) * 1.0) / SUM(m.Sotc) >= 7 THEN N'Khá'
        WHEN (SUM(d.Diemlan1 * m.Sotc) * 1.0) / SUM(m.Sotc) >= 6 THEN N'Trung bình'
        ELSE N'Yếu'
    END 
FROM SinhVien sv 
JOIN DiemThi d ON sv.masv = d.masv
JOIN MonHoc m ON m.mamonhoc = d.mamonhoc
WHERE d.kihoc = 1
GROUP BY sv.masv, sv.hoten


--7. Hiển thị thông tin của các sinh viên có DiemTBL1 lớn hơn DiemTBl1 của các sinh 
--viên sinh ở Thái Bình. Thông tin hiển thị gồm: MaSV, Hoten, NamSinh, 
--DiemTBL1. (có 2 cột tính toán là Namsinh theo ngaysinh và DiemTBL1)
SELECT 
    s.masv, 
    s.hoten, 
    YEAR(GETDATE()) - YEAR(s.ngaysinh) AS Namsinh, 
    ROUND(SUM(d.diemlan1 * m.sotc) / SUM(m.sotc), 1) AS DiemTBL1
FROM 
    SinhVien s
INNER JOIN 
    DiemThi d ON s.masv = d.masv
INNER JOIN 
    MonHoc m ON d.mamonhoc = m.mamonhoc
WHERE 
    s.noisinh != N'Thái Bình'
GROUP BY 
    s.masv, s.hoten, s.ngaysinh
HAVING 
    ROUND(SUM(d.diemlan1 * m.sotc) / SUM(m.sotc), 1) > 
        (SELECT ROUND(SUM(d1.diemlan1 * m1.sotc) / SUM(m1.sotc), 1)
         FROM SinhVien s1
         INNER JOIN DiemThi d1 ON s1.masv = d1.masv
         INNER JOIN MonHoc m1 ON d1.mamonhoc = m1.mamonhoc
         WHERE s1.noisinh = N'Thái Bình')
ORDER BY 
    DiemTBL1 DESC;



--8.Liệt kê các sinh viên có điểm cao nhất của môn Lập trình C#, thông tin gồm MaSV, 
--Hoten, Diemlan1 (sử dụng hàm Max() trong truy vấn con)
SELECT 
    s.masv, 
    s.hoten,
	d.diemlan1
FROM 
    SinhVien s
INNER JOIN 
    DiemThi d ON s.masv = d.masv
INNER JOIN 
    MonHoc m ON d.mamonhoc = m.mamonhoc
WHERE 
   m.tenmonhoc = 'Lập trình C#'  AND d.diemlan1 = (
		SELECT MAX(d.diemlan1)
		FROM DiemThi as d 
		INNER JOIN MonHoc as m 
		ON d.mamonhoc = m.mamonhoc 
		WHERE  m.tenmonhoc = 'Lập trình C#' 
   )

--9. Hiển thị thông tin của sinh viên có điểm trung bình lần 1 cao nhất thuộc kì 1, thông 
--tin gồm: maSV, Hoten, DiemTBL1.

SELECT TOP 1 WITH TIES
    s.masv, 
    s.hoten, 
    ROUND(SUM(d.diemlan1 * m.sotc) / SUM(m.sotc), 1) AS DiemTBL1
FROM 
    SinhVien s
INNER JOIN 
    DiemThi d ON s.masv = d.masv
INNER JOIN 
    MonHoc m ON d.mamonhoc = m.mamonhoc
WHERE 
    d.kihoc = 1  -- Giả sử `hocky = 1` là kỳ 1
GROUP BY 
    s.masv, s.hoten
ORDER BY 
    DiemTBL1 DESC;


--10. Hiển thị 5 sinh viên đầu tiên có tuổi được sắp xếp từ thấp -> cao thuộc khoa có mã là 'CNTT'
SELECT TOP 5
    s.masv, 
    s.hoten, 
    YEAR(GETDATE()) - YEAR(s.ngaysinh) AS Tuoi
FROM 
    SinhVien s
INNER JOIN 
   Lop l ON l.malop = s.malop 
INNER JOIN 
    Khoa k ON l.makhoa = k.makhoa
WHERE 
    k.makhoa = 'CNTT' 
ORDER BY 
    Tuoi ASC; 


--11. Hiển thị thông tin các sinh viên bị trượt ít nhất một môn (sử dụng truy vấn con và 
--từ khóa EXISTS hoặc IN)
--Dung EXITS
SELECT s.masv, s.hoten, s.ngaysinh
FROM SinhVien s
WHERE EXISTS (
    SELECT 1
    FROM DiemThi d
    WHERE d.masv = s.masv
    AND d.diemlan1 < 5  -- Giả sử điểm dưới 5 là bị trượt
);

--Dung IN
SELECT s.masv, s.hoten, s.ngaysinh
FROM SinhVien s
WHERE s.masv IN (
    SELECT d.masv
    FROM DiemThi d
    WHERE d.diemlan1 < 5  -- Giả sử điểm dưới 5 là bị trượt
);




--12.Cho biết danh sách sinh viên đã học hết tất các môn trong bảng monhoc
SELECT s.masv, s.hoten
FROM SinhVien s
WHERE NOT EXISTS (
    SELECT 1
    FROM MonHoc m
    WHERE NOT EXISTS (
        SELECT 1
        FROM DiemThi d
        WHERE d.masv = s.masv
        AND d.mamonhoc = m.mamonhoc
    )
)
ORDER BY s.masv;


--13.Thực hiện việc phân hạng cho môn học theo sotc (sử dụng tất cả các hàm phân 
--hạng)

SELECT 
	mamonhoc,
	tenmonhoc,
	sotc, 
	 RANK() OVER (ORDER BY Sotc DESC) AS RANK,
	 DENSE_RANK() OVER (ORDER BY Sotc DESC) AS DenseRank,
    ROW_NUMBER() OVER (ORDER BY Sotc DESC) AS RowNumber
FROM Monhoc 

--14. Thống kê số lượng sinh viên của từng khoa theo giới tính (sử dụng toán tử PIVOT)
SELECT makhoa, 
       ISNULL([0], 0) AS Nu, 
       ISNULL([1], 0) AS Nam
FROM
(
    SELECT l.makhoa, s.gioitinh
    FROM SinhVien s
    INNER JOIN Lop l ON s.malop = l.malop  -- Kết nối bảng SinhVien và Lop
) AS SourceTable
PIVOT
(
    COUNT(gioitinh) 
    FOR gioitinh IN ([0], [1])  -- Đếm số sinh viên theo giới tính
) AS PivotTable;



--16. Tạo View có tên là w_cau1 lưu trữ các thông tin: Họ tên sinh viên, giới tính, tên 
--môn học, điểm thi lần 1 của sinh viên đó (bằng 2 cách)
CREATE VIEW w_cau1 AS
SELECT s.HoTen, 
       IIF(s.GioiTinh = 1, 'Nam', 'Nữ') AS GioiTinh, 
       m.TenMonHoc, 
       d.DiemLan1
FROM SinhVien s
JOIN DiemThi d ON s.MaSV = d.MaSV
JOIN MonHoc m ON d.MaMonHoc = m.MaMonHoc;


--17. Sửa đổi view vừa tạo thành view chỉ lưu trữ Họ tên sinh viên, giới tính, điểm thi 
--lần 1 (bằng 2 cách)
ALTER VIEW VIEW_DSSV
AS 
SELECT s.HoTen, 
       IIF(s.GioiTinh = 1, 'Nam', 'Nữ') AS GioiTinh, 
       d.DiemLan1
FROM SinhVien s
JOIN DiemThi d ON s.MaSV = d.MaSV

--18. Tạo view có tên là w_cau3 lưu trữ thông tin gồm mã môn học và số lượng sinh 
--viên đã học môn học đó.
CREATE VIEW w_cau3 AS
SELECT d.MaMonHoc, COUNT(DISTINCT d.MaSV) AS SoLuongSinhVien
FROM DiemThi d
GROUP BY d.MaMonHoc;

--19. Tạo view có tên là w_cau4 lưu trữ thông tin gồm mã lớp, tên lớp, số lượng sinh 
--viên của lớp tương ứng (được tính thông qua cột masv)
CREATE VIEW w_cau4 AS
SELECT l.MaLop, l.TenLop, COUNT(s.MaSV) AS SoLuongSinhVien
FROM Lop l
LEFT JOIN SinhVien s ON l.MaLop = s.MaLop
GROUP BY l.MaLop, l.TenLop;


--20. Tạo view có tên là w_cau5 cho biết tên của sinh viên chưa học môn nào (chưa có điểm môn học đó)
CREATE VIEW w_cau5 AS
SELECT s.masv, s.hoten
FROM SinhVien s
WHERE NOT EXISTS (
    SELECT 1 
    FROM DiemThi d
    WHERE d.masv = s.masv
);


--21. Tạo ra view View_Ttkhoa gồm các thông tin: mã khoa, tên khoa, địa điểm. Sau 
--đó thực hiện các thao tác truy vấn, cập nhật dữ liệu thông qua view View_Ttkhoa 
--đã tạo.
CREATE VIEW View_Ttkhoa AS
SELECT k.makhoa, k.tenkhoa, k.diadiem
FROM Khoa k;


--22. Sử dụng con trỏ để hiển thị thông tin của sinh viên thứ 1 và
--sinh viên cuối cùng trong bảng SinhVien
DECLARE @masv VARCHAR(10), @hoten NVARCHAR(50), @ngaysinh DATE;

-- Khai báo con trỏ kiểu SCROLL
DECLARE cur_SV CURSOR SCROLL FOR
SELECT masv, hoten, ngaysinh FROM SinhVien;

-- Mở con trỏ
OPEN cur_SV;

-- Lấy sinh viên thứ 1
FETCH NEXT FROM cur_SV INTO @masv, @hoten, @ngaysinh;
PRINT N'Sinh viên thứ 1: ' + @masv + ', ' + @hoten + ', ' + CONVERT(NVARCHAR, @ngaysinh);

-- Duyệt đến sinh viên cuối cùng
FETCH LAST FROM cur_SV INTO @masv, @hoten, @ngaysinh;
PRINT N'Sinh viên cuối cùng: ' + @masv + ', ' + @hoten + ', ' + CONVERT(NVARCHAR, @ngaysinh);

-- Đóng và giải phóng con trỏ
CLOSE cur_SV;
DEALLOCATE cur_SV;



--23. Khai báo một con trỏ có tên là cur_cau7 để hiển thị 
--mã sinh viên và điểm thi lần 1 cao nhất trong tất cả các môn học mà sinh viên đó đã có điểm.
DECLARE @masv VARCHAR(10), @max_score FLOAT;

DECLARE cur_cau7 CURSOR FOR
SELECT DISTINCT d.masv, MAX(d.diemlan1)
FROM DiemThi d
GROUP BY d.masv;

-- Mở con trỏ
OPEN cur_cau7;

-- Lấy thông tin mã sinh viên và điểm thi lần 1 cao nhất
FETCH NEXT FROM cur_cau7 INTO @masv, @max_score;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Mã sinh viên: ' + @masv + ', Điểm thi lần 1 cao nhất: ' + CONVERT(NVARCHAR, @max_score);
    FETCH NEXT FROM cur_cau7 INTO @masv, @max_score;
END;

-- Đóng và giải phóng con trỏ
CLOSE cur_cau7;
DEALLOCATE cur_cau7;

--24. Sử dụng con trỏ để cập nhật số lượng sinh viên
--của mỗi lớp vào cột siso của bảng Lop (trong bảng Lop ta thêm một cột siso)
-- Thêm cột siso vào bảng Lop
ALTER TABLE Lop
ADD siso INT;

DECLARE @malop VARCHAR(10), @siso INT;

DECLARE cur_siso CURSOR FOR
SELECT malop, COUNT(malop) 
FROM SinhVien
GROUP BY malop;

-- Mở con trỏ
OPEN cur_siso;

-- Cập nhật số lượng sinh viên cho từng lớp
FETCH NEXT FROM cur_siso INTO @malop, @siso;
WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Lop
    SET siso = @siso
    WHERE malop = @malop;
    FETCH NEXT FROM cur_siso INTO @malop, @siso;
END;

-- Đóng và giải phóng con trỏ
CLOSE cur_siso;
DEALLOCATE cur_siso;


--25. Thêm cột XepLoai vào bảng SinhVien, tính điểm trung bình lần 1 (DiemTBL1)
--của mỗi sinh viên và cập nhật dữ liệu cho cột XepLoai theo công thức

ALTER TABLE SinhVien
ADD XepLoai NVARCHAR(20);

DECLARE @masv VARCHAR(10), @diemTBL1 FLOAT, @xepLoai NVARCHAR(20);

DECLARE cur_XepLoai CURSOR FOR
SELECT masv, SUM(diemlan1 * sotc) / SUM(sotc) AS DiemTBL1
FROM DiemThi d
INNER JOIN MonHoc m ON d.mamonhoc = m.mamonhoc
GROUP BY masv;

-- Mở con trỏ
OPEN cur_XepLoai;

-- Cập nhật XepLoai cho mỗi sinh viên
FETCH NEXT FROM cur_XepLoai INTO @masv, @diemTBL1;
WHILE @@FETCH_STATUS = 0
BEGIN
    IF @diemTBL1 < 5
        SET @xepLoai = 'Yếu';
    ELSE IF @diemTBL1 >= 5 AND @diemTBL1 < 7
        SET @xepLoai = 'Trung bình';
    ELSE IF @diemTBL1 >= 7 AND @diemTBL1 < 8
        SET @xepLoai = 'Khá';
    ELSE
        SET @xepLoai = 'Giỏi';

    -- Cập nhật XepLoai cho sinh viên
    UPDATE SinhVien
    SET XepLoai = @xepLoai
    WHERE masv = @masv;

    FETCH NEXT FROM cur_XepLoai INTO @masv, @diemTBL1;
END;

-- Đóng và giải phóng con trỏ
CLOSE cur_XepLoai;
DEALLOCATE cur_XepLoai;



--26. Viết một giao dịch dùng để kiểm soát dữ liệu nhập vào vào bảng lớp
--(một số bản ghi có giá trị cụ thể)
BEGIN TRY
    BEGIN TRANSACTION;

    -- Kiểm tra và chèn dữ liệu vào bảng Lop
    INSERT INTO Lop (malop, tenlop, siso)
    VALUES ('L001', N'Lớp CNTT', 30);

    -- Kiểm tra một số điều kiện cụ thể, ví dụ sĩ số không vượt quá 50
    DECLARE @siso INT;
    SELECT @siso = siso FROM Lop WHERE malop = 'L001';

    IF @siso > 50
    BEGIN
        -- Nếu sĩ số lớn hơn 50, rollback giao dịch
        ROLLBACK TRANSACTION;
        PRINT 'Sĩ số lớp vượt quá giới hạn. Giao dịch đã bị hủy.';
    END
    ELSE
    BEGIN
        -- Nếu không có vấn đề, commit giao dịch
        COMMIT TRANSACTION;
        PRINT 'Giao dịch thành công, dữ liệu đã được cập nhật.';
    END

END TRY
BEGIN CATCH
    -- Nếu có lỗi xảy ra, rollback giao dịch và thông báo lỗi
    ROLLBACK TRANSACTION;
    PRINT 'Có lỗi xảy ra: ' + ERROR_MESSAGE();
END CATCH;


--27. Viết giao dịch kiểm soát tính toàn vẹn của dữ liệu khi bạn thêm một sinh viên 
--vào một lớp học và cập nhật lại sĩ số của lớp học
BEGIN TRY
    BEGIN TRANSACTION;

    -- Thêm sinh viên vào lớp
    INSERT INTO SinhVien (masv, hoten, malop)
    VALUES ('SV001', N'Trần Văn B', 'L001');

    -- Cập nhật sĩ số của lớp
    UPDATE Lop
    SET siso = siso + 1
    WHERE malop = 'L001';

    -- Kiểm tra nếu sĩ số vượt quá giới hạn (ví dụ 50 sinh viên)
    DECLARE @siso INT;
    SELECT @siso = siso FROM Lop WHERE malop = 'L001';

    IF @siso > 50
    BEGIN
        -- Nếu sĩ số vượt quá giới hạn, rollback giao dịch
        ROLLBACK TRANSACTION;
        PRINT 'Sĩ số lớp vượt quá giới hạn. Giao dịch đã bị hủy.';
    END
    ELSE
    BEGIN
        -- Nếu không có vấn đề, commit giao dịch
        COMMIT TRANSACTION;
        PRINT 'Sinh viên đã được thêm vào lớp và sĩ số được cập nhật.';
    END

END TRY
BEGIN CATCH
    -- Nếu có lỗi xảy ra, rollback giao dịch và thông báo lỗi
    ROLLBACK TRANSACTION;
    PRINT 'Có lỗi xảy ra: ' + ERROR_MESSAGE();
END CATCH;




--Bai tap ve nha 
-- Tạo database
CREATE DATABASE LinhKienMayTinh;

-- Chọn database vừa tạo
USE LinhKienMayTinh;

-- Tạo bảng PhânLoai
CREATE TABLE PhanLoai (
    MaLoai INT PRIMARY KEY,           -- Mã loại (Primary Key)
    TenLoai NVARCHAR(100) NOT NULL    -- Tên loại (Không được phép null)
);

-- Tạo bảng NhàCungCap
CREATE TABLE NhaCungCap (
    MaNCC INT PRIMARY KEY,              -- Mã nhà cung cấp (Primary Key)
    TenNCC NVARCHAR(100) NOT NULL,      -- Tên nhà cung cấp
    DiaChi NVARCHAR(200) NOT NULL,      -- Địa chỉ nhà cung cấp
    DienThoai VARCHAR(15) NOT NULL      -- Số điện thoại nhà cung cấp
);

-- Tạo bảng KhachHang
CREATE TABLE KhachHang (
    MaKH INT PRIMARY KEY,               -- Mã khách hàng (Primary Key)
    TenKH NVARCHAR(100) NOT NULL,       -- Tên khách hàng
    DiaChi NVARCHAR(200) NOT NULL,      -- Địa chỉ khách hàng
    DienThoai VARCHAR(15) NOT NULL      -- Số điện thoại khách hàng
);

-- Tạo bảng HangHoa
CREATE TABLE HangHoa (
    MaHH INT PRIMARY KEY,               -- Mã hàng hóa (Primary Key)
    TenHH NVARCHAR(100) NOT NULL,       -- Tên hàng hóa
    DonViTinh NVARCHAR(50) NOT NULL,    -- Đơn vị tính (ví dụ: chiếc, cái, kg,...)
    MaLoai INT,                          -- Mã loại (Foreign Key tham chiếu đến bảng PhanLoai)
    FOREIGN KEY (MaLoai) REFERENCES PhanLoai(MaLoai)  -- Ràng buộc khóa ngoại
);

-- Tạo bảng BangBaoGia
CREATE TABLE BangBaoGia (
    MaNCC INT,                          -- Mã nhà cung cấp (Foreign Key tham chiếu đến bảng NhaCungCap)
    MaHH INT,                           -- Mã hàng hóa (Foreign Key tham chiếu đến bảng HangHoa)
    GiaBan FLOAT NOT NULL,              -- Giá bán
    PRIMARY KEY (MaNCC, MaHH),          -- Khóa chính gồm mã nhà cung cấp và mã hàng hóa
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC), -- Ràng buộc khóa ngoại
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH)      -- Ràng buộc khóa ngoại
);

-- Tạo bảng CungCap
CREATE TABLE CungCap (
    MaNCC INT,                          -- Mã nhà cung cấp (Foreign Key tham chiếu đến bảng NhaCungCap)
    MaHH INT,                           -- Mã hàng hóa (Foreign Key tham chiếu đến bảng HangHoa)
    Ngay DATE NOT NULL,                 -- Ngày cung cấp
    SoLuong INT NOT NULL,               -- Số lượng cung cấp
    PRIMARY KEY (MaNCC, MaHH, Ngay),    -- Khóa chính là sự kết hợp của mã nhà cung cấp, mã hàng hóa và ngày
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC),  -- Ràng buộc khóa ngoại
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH)       -- Ràng buộc khóa ngoại
);

-- Tạo bảng HoaDonBan
CREATE TABLE HoaDonBan (
    MaHD INT PRIMARY KEY,               -- Mã hóa đơn (Primary Key)
    MaKH INT,                            -- Mã khách hàng (Foreign Key tham chiếu đến bảng KhachHang)
    MaHH INT,                            -- Mã hàng hóa (Foreign Key tham chiếu đến bảng HangHoa)
    Ngay DATE NOT NULL,                  -- Ngày bán hàng
    SoLuong INT NOT NULL,                -- Số lượng bán
    DonGia FLOAT NOT NULL,               -- Đơn giá bán
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),  -- Ràng buộc khóa ngoại
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH)    -- Ràng buộc khóa ngoại
);



-- Chèn dữ liệu vào bảng PhanLoai
INSERT INTO PhanLoai (MaLoai, TenLoai) VALUES
(1, N'Linh kiện máy tính'),
(2, N'Phụ kiện'),
(3, N'Màn hình'),
(4, N'Chuột'),
(5, N'Bàn phím'),
(6, N'Tai nghe'),
(7, N'Máy in');

-- Chèn dữ liệu vào bảng NhaCungCap
INSERT INTO NhaCungCap (MaNCC, TenNCC, DiaChi, DienThoai) VALUES
(1, N'ABC Tech', N'123 Nguyễn Văn Cừ, Hà Nội', '0987654321'),
(2, N'Def Supplies', N'456 Trần Quang Diệu, TP.HCM', '0976543210'),
(3, N'XYZ Electronics', N'789 Lý Thường Kiệt, Đà Nẵng', '0965432109'),
(4, N'PQR Goods', N'101 Nguyễn Tất Thành, Hà Nội', '0945678901'),
(5, N'LMN Trading', N'202 Hoàng Quốc Việt, Hà Nội', '0934567890'),
(6, N'OPQ Industries', N'303 Trần Hưng Đạo, TP.HCM', '0923456789'),
(7, N'RST Supplies', N'404 Đinh Tiên Hoàng, Đà Nẵng', '0912345678');

-- Chèn dữ liệu vào bảng KhachHang
INSERT INTO KhachHang (MaKH, TenKH, DiaChi, DienThoai) VALUES
(1, N'Nguyễn Văn A', N'25 Hoàng Diệu, Hà Nội', '0912345678'),
(2, N'Phạm Thị B', N'12 Lý Thường Kiệt, TP.HCM', '0923456789'),
(3, N'Đặng Minh C', N'10 Trường Chinh, Đà Nẵng', '0934567890'),
(4, N'Ngô Hữu D', N'5 Bùi Thị Xuân, Hà Nội', '0945678901'),
(5, N'Vũ Mai E', N'30 Nguyễn Tất Thành, TP.HCM', '0956789012'),
(6, N'Trần Thu F', N'15 Phan Đăng Lưu, Đà Nẵng', '0967890123'),
(7, N'Hoàng Hoàng G', N'20 Đinh Tiên Hoàng, Hà Nội', '0978901234');

-- Chèn dữ liệu vào bảng HangHoa
INSERT INTO HangHoa (MaHH, TenHH, DonViTinh, MaLoai) VALUES
(1, N'CPU Intel i7', N'Chiếc', 1),
(2, N'RAM 8GB DDR4', N'Chiếc', 1),
(3, N'Màn hình Samsung 24"', N'Chiếc', 3),
(4, N'Chuột Logitech', N'Cái', 4),
(5, N'Bàn phím cơ Logitech', N'Cái', 5),
(6, N'Tai nghe Bluetooth', N'Cái', 6),
(7, N'Máy in Canon', N'Chiếc', 7);

-- Chèn dữ liệu vào bảng BangBaoGia
INSERT INTO BangBaoGia (MaNCC, MaHH, GiaBan) VALUES
(1, 1, 5000000),
(2, 2, 1500000),
(3, 3, 3500000),
(4, 4, 300000),
(5, 5, 1200000),
(6, 6, 800000),
(7, 7, 2500000);

-- Chèn dữ liệu vào bảng CungCap
INSERT INTO CungCap (MaNCC, MaHH, Ngay, SoLuong) VALUES
(1, 1, '2023-01-01', 100),
(2, 2, '2023-02-01', 200),
(3, 3, '2023-03-01', 50),
(4, 4, '2023-04-01', 300),
(5, 5, '2023-05-01', 150),
(6, 6, '2023-06-01', 80),
(7, 7, '2023-07-01', 120);

-- Chèn dữ liệu vào bảng HoaDonBan
INSERT INTO HoaDonBan (MaHD, MaKH, MaHH, Ngay, SoLuong, DonGia) VALUES
(1, 1, 1, '2023-08-01', 2, 5000000),
(2, 2, 2, '2023-08-02', 1, 1500000),
(3, 3, 3, '2023-08-03', 1, 3500000),
(4, 4, 4, '2023-08-04', 5, 300000),
(5, 5, 5, '2023-08-05', 3, 1200000),
(6, 6, 6, '2023-08-06', 2, 800000),
(7, 7, 7, '2023-08-07', 1, 2500000);



--1. Liệt kê tất cả các mặt hàng thuộc loại có tên là “Màn Hình”
SELECT hh.MaHH, hh.TenHH, hh.DonViTinh
FROM HangHoa hh
INNER JOIN PhanLoai pl ON hh.MaLoai = pl.MaLoai
WHERE pl.TenLoai = N'Màn Hình';

--2. Liệt kê tất cả các nhà cung cấp ở thành phố Hồ Chí Minh
SELECT MaNCC, TenNCC, DiaChi, DienThoai
FROM NhaCungCap
WHERE DiaChi LIKE N'%TP.HCM%';

--3. Liệt kê những khách hàng có tên bắt đầu bằng chữ “H”
SELECT MaKH, TenKH, DiaChi, DienThoai
FROM KhachHang
WHERE TenKH LIKE N'H%';


--4. Liệt kê đầy đủ thông tin của các nhà cung cấp đã từng cung cấp mặt hàng có tên là “CD LG 52X”
SELECT DISTINCT ncc.MaNCC, ncc.TenNCC, ncc.DiaChi, ncc.DienThoai
FROM NhaCungCap ncc
INNER JOIN CungCap cc ON ncc.MaNCC = cc.MaNCC
INNER JOIN HangHoa hh ON cc.MaHH = hh.MaHH
WHERE hh.TenHH = N'CD LG 52X';


--5. Liệt kê mã số và tên của các mặt hàng hiện không có nhà cung cấp nào cung cấp
SELECT hh.MaHH, hh.TenHH
FROM HangHoa hh
LEFT JOIN CungCap cc ON hh.MaHH = cc.MaHH
WHERE cc.MaNCC IS NULL;


--6. Liệt kê những khách hàng mua nhiều hơn một lần trong một ngày (có từ hai hoá đơn trở lên) 
--trong khoảng thời gian từ 01/01/2021 đến 31/10/2021
SELECT MaKH, COUNT(*) AS SoLanMua, Ngay
FROM HoaDonBan
WHERE Ngay BETWEEN '2021-01-01' AND '2021-10-31'
GROUP BY MaKH, Ngay
HAVING COUNT(*) >= 2;


--7. Liệt kê đầy đủ các thông tin của các nhà cung cấp bán mặt hàng có tên là: “CPU PIII – 933EB“ với giá rẻ nhất
SELECT ncc.*
FROM NhaCungCap ncc
INNER JOIN BangBaoGia bbg ON ncc.MaNCC = bbg.MaNCC
INNER JOIN HangHoa hh ON bbg.MaHH = hh.MaHH
WHERE hh.TenHH = N'CPU PIII – 933EB'
  AND bbg.GiaBan = (
      SELECT MIN(bbg2.GiaBan)
      FROM BangBaoGia bbg2
      INNER JOIN HangHoa hh2 ON bbg2.MaHH = hh2.MaHH
      WHERE hh2.TenHH = N'CPU PIII – 933EB'
  );



--8. Liệt kê tất cả các khách hàng đã có giao dịch với cửa hàng
SELECT DISTINCT kh.*
FROM KhachHang kh
INNER JOIN HoaDonBan hdb ON kh.MaKH = hdb.MaKH;


--9. Liệt kê tất cả các khách hàng thân thuộc trong năm 2021 (nhiều hơn 10 lần mua trong năm đó)
SELECT MaKH, COUNT(*) AS SoLanMua
FROM HoaDonBan
WHERE YEAR(Ngay) = 2021
GROUP BY MaKH
HAVING COUNT(*) > 10;


--10 Liệt kê tất cả các khách hàng tiềm năng: Là những khách hàng có số tiền mua từ đầu năm đến nay nhiều hơn 50 triệu đồng
SELECT hdb.MaKH, SUM(hdb.SoLuong * hdb.DonGia) AS TongTien
FROM HoaDonBan hdb
WHERE Ngay >= '2023-01-01'
GROUP BY hdb.MaKH
HAVING SUM(hdb.SoLuong * hdb.DonGia) > 50000000;

--11. Liệt kê những nhà cung cấp nào cung cấp hàng cho cửa hàng nhiều nhất trong năm 2021 (tiêu chuẩn: tổng giá trị của hàng hoá)
SELECT cc.MaNCC, SUM(cc.SoLuong * bbg.GiaBan) AS TongGiaTri
FROM CungCap cc
INNER JOIN BangBaoGia bbg ON cc.MaNCC = bbg.MaNCC AND cc.MaHH = bbg.MaHH
WHERE YEAR(cc.Ngay) = 2021
GROUP BY cc.MaNCC
ORDER BY TongGiaTri DESC;



--12. Liệt kê các mặt hàng bán đắt nhất trong năm 2020
SELECT hh.MaHH, hh.TenHH, MAX(hdb.DonGia) AS GiaCaoNhat
FROM HoaDonBan hdb
INNER JOIN HangHoa hh ON hdb.MaHH = hh.MaHH
WHERE YEAR(hdb.Ngay) = 2020
GROUP BY hh.MaHH, hh.TenHH
HAVING MAX(hdb.DonGia) = (
    SELECT MAX(DonGia)
    FROM HoaDonBan
    WHERE YEAR(Ngay) = 2020
);
