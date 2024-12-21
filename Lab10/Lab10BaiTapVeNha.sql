--Tạo CSDL
CREATE DATABASE QNNS
USE QLNS

CREATE TABLE Phong (
	Maphong CHAR(5) PRIMARY KEY,
	TenPhong NVARCHAR(50),
	MaTP INT
)


CREATE TABLE NhanVien (
	MaNV CHAR(5) ,
	Hoten NVARCHAR(50),
	Gioitinh CHAR(5),
	Maphong CHAR(5),
	Luong INT,
	NgaySinh DATETIME,
	Quequan NVARCHAR(50)
)

CREATE TABLE DiaDiem(
	MaPhong CHAR(5),
	DiaDiem VARCHAR(50),
	FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong)
)

CREATE TABLE Duan (
	MADA CHAR(5) PRIMARY KEY,
	TenDA VARCHAR(5),
	DiaDiemDA VARCHAR(50),
	MaPhong CHAR(5),
	FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong)
)


CREATE TABLE ChamCong(
	MANV CHAR(5) PRIMARY KEY,
	MaDA CHAR(5),
	SoGio INT,
	FOREIGN KEY (MaDA) REFERENCES DUAN(MaDA) 
)


ALTER TABLE ChamCong 
ADD NgayThamGia DATE 

--Insert data mẫu 

INSERT INTO Phong (Maphong, TenPhong, MaTP)
VALUES 
('P001', N'Phòng A', 1),
('P002', N'Phòng B', 2),
('P003', N'Phòng C', 3),
('P004', N'Phòng D', 4),
('P005', N'Phòng E', 5),
('P006', N'Phòng F', 6),
('P007', N'Phòng G', 7),
('P008', N'Phòng H', 8),
('P009', N'Phòng I', 9),
('P010', N'Phòng J', 10);

INSERT INTO NhanVien (MaNV, Hoten, Gioitinh, Maphong, Luong, NgaySinh, Quequan)
VALUES 
('NV001', N'Nguyễn Văn An', 'Nam', 'P001', 8000000, '1985-01-01', N'Hà Nội'),
('NV002', N'Trần Thị B', 'Nữ', 'P002', 7500000, '1990-02-14', N'Thái Bình'),
('NV003', N'Phạm Hoàng C', 'Nam', 'P003', 9000000, '1987-03-23', N'Nam Định'),
('NV004', N'Le Minh D', 'Nam', 'P004', 8500000, '1992-05-12', N'Hải Phòng'),
('NV005', N'Vũ Lan E', 'Nữ', 'P005', 9500000, '1995-06-25', N'Hà Nội'),
('NV006', N'Trương Đào F', 'Nữ', 'P006', 10000000, '1989-08-30', N'Hà Giang'),
('NV007', N'Nguyễn Bình An', 'Nam', 'P007', 8000000, '1993-09-17', N'Tuyên Quang'),
('NV008', N'Đặng Kim H', 'Nữ', 'P008', 7800000, '1990-11-05', N'Hải Dương'),
('NV009', N'Hồ Minh I', 'Nam', 'P009', 7000000, '1986-04-10', N'Son La'),
('NV010', N'Lê Thanh An', 'Nữ', 'P010', 7200000, '1994-12-15', N'Thái Nguyên');


INSERT INTO DiaDiem (MaPhong, DiaDiem)
VALUES
('P001', N'Tòa nhà A'),
('P002', N'Tòa nhà B'),
('P003', N'Tòa nhà C'),
('P004', N'Tòa nhà D'),
('P005', N'Tòa nhà E'),
('P006', N'Tòa nhà F'),
('P007', N'Tòa nhà G'),
('P008', N'Tòa nhà H'),
('P009', N'Tòa nhà I'),
('P010', N'Tòa nhà J');



INSERT INTO Duan (MADA, TenDA, DiaDiemDA, MaPhong)
VALUES
('DA001', 'DA1', 'Hà Nội', 'P001'),
('DA002', 'DA2', 'Hải Phòng', 'P002'),
('DA003', 'DA3', 'Nam Định', 'P003'),
('DA004', 'DA4', 'Thái Nguyên', 'P004'),
('DA005', 'DA5', 'Sơn La', 'P005'),
('DA006', 'DA6', 'Tuyên Quang', 'P006'),
('DA007', 'DA7', 'Hải Dương', 'P007'),
('DA008', 'DA8', 'Thái Bình', 'P008'),
('DA009', 'DA9', 'Hà Giang', 'P009'),
('DA010', 'DA10', 'Hà Nội', 'P010');

INSERT INTO ChamCong (MANV, MaDA, SoGio)
VALUES
('NV001', 'DA001', 160),
('NV002', 'DA002', 170),
('NV003', 'DA003', 180),
('NV004', 'DA004', 150),
('NV005', 'DA005', 165),
('NV006', 'DA006', 175),
('NV007', 'DA007', 190),
('NV008', 'DA008', 160),
('NV009', 'DA009', 180),
('NV010', 'DA010', 150);


--1. Đưa ra danh sách những nhân viên có quê ở Hà Nội
SELECT * 
FROM NhanVien 
WHERE Quequan = N'Hà Nội'


--2. Hiển thị thông tin của những nhân viên có tên 'An'
SELECT * 
FROM NhanVien 
WHERE HoTen LIKE '%An%'


--3. Hien thi thong tin cua nhung nhan vien co luong nho hon 5000000
SELECT * FROM NhanVien 
WHERE Luong < 5000000

--4. Hien thi thong tin cua nhung nhan vien co luong cao nhat 
SELECT * FROM NhanVien 
WHERE Luong = 
(
	SELECT MAX(Luong)
	FROM NhanVien
)

--5. Tìm tên của nhân viên có lương nhỏ hơn nhân viên có mã 'NV001'
SELECT * FROM NhanVien
WHERE Luong < 
   (
		SELECT Luong FROM NhanVien 
		WHERE MaNV = 'NV001'
   )

--6. Dua ra danh sach nhan vien chua tham gia du an nao. 
SELECT * FROM NhanVien as n 
LEFT JOIN ChamCong as c ON n.MaNV = C.MANV
WHERE c.MANV IS NULL


--7.Tăng lương cho nhân viên. Nếu nhân viên đó có số giờ tham gia 1 dự án <10 
--giờ thì tăng lương của nhân viên đó lên 10%, nếu số giờ tham gia lớn hơn 10 và 
--nhỏ hơn 50 thì tăng 5% lương.
UPDATE NhanVien 
SET Luong = 
   CASE 
		WHEN c.SoGio < 10 THEN Luong + Luong * 0.1 
		WHEN c.SoGio >= 10 AND c.SoGio < 50 THEN Luong + Luong * 0.05
	    ELSE Luong 
	END
FROM NhanVien as n 
INNER JOIN ChamCong as c ON n.MaNV = c.MANV

--8. Hiện thị thông tin về các dự án, sắp xếp tên các dự án giảm theo số giờ tham 
--gia
SELECT d.MADA, d.TenDA, d.DiaDiemDA, c.SoGio
FROM Duan as d 
INNER JOIN ChamCong as c 
ON d.MADA = c.MaDA
ORDER BY c.SoGio DESC 

--9. Đưa ra tên phòng có nhân viên tham gia dự án trong tháng 6 năm 2020
SELECT DISTINCT p.TenPhong 
FROM Phong as p 
INNER JOIN NhanVien as n 
ON p.Maphong = n.Maphong
INNER JOIN ChamCong as c 
ON c.MANV = n.MaNV
WHERE YEAR(c.NgayThamGia) = 2020 AND MONTH(c.NgayThamGia) = 6


--10. Tăng lương 10% cho nhân viên nhiều tuổi nhất trong công ty nhân dịp Tết 
--dương lịch
UPDATE NhanVien 
SET Luong = Luong * 1.1 
WHERE MaNV = (
	SELECT TOP 1 MaNV
	FROM NhanVien
	ORDER BY DATEDIFF(YEAR, NgaySinh, GETDATE()) DESC
)


--11. Tinh tong so nhan vien tham gia moi du an trong nam 2022
SELECT d.MaDA, d.TenDA, COUNT(n.MaNV) as 'SoLuongNhanVien'
FROM NhanVien as n 
INNER JOIN ChamCong as c 
ON n.MaNV = C.MANV
INNER JOIN Duan as d 
ON d.MADA = C.MaDA
WHERE YEAR(c.NgayThamGia) = 2020
GROUP BY d.MaDA, d.TenDA


--12. Hien thi thong tin ve cac phong co so nhan vien nhieu nhat 
SELECT p.MaPhong, p.TenPhong, p.MaTP, COUNT(MaNV) as soLuong
FROM Phong as p 
INNER JOIN NhanVien as n 
ON p.Maphong = n.Maphong
GROUP BY p.Maphong, p.TenPhong, p.MaTP
ORDER BY soLuong DESC