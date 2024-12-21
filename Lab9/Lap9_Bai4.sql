-- Tạo bảng SVtam từ bảng SinhVien
USE QLSV
SELECT *
INTO SVtam
FROM SinhVien;


-- Thiết lập lại khóa chính cho bảng SVtam
ALTER TABLE SVtam
ADD CONSTRAINT PK_SVtam PRIMARY KEY (Masv);

--2.Tạo chỉ mục Nonclustered trên cột Hoten
CREATE NONCLUSTERED INDEX IX_Hoten ON SVtam (Hoten);


--3. Tạo chỉ mục Nonclustered phức hợp trên hai cột Hoten và NoiSinh
CREATE NONCLUSTERED INDEX IX_Hoten_NoiSinh ON SVtam (Hoten, NoiSinh);

--4.  Xem lại các chỉ mục đang có trên bảng SinhVien
-- Xem tất cả chỉ mục của bảng SinhVien
SELECT * 
FROM sys.indexes
WHERE object_id = OBJECT_ID('SVtam');


--5. Tìm kiếm thông tin các sinh viên có họ "Nguyễn" bằng cách sử dụng chỉ mục được tạo trong câu 2
SELECT * 
FROM SinhVien
WHERE Hoten = 'Nguyễn';



--6. Tìm kiếm tất cả các Sinh viên tên là "Lan" và nơi sinh ở "Hưng Yên" bằng cách sử dụng chỉ mục được tạo trong câu 3
SELECT * 
FROM SinhVien
WHERE Hoten = 'Lan' AND NoiSinh = 'Hưng Yên';


--7. Xóa các chỉ mục đã được tạo trong câu 2-3
-- Xóa chỉ mục Nonclustered trên cột Hoten
DROP INDEX IX_Hoten ON SVtam;

-- Xóa chỉ mục Nonclustered phức hợp trên cột Hoten và NoiSinh
DROP INDEX IX_Hoten_NoiSinh ON SVtam;


--8. Xóa ràng buộc khóa chính khỏi bảng SVtam
ALTER TABLE SVtam
DROP CONSTRAINT PK_SVtam;


--9. Tạo lại khóa chính trên bảng SVtam, sử dụng tùy chọn NonClustered để SQL Server không tạo chỉ mục Clustered
ALTER TABLE SVtam
ADD CONSTRAINT PK_SVtam PRIMARY KEY NONCLUSTERED (Masv);


--10. Tạo chỉ mục Clustered và Unique trên cột Masv với hệ số điền đầy bằng 60
CREATE CLUSTERED INDEX IX_Clustered_Masv ON SVtam (Masv) 
WITH (FILLFACTOR = 60);
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Masv ON SinhVien (Masv);

--11. Thiết lập chỉ mục tìm kiếm toàn văn trên cột Hoten
-- Tạo một chỉ mục toàn văn trên cột Hoten
CREATE FULLTEXT INDEX ON SVtam (hoten)
KEY INDEX PK_SVtam;  -- Khóa chính là chỉ mục khóa


--12.12. Tìm kiếm tất cả các cuốn sách có tên sách chứa từ 'Văn' hoặc 'Nguyễn' (nếu có bảng sách)
SELECT * 
FROM SACH
WHERE CONTAINS(TenSach, '"Văn" OR "Nguyễn"');
