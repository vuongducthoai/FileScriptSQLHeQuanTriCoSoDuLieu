CREATE LOGIN sv1 WITH PASSWORD = '123';
CREATE LOGIN sv2 WITH PASSWORD = '123';
CREATE LOGIN sv3 WITH PASSWORD = '123';
CREATE LOGIN gv1 WITH PASSWORD = '123';
CREATE LOGIN gv2 WITH PASSWORD = '123';

USE QLSV

CREATE USER SinhVien1 FOR LOGIN sv1
CREATE USER SinhVien2 FOR LOGIN sv2 
CREATE USER SinhVien3 FOR LOGIN sv3 
CREATE USER GiaoVien1 FOR LOGIN gv1 
CREATE USER GiaoVien2 FOR LOGIN gv2



--4. Thiết lập quyền hạn cho GiaoVien1 có toàn quyền thao tác trên bảng SINHVIEN
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.SinhVien TO GiaoVien1

--5. Thêm NSD ‘GiaoVien1’, ‘GiaoVien2’ vào nhóm ‘GiaoVien’ bằng cả 2 cách
--Cach1 : Dung cong cu SQL 
CREATE ROLE GiaoVien 
ALTER ROLE GiaoVien ADD MEMBER GiaoVien1
ALTER ROLE GiaoVien ADD MEMBER GiaoVien2

--6. Phan quyền cho nhóm GiaoVien trong CSDL quyền tạo lập bảng mới
GRANT CREATE TABLE TO GiaoVien


--7. Phân quyền cho SinhVien1 trong CSDL có quyền chèn, thêm  dữ liệu, đọc dữ liệu mhuwng không có quyền sửa 
-- và xóa dữ liệu trên bảng Khoa
--Cap quyen cho SinhVien1
GRANT SELECT, INSERT ON dbo.Khoa TO SinhVien1;

--Khong cap quyen UPDATE và DELETE 
DENY UPDATE, DELETE ON dbo.Khoa TO SinhVien1


--8. Phân quyền cho SinhVien2 trong CSDL được sửa và xóa dữ liệu MonHoc
GRANT UPDATE, DELETE ON dbo.MonHoc TO SinhVien2

--9. Phần quyền cho SinhVien3 trong CSDL được truy vấn dữ liệu trên bảng MonHoc 
GRANT SELECT ON dbo.MonHoc TO SinhVien3

--10.Đăng nhập bằng các tài khoản trên sau đó thử thực hiện một thao tác mà NSD đó không 
--có quyền.
UPDATE dbo.Khoa SET tenKhoa = 'Khoa mới' WHERE makhoa = 'K01'; -- Sẽ bị lỗi vì sv1 không có quyền UPDATE


--11. Đăng nhập với tài khoản sa để thu hồi các quyền của các người dùng mà sa đã cấp
-- Thu hồi quyền của GiaoVien1 trên bảng SINHVIEN
REVOKE SELECT, INSERT, UPDATE, DELETE ON dbo.SINHVIEN TO gv1;

-- Thu hồi quyền CREATE TABLE từ nhóm GiaoVien
REVOKE CREATE TABLE TO GiaoVien;

-- Thu hồi quyền của SinhVien1 trên bảng Khoa
REVOKE SELECT, INSERT ON dbo.Khoa TO sv1;
REVOKE UPDATE, DELETE ON dbo.Khoa TO sv1;

-- Thu hồi quyền sửa và xoá của SinhVien2 trên bảng Monhoc
REVOKE UPDATE, DELETE ON dbo.Monhoc TO sv2;

-- Thu hồi quyền truy vấn dữ liệu của SinhVien3 trên bảng Monhoc
REVOKE SELECT ON dbo.Monhoc TO sv3;


