CREATE DATABASE SD18321_PS27765_NguyenNgocChien
GO	
USE SD18321_PS27765_NguyenNgocChien
GO
--------------------------------------------------------------------------------------------------------------
-- câu lệnh tạo bảng
CREATE TABLE PHONGBAN(
	id nvarchar(5) not null,
	ten_pb nvarchar(255) not null,
	ma_tp int,
	CONSTRAINT PK_PHONGBAN PRIMARY KEY (id)
)
GO

CREATE TABLE NHANVIEN(
	id int not null,
	ho_nv nvarchar(255) not null,
	ten_nv nvarchar(10) not null,
	nam_sinh date,
	dia_chi nvarchar(255),
	gioi_tinh tinyint,
	luong int,
	phongban_id nvarchar(5),
	CONSTRAINT PK_NHANVIEN PRIMARY KEY (id),
	CONSTRAINT FK_NHANVIEN_PHONGBAN FOREIGN KEY (phongban_id) REFERENCES PHONGBAN (id)
)
GO
--------------------------------------------------------------------------------------------------------------
-- câu lệnh chèn dữ liệu
INSERT INTO PHONGBAN
VALUES
	('PB001','Nhan Su',1),
	('PB002','Ke Toan',2),
	('PB003','Kinh Doanh',3),
	('PB004','San Xuat',4),
	('PB005','Phat Trien Mau',5),
	('PB006','QA',6),
	('PB007','Thu Mua',7),
	('PB008','Ky Thuat',8),
	('PB009','LAB',9),
	('PB010','ME',10)
GO

INSERT INTO NHANVIEN
VALUES
	(1,'Ly Canh','Thin','1994-2-17','191, Nguyen Thi Minh Khai, TP. Ho Chi Minh',1,1000,'PB005'),
	(2,'Van Canh','Tuat','1970-10-28','165, Bui Thi Xuan, Dong Nai',1,1000,'PB007'),
	(3,'Truong Ky','Mui','1993-7-20','160, Pham Van Dong, Dong Nai',0,1500,'PB008'),
	(4,'Thai Nham','Than','1972-8-28','65, Le Hong Phong , Da Nang',1,700,'PB004'),
	(5,'To At','Me0','1984-9-15','128, Pham Van Dong, Long AN',0,2500,'PB002')
GO
-------------------------------------------------------------------------------------------------------------
-- Bài 2: Thực hiện các yêu cầu sau

/*1. Tạo Store Procudure chèn dữ liệu vào bảng phong_ban, các giá trị thêm vào được truyền dưới dạng 
tham số đầu vào, nếu id đã tồn tại thì thông báo lỗi, ngược lại thực hiện thêm vào bảng phong_ban, và 
thực hiện hiển thị thông tin phòng ban vừa thêm.
Viết câu lệnh Execute thực thi Stored Procedure vừa tạo.*/
CREATE OR ALTER PROC cau1 @id nvarchar(5),@tenpb nvarchar(255),@matp int
AS
	BEGIN
		IF (SELECT count(id) FROM PHONGBAN WHERE id = @id) > 1
			BEGIN
				PRINT N'thêm dữ liệu thất bại, khóa chính bị trùng'
				RETURN
			END
		ELSE
			BEGIN
				INSERT INTO PHONGBAN
				VALUES
					(@id,@tenpb,@matp)
				SELECT id,ten_pb,ma_tp
				FROM PHONGBAN
				WHERE id = @id
				AND ten_pb = @tenpb
				AND ma_tp = @matp
			END
	END
GO

EXEC cau1 'PB011','ABC',1
GO
/*2. Tạo Trigger thực hiện xóa dữ liệu trong bảng phong_ban, nếu phòng ban đó đã có nhân viên trực thuộc 
thì thực hiện xóa tất cả các nhân trực thuộc phòng ban đó.
Viết truy vấn xóa một phòng ban để kiểm tra Trigger đã tạo.*/
CREATE OR ALTER TRIGGER cau2
ON PHONGBAN
INSTEAD OF DELETE
AS
	BEGIN
		DELETE FROM NHANVIEN WHERE phongban_id IN (SELECT id FROM deleted)
		DELETE FROM PHONGBAN WHERE id IN (SELECT id FROM deleted)
	END
GO

DELETE FROM PHONGBAN WHERE id LIKE'PB011'
GO
/*3. Tạo View thông tin trả về gồm các trường: ho_nv, ten_nv, dia_chi, luong.
Viết truy vấn Cập nhật (Update) lương cho bảng View (mục 3)
với luong = luong + 10 nếu luong <1000.*/
CREATE OR ALTER VIEW cau3
AS
	SELECT  ho_nv,ten_nv,dia_chi,luong
	FROM  NHANVIEN
GO

UPDATE dbo.cau3 SET luong = luong + 10 WHERE luong < 1000
GO
/*4. Viết Function nhập vào id nhân viên trả về: ho_nv, ten_nv và tuổi (tính đến thời điểm hiện tại) của nhân 
viên đó dựa vào cột nam_sinh
Viết truy vấn hiển thị ho_nv, ten_nv và tuổi từ Function vừa tạo.*/
CREATE OR ALTER FUNCTION cau4
	(@idnv int)
RETURNS TABLE
AS
	RETURN(
		SELECT ho_nv,ten_nv,YEAR(GETDATE()) - YEAR(nam_sinh)[tuổi]
		FROM NHANVIEN
		WHERE id = @idnv
	)
GO

SELECT ho_nv,
	ten_nv,
	(SELECT [tuổi] FROM cau4(id))[tuổi]
FROM NHANVIEN
WHERE id = 1