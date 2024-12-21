--11.4. Bai tap tu làm
USE QLSV
--1 Hiển thị thông tin về các các sinh viên sinh ở Hưng Yên và chưa có điểm môn nào.
--Thông tin gồm MaSV, Hoten, GioiTinh. 
SELECT s.masv, s.hoten, gioitinh = 
     CASE WHEN gioitinh = 0 THEN N'Nữ'
	     ELSE N'Nam'
	 END
FROM SinhVien as s 
LEFT JOIN DiemThi as d ON S.masv = D.masv
WHERE s.noisinh = N'Hưng Yên' AND d.masv IS NULL

--2. Hiển thị thông của các sinh viên quê ở Thái Nguyên có tuổi lớn hơn 18 và điểm lần 
--1 của môn ‘CSDL’ lớn hơn 8. Thông tin hiển thị gồm: Mã sinh viên, họ tên, giới 
--tính, nơi sinh, tuổi. (Biết rằng, tuổi của sinh viên được tính đến năm hiện tại)
SELECT s.masv, hoten, gioitinh = 
       CASE WHEN gioitinh = 0 THEN N'Nữ'
	        ELSE N'Nam'
	   END,
	   DATEDIFF(YEAR, s.ngaysinh, GETDATE()) as Tuoi
FROM SinhVien as s 
INNER JOIN DiemThi as d ON s.masv = d.masv
INNER JOIN MonHoc as h ON h.mamonhoc = d.mamonhoc
WHERE s.noisinh = N'Thái Nguyên' AND h.tenmonhoc = 'CSDL' AND d.diemlan1 > 8 AND DATEDIFF(YEAR, s.ngaysinh, GETDATE()) >= 18


--3. Hiển thị thông tin về các khoa có các sinh viên đã từng học môn học có tên "Hệ quản trị CSDL"
SELECT DISTINCT k.makhoa, k.tenkhoa 
FROM Khoa k 
INNER JOIN Lop as l ON k.makhoa = l.makhoa
INNER JOIN SinhVien as s ON s.malop = l.malop
INNER JOIN DiemThi as d ON d.masv = s.masv
INNER JOIN MonHoc m ON m.mamonhoc = d.mamonhoc
WHERE m.tenmonhoc = N'Hệ quản trị CSDL'


--4.  Hien thi thong tin cua 50% sinh vien dau tien co tuoi cao nhat 
SELECT TOP 50 PERCENT * 
FROM SinhVien as s 
ORDER BY DATEDIFF(YEAR, s.ngaysinh, GETDATE())


--5. Thống kê số lượng sinh viên theo từng khoa (Sử dụng GROUP BY, GROUP BY 
--với một số toán tử CUBE,…)
SELECT k.makhoa, k.tenkhoa, s.gioitinh, COUNT(s.masv) as so_luonh_sinhvien
FROM SinhVien as s 
INNER JOIN Lop as l ON l.malop = s.malop
INNER JOIN Khoa as k ON l.makhoa = k.makhoa
GROUP BY CUBE(k.makhoa, k.tenkhoa, s.gioitinh)
ORDER BY k.makhoa, k.tenkhoa, s.gioitinh


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
	m.tenmonhoc = 'Lập trình C#' AND d.diemlan1 = (
	SELECT MAX(d.diemlan1)
	FROM DiemThi as d 
	INNER JOIN MonHoc as m 
	ON d.mamonhoc = m.mamonhoc
	WHERE m.tenmonhoc = 'Lập trinhh C#'
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
    d.kihoc = 1  
GROUP BY 
    s.masv, s.hoten
ORDER BY 
    DiemTBL1 DESC;



--10.. Hiển thị 5 sinh viên đầu tiên có tuổi được sắp xếp từ thấp ->cao thuộc khoa có mã 
--là ‘CNTT’.
SELECT TOP 5 
	s.masv,
	s.hoten,
	YEAR(GETDATE()) - YEAR(s.ngaysinh) AS Tuoi
FROM SinhVien s 
INNER JOIN Lop l On l.malop = s.malop
INNER JOIN Khoa k ON l.makhoa = k.makhoa
WHERE k.makhoa = 'CNTT'
ORDER BY Tuoi ASC



--11. Hiển thị thông tin các sinh viên bị trượt ít nhất một môn (sử dụng truy vấn con và 
--từ khóa EXISTS hoặc IN)
--Dung EXISTS 
SELECT s.masv, s.hoten, s.ngaysinh
FROM SinhVien s 
WHERE EXISTS(
	SELECT 1 
	FROM DiemThi d 
	WHERE d.masv = s.masv
	AND d.diemlan1 < 5
)

--Dung IN 
SELECT s.masv, s.hoten, s.ngaysinh 
FROM SinhVien s 
WHERE s.masv IN (
	SELECT d.masv
	FROM DiemThi d 
	WHERE d.diemlan1 < 5
)

--12. Cho biết danh sách sinh viên đã học hết tất các môn trong bảng monhoc
SELECT s.masv, s.hoten 
FROM SinhVien s 
WHERE NOT EXISTS(
	SELECT 1 
	FROM MonHoc m
	WHERE NOT EXISTS(
	SELECT 1 
	FROM DiemThi d 
	WHERE d.masv = s.masv
	AND d.mamonhoc = m.mamonhoc

	)
)


--13.Thực hiện việc phân hạng cho môn học theo sotc (sử dụng tất cả các hàm phân 
--hạng)
SELECT 
	mamonhoc,
	tenmonhoc,
	sotc,
	RANK() OVER (ORDER BY sotc DESC) AS RANK,
	DENSE_RANK() OVER (ORDER BY sotc DESC) as DenseRank,
	ROW_NUMBER() OVER (ORDER BY sotc DESC) as RowNumber
FROM MonHoc

--14. Thống kê số lượng sinh viên của từng khoa theo giới tính (sử dụng toán tử PIVOT)
SELECT makhoa, 
	ISNULL([0], 0) AS Nu,
	ISNULL([1], 0) AS Nam
FROM 
(
	SELECT l.makhoa, s.gioitinh
	FROM SinhVien s 
	INNER JOIN Lop l ON s.malop = l.malop
) AS SourceTable 
PIVOT
(
	COUNT(gioitinh) 
	FOR gioitinh IN ([0], [1])
) AS PivotTable


--16. Tạo View có tên là w_cau1 lưu trữ các thông tin: Họ tên sinh viên, giới tính, tên 
--môn học, điểm thi lần 1 của sinh viên đó (bằng 2 cách)
CREATE VIEW w_cau1 AS 
SELECT 
	s.hoten,
	IIF(S.gioitinh = 1, N'Nam', N'Nữ') as GioiTinh,
	m.tenmonhoc,
	d.diemlan1
FROM SinhVien s 
JOIN DiemThi d ON s.masv = d.masv
JOIN MonHoc M ON d.mamonhoc = m.mamonhoc

SELECT * FROM w_cau1

--17. Sửa đổi view vừa tạo thành view chỉ lưu trữ Họ tên sinh viên, giới tính, điểm thi 
--lần 1 (bằng 2 cách)
ALTER VIEW w_cau1 
AS 
SELECT s.HoTen,
       IIF(s.GioiTinh = 1, 'Nam', N'Nữ') as GioiTinh,
	   d.DiemLan1
FROM SinhVien s 
JOIN DiemThi d ON s.masv = d.masv


--18. Tạo view có tên là w_cau3 lưu trữ thông tin gồm mã môn học và số lượng sinh 
--viên đã học môn học đó.
CREATE VIEW w_cau3 AS 
SELECT d.mamonhoc, COUNT(DISTINCT d.masv) AS SoLuongSinhVien
FROM DiemThi d 
GROUP BY d.mamonhoc

--19. Tạo view có tên là w_cau4 lưu trữ thông tin gồm mã lớp, tên lớp, số lượng sinh 
--viên của lớp tương ứng (được tính thông qua cột masv)
CREATE VIEW w_cau4 AS 
SELECT l.malop, l.tenlop, COUNT(s.masv) as SoLuongSinhVien
FROM Lop l 
LEFT JOIN SinhVien s ON l.malop = s.malop
GROUP BY l.malop, l.tenlop

--20. Tạo view có tên là w_cau5 cho biết tên của sinh viên chưa học môn nào (chưa có 
--điểm môn học đó)
CREATE VIEW w_cau5 AS
SELECT s.masv, s.hoten
FROM SinhVien s 
WHERE NOT EXISTS(
	SELECT 1 
	FROM DiemThi d 
	WHERE d.masv = s.masv
)


--21. Tạo ra view View_Ttkhoa gồm các thông tin: mã khoa, tên khoa, địa điểm. Sau 
--đó thực hiện các thao tác truy vấn, cập nhật dữ liệu thông qua view View_Ttkhoa 
--đã tạo.
CREATE VIEW View_Ttkhoa AS 
SELECT k.makhoa, k.tenkhoa, k.diadiem
FROM Khoa k
 

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
    PRINT N'Mã sinh viên: ' + @masv + N', Điểm thi lần 1 cao nhất: ' + CONVERT(NVARCHAR, @max_score);
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
	BEGIN TRANSACTION 

	--Kiểm tra và chèn dữ liệu vào bảng Lop
	INSERT INTO Lop(malop, tenlop, siso)
	VALUES('L001', N'Lớp CNTT', 30);

	--Kiểm tra một số điều kiện cụ thể, ví dụ sĩ số không vượt quá 50 
	 DECLARE @siso INT;
	SELECT @siso = siso FROM Lop WHERE malop = 'L001';

	IF(@siso > 50)
	BEGIN 
		--Nếu sĩ số lớp hơn 50, rollback transaction
		ROLLBACK TRANSACTION;
		 PRINT 'Sĩ số lớp vượt quá giới hạn. Giao dịch đã bị hủy.';
	END 
	ELSE 
	BEGIN 
	   --Nếu không có vấn đề, commit transaction
	   COMMIT TRANSACTION;
	   PRINT 'Giao dịch thành công, dữ liệu đã được cập nhật.'
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
	BEGIN TRANSACTION 

	--Thêm sinh viên vào lớp
	INSERT INTO SinhVien(masv, hoten, malop)
	VALUES('SV001', N'Trần Văn B', 'L001')

	--Cập nhật lại sĩ số của lớp
	UPDATE Lop 
	SET siso = siso + 1
	WHERE malop = 'L001'

	--Kiểm tra nếu sĩ số vượt quá giới hạn (ví dụ 50 sinh viên)
	DECLARE @siso INT;	
	SELECT @siso = siso FROM Lop WHERE malop = 'L001';


	IF @siso > 50 
	BEGIN 
		--Nếu sĩ số vượt quá giới hạn, rollback transaction
		ROLLBACK TRANSACTION;
		PRINT N'Sĩ số lớp vượt quá giới hạn. Giao dịch đã bị hủy.'
	END 
	ELSE 
	BEGIN 
		--Nếu không có vấn đề ,commit transaction
		COMMIT TRANSACTION;
		PRINT 'Sinh viên đã được thêm vào lớp và sĩ số đã được cập nhật.';
	END 
END TRY 
BEGIN CATCH 
	--Nếu có lỗi xảy ra, rollback transaction và thông báo lỗi 
	ROLLBACK TRANSACTION;
	PRINT N'Có lỗi xảy ra: ' + ERROR_MESSAGE();
END CATCH;