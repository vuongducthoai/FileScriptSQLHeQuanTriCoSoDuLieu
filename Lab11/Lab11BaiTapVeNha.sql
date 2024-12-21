--Bài tập về nhà 
CREATE DATABASE LinhKienMayTinh;
USE LinhKienMayTinh

CREATE TABLE PhanLoai(
	MaLoai INT PRIMARY KEY,
	TenLoai NVARCHAR(100) NOT NULL
);

-- Tạo bảng NhàCungCap
CREATE TABLE NhaCungCap (
    MaNCC INT PRIMARY KEY,             
    TenNCC NVARCHAR(100) NOT NULL,     
    DiaChi NVARCHAR(200) NOT NULL,      
    DienThoai VARCHAR(15) NOT NULL    
);


CREATE TABLE KhachHang (
	MaKH INT PRIMARY KEY,
	TenKH NVARCHAR(100) NOT NULL,
	DiaChi NVARCHAR(200) NOT NULL,
	DienThoai VARCHAR(15) NOT NULL
)


-- Tạo bảng HangHoa
CREATE TABLE HangHoa (
    MaHH INT PRIMARY KEY,              
    TenHH NVARCHAR(100) NOT NULL,      
    DonViTinh NVARCHAR(50) NOT NULL,    
    MaLoai INT,                         
    FOREIGN KEY (MaLoai) REFERENCES PhanLoai(MaLoai)  
);

-- Tạo bảng BangBaoGia
CREATE TABLE BangBaoGia (
    MaNCC INT,                        
    MaHH INT,                          
    GiaBan FLOAT NOT NULL,            
    PRIMARY KEY (MaNCC, MaHH),         
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC),
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH)     
);

-- Tạo bảng CungCap
CREATE TABLE CungCap (
    MaNCC INT,                         
    MaHH INT,                          
    Ngay DATE NOT NULL,               
    SoLuong INT NOT NULL,              
    PRIMARY KEY (MaNCC, MaHH, Ngay),   
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC),  
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH)      
);

-- Tạo bảng HoaDonBan
CREATE TABLE HoaDonBan (
    MaHD INT PRIMARY KEY,             
    MaKH INT,                          
    MaHH INT,                           
    Ngay DATE NOT NULL,                
    SoLuong INT NOT NULL,              
    DonGia FLOAT NOT NULL,              
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH), 
    FOREIGN KEY (MaHH) REFERENCES HangHoa(MaHH)   
);



--Chen dữ liệu mẫu vào các bảng
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
WHERE pl.TenLoai = N'Màn Hình'

--2. Liệt kê tất cả các nhà cung cấp ở thành phố Hồ Chí Minh
SELECT MaNCC, TenNCC, DiaChi, DienThoai
FROM NhaCungCap 
WHERE DiaChi LIKE N'%TP.HCM'

--3. Liệt kê những khách hàng có tên bắt đầu bằng chữ “H”
SELECT MaKh, TenKH, DiaChi, DienThoai
FROM KhachHang
WHERE TenKH LIKE N'H%'

--4. Liệt kê đầy đủ thông tin của các nhà cung cấp đã từng cung cấp mặt hàng có tên là “CD LG 52X”
SELECT DISTINCT ncc.MaNCC, ncc.TenNCC, ncc.DiaChi, ncc.DienThoai
FROM NhaCungCap ncc
INNER JOIN CungCap cc ON ncc.MaNCC = cc.MaNCC
INNER JOIN HangHoa hh ON hh.MaHH = cc.MaHH
WHERE hh.TenHH = N'CD LG 52X'


--5. Liệt kê mã số và tên của các mặt hàng hiện không có nhà cung cấp nào cung cấp
SELECT hh.MaHH, hh.TenHH
FROM HangHoa hh
LEFT JOIN CungCap cc ON hh.MaHH = cc.MaHH
WHERE cc.MaNCC IS NULL



--6. Liệt kê những khách hàng mua nhiều hơn một lần trong một ngày (có từ hai hoá đơn trở lên) 
--trong khoảng thời gian từ 01/01/2021 đến 31/10/2021
SELECT MaKH, COUNT(*) as SoLanMua, Ngay
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
INNER JOIN HoaDonBan hdb ON kh.MaKH = hdb.MaHH

--9. Liệt kê tất cả các khách hàng thân thuộc trong năm 2021 (nhiều hơn 10 lần mua trong năm đó)
SELECT MaKH
FROM HoaDonBan 
WHERE YEAR(Ngay) = 2021
GROUP BY MaKH
HAVING COUNT(*) > 10


--10 Liệt kê tất cả các khách hàng tiềm năng: Là những khách hàng có số tiền mua từ đầu năm đến nay 
--nhiều hơn 50 triệu đồng
SELECT hdb.MaKH, SUM(hdb.SoLuong * hdb.DonGia) AS TongTien
FROM HoaDonBan hdb
WHERE Ngay >= '2023-01-01'
GROUP BY hdb.MaKH
HAVING SUM(hdb.SoLuong * hdb.DonGia) > 50000000;


--11. Liệt kê những nhà cung cấp nào cung cấp hàng cho cửa hàng nhiều nhất trong năm 2021 
--(tiêu chuẩn: tổng giá trị của hàng hoá)
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
