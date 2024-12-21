--Bai  tap tu lam 
--Viet thu tuc 
--1. Tính số lượng lớp của khoa có mã là ‘CNTT
CREATE PROC sp_SLLop
	@TenKhoa NVARCHAR(50),
	@SLLop INT OUTPUT 
AS 
BEGIN 
   SELECT @SLLop = COUNT(*) 
   FROM Lop as l INNER JOIN Khoa as k 
   ON l.makhoa = K.makhoa
   where K.tenkhoa = @TenKhoa
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


--3.Tinh diem trung binh lan 1 cua hoc ki 1 cua mot sinh vien bat ki 
CREATE PROC sp_DiemTB 
 @masv NVARCHAR(50)
AS
BEGIN 
	DECLARE @DTB decimal(10,2);
	SELECT @DTB = AVG(diemLan1)
	FROM DiemThi 
	WHERE masv = @masv

	SELECT @DTB AS DiemTB;
END 

EXEC sp_DiemTB 'SV01'


--4.Hiển thị thông tin của các sinh viên thuộc một khoa và một khóa bất kì.
CREATE PROCEDURE sp_DSSV_4
@tenKhoa NVARCHAR(50), 
@khoa NVARCHAR(10)
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


EXEC DSSV_C5 'CNTT' , 3



--6.Hiển thị thông tin của các sinh viên thuộc Khoa nào và Khóa học nào phải học nhiều môn nhất trong toàn trường
--sinh viên đó đã có điểm môn học tương ứng
CREATE PROCEDURE dbo.sp_ThongTinSinhVienMonHocMax
AS
BEGIN
    WITH MonHocCounts AS (
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
        SELECT 
            MAX(soMon) AS maxMonHoc
        FROM 
            MonHocCounts
    )

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
END
GO

EXEC dbo.sp_ThongTinSinhVienMonHocMax;

--7. . Hiển thị thông tin của các sinh viên của một lớp bất kì đã học nhiều môn nhất. 
--(sinh viên đó đã có điểm lần 1 của các môn học đó)

CREATE PROCEDURE dbo.sp_ThongTinSinhVienMonHocMax1
AS
BEGIN
    WITH MonHocCounts AS (
        SELECT 
            s.masv, 
            l.makhoa, 
            l.khoa, 
            COUNT(dt.mamonhoc) AS soMon
        FROM 
            SinhVien s
        INNER JOIN Lop l ON s.malop = l.malop
        LEFT JOIN DiemThi dt ON s.masv = dt.masv
        WHERE dt.diemlan1 IS NOT NULL  
        GROUP BY 
            s.masv, l.makhoa, l.khoa
    ),
    
    MaxMonHoc AS (
        SELECT 
            MAX(soMon) AS maxMonHoc
        FROM 
            MonHocCounts
    )

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
END
GO


EXEC dbo.sp_ThongTinSinhVienMonHocMax1;


--8. Hiển thị thông tin những môn học thuộc Khoa 'CNTT', khóa K21 hiện nay chưa 
-- có sinh viên nào học (sinh viên chưa có điểm)
CREATE PROC sp_ThongTinMonHocChuaCoDiem
AS 
BEGIN 
	SELECT m.mamonhoc, m.tenmonhoc
	FROM MonHoc m
	INNER JOIN DiemThi as d ON m.mamonhoc = d.mamonhoc
	INNER JOIN SinhVien as s ON s.masv = d.masv
	INNER JOIN Lop l ON s.malop= l.malop
	INNER JOIN Khoa k ON l.makhoa = k.makhoa
	WHERE k.tenkhoa = 'CNTT'
	  AND l.khoa = 'K21'
	  AND NOT EXISTS (
		  SELECT 1
		  FROM DiemThi dt
		  WHERE dt.mamonhoc = m.mamonhoc
	  )
	ORDER BY m.mamonhoc;
END 


EXEC sp_ThongTinMonHocChuaCoDiem

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
        IF EXISTS (SELECT 1 FROM MonHoc WHERE mamonhoc = @mamon)
        BEGIN
            -- Chèn dữ liệu vào bảng DiemThi nếu cả hai mã sinh viên và mã môn học đều tồn tại
            INSERT INTO DiemThi (masv, mamonhoc, diemlan1)
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

EXEC InsertDiemThi @masv = 'SV001', @mamon = 'CSDL', @diem = 8.5;

SELECT * FROM DiemThi



--10. xóa thông tin sinh viên có mã bất kì 
CREATE PROCEDURE dbo.sp_XoaSinhVien
    @Masv NVARCHAR(50) 
AS
BEGIN
    IF EXISTS (SELECT 1 FROM SinhVien WHERE masv = @Masv)
    BEGIN
        DELETE FROM DiemThi WHERE masv = @Masv;

        DELETE FROM SinhVien WHERE masv = @Masv;

        PRINT 'Sinh viên với mã ' + @Masv + ' đã được xóa thành công.';
    END
    ELSE
    BEGIN
        PRINT 'Sinh viên với mã ' + @Masv + ' không tồn tại.';
    END
END
GO

EXEC sp_XoaSinhVien 'SV001'


--11. Cập nhật thông tin về địa điểm của khoa có mã ‘CNTT’.
CREATE PROCEDURE dbo.sp_CapNhatDiaDiemKhoa
    @DiaDiemMoi NVARCHAR(200) 
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Khoa WHERE makhoa = 'CNTT')
    BEGIN
        UPDATE Khoa
        SET DiaDiem = @DiaDiemMoi
        WHERE makhoa = 'CNTT';

        PRINT 'Địa điểm của khoa CNTT đã được cập nhật thành công.';
    END
    ELSE
    BEGIN
        PRINT 'Khoa với mã CNTT không tồn tại.';
    END
END
GO

EXEC sp_CapNhatDiaDiemKhoa 'CS1'


--13. Viết thủ tục có tác dụng nhập dữ liệu vào bảng môn học. Biết rằng, chỉ cho phép 
--nhập các môn học có mã chưa tồn tại và giá trị của cột mã môn học phải thỏa 
--mãn: 2 kí đầu là ‘MH’, còn các kí tự sau là số, ví dụ: MH000001, MH000002,…
CREATE PROCEDURE sp_ThemMonHoc
    @mamonhoc NVARCHAR(10),
    @tenmonhoc NVARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM MonHoc WHERE mamonhoc = @mamonhoc)
    BEGIN
        PRINT N'Mã môn học đã tồn tại!';
        RETURN -1;
    END

    IF NOT @mamonhoc LIKE 'MH[0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        PRINT N'Mã môn học không đúng định dạng, phải là "MH" theo sau 6 chữ số!';
        RETURN -2;
    END

    INSERT INTO MonHoc (mamonhoc, tenmonhoc)
    VALUES (@mamonhoc, @tenmonhoc);

    PRINT N'Môn học đã được thêm thành công!';
END;
GO

SELECT * FROM MonHoc
EXEC sp_ThemMonHoc 'MH000001' , 'He QUAN TRI CSDL'
 