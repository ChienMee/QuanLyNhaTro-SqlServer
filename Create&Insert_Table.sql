/*
	Bài tập: Assignment 1
	Môn: COM2043 - Hệ quản trị CSDL SQL Server
	Giảng viên hướng dẫn: Nguyễn Đức Thịnh
	Tên sinh viên thực hiện : Nguyên Ngọc Chiến
	Mã số sinh viên: PS27765
	Lớp: SD_18321
	Ngày thực hiện: 22/05/2023
*/



-- Tạo Database
CREATE DATABASE PS27765_QLNHATRO
GO

-- Chỉ định CSDL cần thao tác 
USE PS27765_QLNHATRO

------------------------------------------------------
-- Các câu lệnh tạo các table

-- Tạo table LOAINHA
CREATE TABLE LOAINHA
(
	MaLoaiNha INT NOT NULL,
	TenLoaiNha NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_LOAINHA PRIMARY KEY (MaLoaiNha)
)
GO

-- Tạo table NGUOIDUNG
CREATE TABLE NGUOIDUNG
(
	MaNguoiDung INT NOT NULL,
	TenNguoiDung NVARCHAR(50) NOT NULL,
	GioiTinh NVARCHAR(10),
	DienThoai VARCHAR(20) NOT NULL,
	DiaChi NVARCHAR(255) NOT NULL,
	Quan NVARCHAR(20) NOT NULL,
	Email VARCHAR(50)
	CONSTRAINT PK_NGUOIDUNG PRIMARY KEY (MaNguoiDung),
	CONSTRAINT CHK_EMAIL CHECK (Email IS NULL OR Email LIKE '%@%'),
	CONSTRAINT CHK_TENNGUOIDUNG CHECK (TenNguoiDung NOT LIKE '%[0-9]%'),
	CONSTRAINT CHK_DIENTHOAI CHECK (DienThoai LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9]%')
)
GO

-- Tạo table NHATRO
CREATE TABLE NHATRO
(
	MaNhaTro INT  NOT NULL,
	MaLoaiNha INT NOT NULL,
	DienTich FLOAT NOT NULL,
	GiaPhong MONEY NOT NULL,
	DiaChi NVARCHAR(255) NOT NULL,
	Quan NVARCHAR(20) NOT NULL,
	ThongTinNhaTro NVARCHAR(255),
	NgayDang DATE NOT NULL,
	NguoiLienHe INT NOT NULL,
	CONSTRAINT PK_NHATRO PRIMARY KEY (MaNhaTro),
	CONSTRAINT FK_NHATRO_LOAINHA FOREIGN KEY (MaLoaiNha) REFERENCES LOAINHA,
	CONSTRAINT FK_NHATRO_NGUOIDUNG FOREIGN KEY (NguoiLienHe) REFERENCES NGUOIDUNG,
	CONSTRAINT CHK_DIENTICH CHECK (DienTich >= 5),
	CONSTRAINT CHK_GIAPHONG CHECK (GiaPhong >= 200000)
)
GO

-- Tạo table DANHGIA
CREATE TABLE DANHGIA
(
	MaNhaTro INT NOT NULL,
	MaNgDG INT NOT NULL,
	DanhGia VARCHAR(10),
	NoiDungDanhGia NVARCHAR(255),
	CONSTRAINT PK_DANHGIA PRIMARY KEY(MaNhaTro,MaNgDG),
	CONSTRAINT FK_DANHGIA_NHATRO FOREIGN KEY (MaNhaTro) REFERENCES NHATRO,
	CONSTRAINT FK_DANHGIA_NGUOIDUNG FOREIGN KEY (MaNgDG) REFERENCES NGUOIDUNG
)
GO
------------------------------------------------------
-- Các câu lệnh chèn dữ liệu vào bảng

-- Insert dữ liệu table LOAINHA
INSERT INTO LOAINHA (MaLoaiNha,TenLoaiNha)
VALUES
	(101,N'Phòng trọ mini'),
	(102,N'Phòng trọ cao cấp'),
	(103,N'Căn hộ mini'),
	(104,N'Căn hộ cao cấp'),
	(105,N'Ký túc xá')

-- Insert dữ liệu table NGUOIDUNG
INSERT INTO NGUOIDUNG (MaNguoiDung,TenNguoiDung,GioiTinh,DienThoai,DiaChi,Quan,Email)
VALUES
	(8401,N'Nguyễn Thủy',N'Nữ','0906318123',N'39/38 Đ.385, Tăng Nhơn Phú A, Q9, TP.HCM','9','thuy73.thienkhoihcm@gmail.com'),
	(8402,N'Trần Gia Khanh','Nam','0829475123',N'683 Cộng Hòa,p.13,Q.Tân Bình,TP.HCM',N'Tân Bình',NULL),
	(8403,N'Nguyễn Hồng Anh',N'Nữ','0907574123',N'Đ. Mai Chí Thọ, P. An Phú, Q.2,TP.HCM','2','nguyen2291996@gmail.com'),
	(8404,N'Trần Thanh Phong','Nam','0906636123',N'207/7 Nguyễn Trọng Tuyển, P.8, Q.Phú Nhuận, TP.HCM',N'Phú Nhuận',NULL),
	(8405,N'Cao Mỹ Diệp',N'Nữ','0966266123',N'Hẻm số 27 Nguyễn Văn Thủ, P.Đakao, Q.1, TP.HCM','1','mydiepcao2205@gmail.com'),
	(8406,N'Phạm Thị Thảo',N'Nữ','0902999123',N'Nguyễn Trãi ,P.Bến Thành, Q.1, ,TP.HCM','1','Phuongthao5111992@gmail.com'),
	(8407,N'Lê Anh Dũng','Nam','0938888123',N'Đ.16,P. Bình Trị Đông B, Q.Bình Tân, TP.HCM',N'Bình Tân','dungle091091@gmail.com'),
	(8408,N'Nguyễn Minh','Nam','0922328123',N'18A/27 Nguyễn Thị Minh Khai, P.Đa Kao, Q1, HCM ','1','mn78@gmail.com'),
	(8409,N'Lê Minh Hân',N'Nữ','0925925123',N'Trương Công Định, P.14, Q.Tân Bình, HCM',N'Tân Bình','hanminh@gmail.com'),
	(8410,N'Huỳnh Hải','Nam','0999229123',N'346 Bến Vân Đồn, P.1, Q.4, HCM','4','hh00999229123@gmail.com')

-- Insert dữ liệu table NHATRO
INSERT INTO NHATRO (MaNhaTro,MaLoaiNha,DienTich,GiaPhong,DiaChi,Quan,ThongTinNhaTro,NgayDang,NguoiLienHe)
VALUES
	(2201,102,25,5800000,N'Cách Mạng Tháng Tám, P.4, Q. Tân Bình',N'Tân Bình',
	N'Phòng có máy lạnh, kệ bếp, tủ quần áo, tủ lạnh,giường,phòng tắm có vòi sen,…',CONVERT(DATE,'22/05/2023',103),8409),
	(2202,102,30,5000000,N'250,Đ.Xô Viết Nghệ Tĩnh, P.26, Q.Bình Thạnh, HCM',N'Bình Thạnh',
	N'Phòng có full nội thất, gần các trường đại học lớn',CONVERT(DATE,'22/05/2023',103),8407),
	(2203,101,20,2400000,N'Khu dân cư Mê Kông Cộng Hòa, 108/E5 Cộng Hòa, Q.Tân Bình',N'Tân Bình',
	N'Đối diện Maximax Cộng Hòa, đầy đủ tiện nghi,phù hợp sinh viện đi học ở các quận 1,3,10',CONVERT(DATE,'22/05/2023',103),8402),
	(2204,104,35,7000000,N'Nguyễn Vân Đậu, P.5, Q.Bình Thạnh, HCM',N'Bình Thạnh',
	N'Tiện nghi đầy đủ,tòa nhà có thang máy , an ninh 24/24, có Bacolny thoáng mát',CONVERT(DATE,'20/05/2023',103),8405),
	(2205,103,30,3800000,N'Dự án Vinhomes Grand Park, P.Long Thạnh Mỹ, Q.9, HCM','9',
	N'Căn studio (29-39m2) ,đầy đủ tiện nghi , có ban công thoáng mát view nhìn ra thành phố,yên tĩnh',CONVERT(DATE,'16/05/2023',103),8401),
	(2206,105,20,1200000,N'Trần Hưng Đạo, P.Cầu Kho, Q.1, HCM','1',
	N'Phòng có máy lạnh, phòng nam nữ riêng biệt, có người vệ sinh miễn phí, an ninh có camera giám sát,
	mỗi giường có, rèm che riêng tư sang trọng',CONVERT(DATE,'27/05/2023',103),8406),
	(2207,103,28,6500000,N'860/60X/39 Xô Viết Nghệ Tĩnh, P 25, Q.Bình Thạnh',N'Bình Thạnh',
	N'Cho thuê chính chủ, cam kết phòng giống như hình, view Landmark 81',CONVERT(DATE,'23/05/2023',103),8408),
	(2208,101,22,3200000,N'380 Đồng Văn Cống, P.Thạnh Mỹ Lợi,Q.Thủ Đức, HCM',N'Thủ Đức',
	N'Gần chợ, siêu thị, cây xăng, trang bị máy giặc chung, giờ giấc tự do',CONVERT(DATE,'23/05/2023',103),8403),
	(2209,105,25,600000,N'538 Điện Biên Phủ Quận 10, HCM','10',
	N'Mỗi người 1 giường, có thang máy, dọn vệ sinh free mỗi ngày',CONVERT(DATE,'16/05/2023',103),8410),
	(2210,104,40,8500000,N'Phan Đăng Lưu, P.3, Q.Phú Nhuận',N'Phú Nhuận',
	N'Full nội thất, an ninh,hầm giữ xe rộng rãi, vệ sinh thường xuyên,đội ngũ kỹ thuật phục vụ 24/7',CONVERT(DATE,'22/05/2023',103),8404)

-- Insert dữ liệu table DANHGIA
INSERT INTO DANHGIA(MaNhaTro,MaNGDG,DanhGia,NoiDungDanhGia)
VALUES
	(2201,8403,'Like',N'Nhà có đây đủ tiện nghi, giống như mô tả, không gian thoáng mát'),
	(2202,8402,'Dislike',NULL),
	(2203,8402,'Like',N'Trải nghiệm tuyệt vời, với một mức giá rất ưu đãi.'),
	(2210,8401,'Like',N'Nội thất đẹp, cảnh quan hài hòa, nhà ở rộng rải thoáng mát'),
	(2209,8405,'Like',NULL),
	(2208,8407,'Like',N'Thật tuyệt vời'),
	(2206,8410,'Like',NULL),
	(2206,8403,'Dislike',N'Sơn tường đã cũ, rèm che hơi bẩn'),
	(2204,8406,'Like',NULL),
	(2205,8407,'Like',N'Phòng rất đẹp, thoáng mát và tiện nghi')
