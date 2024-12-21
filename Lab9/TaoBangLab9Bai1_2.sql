CREATE TABLE Khoa (
    makhoa CHAR(10) PRIMARY KEY,
    tenkhoa NVARCHAR(50),
    dienthoai CHAR(15)
);

CREATE TABLE Lop (
    malop CHAR(10) PRIMARY KEY,
    tenlop NVARCHAR(50),
    hedaotao NVARCHAR(50),
    namnhaphoc INT,
    makhoa CHAR(10),
    FOREIGN KEY (makhoa) REFERENCES Khoa(makhoa)
);


CREATE TABLE SinhVien (
    masv CHAR(10) PRIMARY KEY,
    hoten NVARCHAR(50),
    ngaysinh DATE CHECK (YEAR(ngaysinh) BETWEEN 1990 AND 1995),
    gioitinh BIT,
    noisinh NVARCHAR(50),
    malop CHAR(10),
    FOREIGN KEY (malop) REFERENCES Lop(malop)
);

CREATE TABLE MonHoc (
    mamonhoc CHAR(10) PRIMARY KEY,
    tenmonhoc NVARCHAR(50),
    sotc INT CHECK (sotc BETWEEN 1 AND 8)
);

CREATE TABLE DiemThi(
	mamonhoc char(10),
	masv char(10),
	kihoc INT,
	diemlan1 FLOAT CHECK (diemlan1 BETWEEN 0 AND 10),
	diemlan2 FLOAT CHECK (diemlan1 BETWEEN 0 AND 10),
	PRIMARY KEY(mamonhoc, masv),
	FOREIGN KEY (mamonhoc) REFERENCES MonHoc(mamonhoc),
	FOREIGN KEY (masv) REFERENCES MonHoc(masv),
)



INSERT INTO Khoa (makhoa, tenkhoa, dienthoai)
VALUES 
('K01', N'Khoa CNTT', '0123456789'),
('K02', N'Khoa Điện tử', '0234567891'),
('K03', N'Khoa Cơ khí', '0345678912'),
('K04', N'Khoa Hóa học', '0456789123'),
('K05', N'Khoa Toán', '0567891234'),
('K06', N'Khoa Vật lý', '0678912345'),
('K07', N'Khoa Sinh học', '0789123456'),
('K08', N'Khoa Kiến trúc', '0891234567'),
('K09', N'Khoa Y học', '0901234567'),
('K10', N'Khoa Kinh tế', '0912345678');


INSERT INTO Lop (malop, tenlop, hedaotao, namnhaphoc, makhoa)
VALUES 
('L01', N'Lớp A', N'Đại Học', 2020, 'K01'),
('L02', N'Lớp B', N'Cao Đẳng', 2021, 'K02'),
('L03', N'Lớp C', N'Đại Học', 2022, 'K03'),
('L04', N'Lớp D', 'Cao Đẳng', 2020, 'K04'),
('L05', N'Lớp E', 'Đại Học', 2021, 'K05'),
('L06', N'Lớp F', 'Cao Đẳng', 2022, 'K06'),
('L07', N'Lớp G', 'Đại Học', 2020, 'K07'),
('L08', N'Lớp H', 'Cao Đẳng', 2021, 'K08'),
('L09', N'Lớp I', 'Đại Học', 2022, 'K09'),
('L10', N'Lớp J', 'Cao Đẳng', 2020, 'K10');


INSERT INTO SinhVien (masv, hoten, ngaysinh, gioitinh, noisinh, malop)
VALUES 
('SV01', N'Nguyễn Văn A', '1990-01-01', 1, N'Hà Nội', 'L01'),
('SV02', N'Lê Thị B', '1992-02-02', 0, N'Hải Phòng', 'L02'),
('SV03', N'Phạm Văn C', '1991-03-03', 1, N'Quảng Ninh', 'L03'),
('SV04', N'Hoàng Thị D', '1991-04-04', 0, N'Nam Định', 'L04'),
('SV05', N'Trần Văn E', '1995-05-05', 1, N'Ninh Bình', 'L05'),
('SV06', N'Vũ Thị F', '1994-06-06', 0, N'Hải Dương', 'L06'),
('SV07', N'Đỗ Văn G', '1993-07-07', 1, N'Thái Bình', 'L07'),
('SV08', N'Bùi Thị H', '1992-08-08', 0, N'Hưng Yên', 'L08'),
('SV09', N'Trịnh Văn K', '1990-09-09', 1, N'Thanh Hóa', 'L09'),
('SV10', N'Hà Thị L', '1991-10-10', 0, N'Nghệ An', 'L10');

INSERT INTO MonHoc (mamonhoc, tenmonhoc, sotc)
VALUES 
('MH01', N'Toán rời rạc', 3),
('MH02', N'Lập trình C', 4),
('MH03', N'Mạng máy tính', 3),
('MH04', N'Kỹ thuật điện', 2),
('MH05', N'Hóa học cơ bản', 3),
('MH06', N'Cơ học ứng dụng', 2),
('MH07', N'Sinh học đại cương', 3),
('MH08', N'Kiến trúc hiện đại', 4),
('MH09', N'Y học cơ bản', 3),
('MH10', N'Kinh tế học', 2);



INSERT INTO DiemThi (masv, mamonhoc, diemlan1, diemlan2)
VALUES 
('SV01', 'MH01', 8, 9),
('SV02', 'MH02', 7, 6),
('SV03', 'MH03', 9, 8),
('SV04', 'MH04', 6, 5),
('SV05', 'MH05', 10, 9),
('SV06', 'MH06', 8, 7),
('SV07', 'MH07', 6, 8),
('SV08', 'MH08', 5, 7),
('SV09', 'MH09', 7, 8),
('SV10', 'MH10', 9, 10);


