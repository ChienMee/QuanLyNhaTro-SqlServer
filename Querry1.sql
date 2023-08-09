USE PS27765_QLNHATRO
GO

---------------------------------------------------------------------------------------------------------------------------
/* 1. Tạo ba Stored Procedure (SP) với các tham số đầu vào phù hợp. */

-- a. SP thứ nhất thực hiện chèn dữ liệu vào bảng NGUOIDUNG
CREATE OR ALTER PROC asm_y3_1_a_NGUOIDUNG
	@MaNguoiDung int,
	@TenNguoiDung nvarchar(100),
	@GioiTinh nvarchar(10),
	@DienThoai varchar(50),
	@DiaChi nvarchar(255),
	@Quan Nvarchar(50),
	@Email varchar(50) = null
AS
	BEGIN
		IF(@MaNguoiDung is null)
			BEGIN
				PRINT N'mã người dùng không được null'
				RETURN
			END
		IF(@TenNguoiDung is null)
			BEGIN
				PRINT N'tên người dùng không được null'
				RETURN
			END
		IF(@GioiTinh is null)
			BEGIN
				PRINT N'giới tính không được null'
				RETURN
			END
		IF(@DienThoai is null)
			BEGIN
				PRINT N'Điện thoại không được null'
				RETURN
			END
		IF(@DiaChi is null)
			BEGIN
				PRINT N'Địa chỉ không được null'
				RETURN
			END
		IF(@Quan is null)
			BEGIN
				PRINT N'Quận không được null'
				RETURN
			END
		INSERT INTO NGUOIDUNG
		VALUES
			(@MaNguoiDung,
			 @TenNguoiDung,
			 @GioiTinh,
			 @DienThoai,
			 @DiaChi,
			 @Quan,
			 @Email)
	END
GO

-- b. SP thứ hai thực hiện chèn dữ liệu vào bảng NHATRO
CREATE OR ALTER PROC asm_Y3_1_a_NHATRO
	@MaNhaTro int,
	@MaLoaiNha int,
	@DienTich float,
	@GiaPhong money,
	@DiaChi nvarchar(255),
	@Quan nvarchar(50),
	@ThongTinNhaTro nvarchar(255) = null,
	@NgayDang date,
	@NguoiLienHe int
AS
	BEGIN
		IF(@MaNhaTro is null)
			BEGIN
				PRINT N'mã nhà trọ không được null'
				RETURN
			END
		IF(@MaLoaiNha is null)
			BEGIN
				PRINT N'mã loại nhà không được null'
				RETURN
			END
		IF(@DienTich is null)
			BEGIN
				PRINT N'diện tích không được null'
				RETURN
			END
		IF(@GiaPhong is null)
			BEGIN
				PRINT N'giá phòng không được null'
				RETURN
			END
		IF(@Diachi is null)
			BEGIN
				PRINT N'Địa chỉ không được null'
				RETURN
			END
		IF(@Quan is null)
			BEGIN
				PRINT N'Quận không được null'
				RETURN
			END
		IF(@NgayDang is null)
			BEGIN
				PRINT N'ngày đăng không được null'
				RETURN
			END
		IF(@NguoiLienHe is null)
			BEGIN
				PRINT N'người liên hệ không được null'
				RETURN
			END
		INSERT INTO NHATRO
		VALUES
			(@MaNhaTro,
			 @MaLoaiNha,
			 @DienTich,
			 @GiaPhong,
			 @DiaChi,
			 @Quan,
			 @ThongTinNhaTro,
			 @NgayDang ,
			 @NguoiLienHe)
	END
GO

-- c. SP thứ ba thực hiện chèn dữ liệu vào bảng DANHGIA
CREATE OR ALTER PROC asm_y3_1_a_DANHGIA
	@MaNhaTro int,
	@MaNgDG int,
	@DanhGia varchar(50),
	@NoiDungDanhGia nvarchar(255) = null
AS
	BEGIN
		IF(@MaNhaTro is null)
		BEGIN
			PRINT N'mã nhà trọ không được null'
			RETURN
		END
		IF(@MaNgDG is null)
		BEGIN
			PRINT N'mã người đánh giá không được null'
			RETURN
		END
		IF(@DanhGia is null)
		BEGIN
			PRINT N'đánh giá không được null'
			RETURN
		END
		INSERT INTO DANHGIA
		VALUES
			(@MaNhaTro,
			 @MaNgDG,
			 @DanhGia,
			 @NoiDungDanhGia)
	END
GO
/* d. Với mỗi SP, viết hai lời gọi. Trong đó, một lời gọi thực hiện chèn thành công dữ liệu,
và một lời gọi trả về thông báo lỗi cho người dùng.*/

-- gọi procedure chèn dữ liệu vào bảng NGUOIDUNG
EXEC asm_y3_1_a_NGUOIDUNG null,N'Lâm Triều Anh','Nam','0985276564',null,'5',null
GO

EXEC asm_y3_1_a_NGUOIDUNG 8417,N'Lâm Triều Anh','Nam','0985276564','345 Nguyễn Văn Quá','12',null
GO
-- gọi procedure chèn dữ liệu vào bảng NHATRO
EXEC asm_Y3_1_a_NHATRO 205,5,40.5,7800000,'543 Nguyễn Ảnh Thủ',null,null,null,null
GO

EXEC asm_Y3_1_a_NHATRO 205,5,40.5,7800000,'543 Nguyễn Ảnh Thủ','12',null,'2023-05-21',8417
GO
-- gọi procedure chèn dữ liệu vào bảng DANH GIA
EXEC asm_y3_1_a_DANHGIA null,8401,'Like',null
GO

EXEC asm_y3_1_a_DANHGIA 2201,8406,'Dislike',null
GO
---------------------------------------------------------------------------------------------------------------------------
-- 2. truy vấn thông tin

/* a. Viết một SP với các tham số đầu vào phù hợp. SP thực hiện tìm kiếm thông tin các 
phòng trọ thỏa mãn điều kiện tìm kiếm theo: Quận, phạm vi diện tích, phạm vi ngày đăng
tin, khoảng giá tiền, loại hình nhà trọ.*/
CREATE OR ALTER PROC asm_y3_2_a
	@DienTich float = null,
	@GiaPhong money = null,
	@DiaChi nvarchar(100) = '%',
	@Quan nvarchar(50) = '%',
	@NgayDang date = null,
	@tenloainha nvarchar(50) = '%'
AS
	BEGIN
		DECLARE @maxDienTich float = (SELECT MAX(DienTich) FROM NHATRO)
		IF(@DienTich is null)
			SET @DienTich = @maxDienTich
		DECLARE @maxGiaPhong money = (SELECT MAX(GiaPhong) FROM NHATRO)
		IF(@GiaPhong is null)
			SET @GiaPhong = @maxGiaPhong
		DECLARE @ngaydangNow date = GETDATE()
		IF(@NgayDang is null)
			SET @NgayDang = GETDATE()
		SELECT (NT.DiaChi + ' ' +NT.Quan) N'cho thuê phòng trọ tại',
			CAST(DienTich as nvarchar(100)) + 'm2',
			REPLACE(FORMAT(GiaPhong,'#,##'),
			',',
			'.'),
			ThongTinNhaTro,
			CONVERT(varchar(10),NgayDang,105),
			CASE
				WHEN GioiTinh LIKE 'Nam' THEN 'A. ' + ND.TenNguoiDung
				WHEN GioiTinh LIKE N'Nữ' THEN 'C. ' + ND.TenNguoiDung
			END [giới tính],
			DienThoai,
			ND.DiaChi
		FROM NHATRO NT JOIN LOAINHA LN
		ON NT.MaLoaiNha = LN.MaLoaiNha
		JOIN NGUOIDUNG ND
		ON ND.MaNguoiDung = NT.NguoiLienHe
		WHERE DienTich <= @DienTich 
		AND GiaPhong <= @GiaPhong
		AND NT.Quan LIKE @Quan
		AND NgayDang <= @NgayDang
		AND TenLoaiNha LIKE @tenloainha
	END
GO

EXEC asm_y3_2_a 
GO

/* b. Viết một hàm có các tham số đầu vào tương ứng với tất cả các cột của bảng 
NGUOIDUNG. Hàm này trả về mã người dùng (giá trị của cột khóa chính của bảng 
NGUOIDUNG) thỏa mãn các giá trị được truyền vào tham số.*/
CREATE OR ALTER FUNCTION asm_y3_2_b
	(@TenNguoiDung nvarchar(100) = '%',
	 @GioiTinh nvarchar(10) = 'Nam',
	 @DienThoai varchar(50) = '%',
	 @DiaChi nvarchar(255) = '%',
	 @Quan Nvarchar(50) = '%',
	 @Email varchar(50) = '%')
RETURNS TABLE
AS
	RETURN(
		SELECT MaNguoiDung
		FROM NGUOIDUNG
		WHERE TenNguoiDung LIKE @TenNguoiDung
		AND GioiTinh LIKE @GioiTinh
		AND DienThoai LIKE @DienThoai
		AND DiaChi LIKE @DiaChi
		AND Quan LIKE @Quan
		AND Email LIKE @Email
		)
GO

SELECT * FROM DBO.asm_y3_2_b(default,N'Nữ',default,default,default,default)
GO

/* c. Viết hàm có tham số đầu vào là mã nhà trọ (cột khóa chính của bảng NHATRO).
Hàm này trả về tổng số LIKE và DISLIKE của nhà trọ này.*/

-- tính số lượt like
CREATE OR ALTER FUNCTION asm_y3_2_c_like
	(@manhatro int)
RETURNS INT
AS
	BEGIN
		RETURN
		(
			SELECT COUNT(MaNhaTro) [số lượt like]
			FROM DANHGIA DA
			WHERE DANHGIA LIKE 'Like' AND MaNhaTro = @manhatro
		)
	END
GO

SELECT DBO.asm_y3_2_c_like(2206)
GO

-- tính số lượt dislike
CREATE OR ALTER FUNCTION asm_y3_2_c_dislike
	(@manhatro int)
RETURNS INT
AS
	BEGIN
		RETURN
		(
			SELECT COUNT(MaNhaTro) [số lượt dislike]
			FROM DANHGIA DA
			WHERE DanhGia LIKE 'Dislike' AND MaNhaTro = @manhatro 
		)
	END
GO

SELECT dbo.asm_y3_2_c_dislike(2206)
GO

/* d. Tạo một View lưu thông tin của TOP 10 nhà trọ có số người dùng LIKE nhiều nhất gồm 
các thông tin sau: Diện tích, Giá,  Mô tả,  Ngày đăng tin, Tên người liên hệ, Địa chỉ, Điện thoại, Email*/
CREATE OR ALTER VIEW asm_y3_2_d
AS
	SELECT TOP 10 WITH TIES 
		   NT.DienTich,
		   NT.GiaPhong,
		   NT.ThongTinNhaTro,
		   NT.NgayDang,
		   ND.TenNguoiDung,
		   NT.DiaChi,
		   ND.DienThoai,
		   ND.Email
	FROM NHATRO NT JOIN NGUOIDUNG ND
	ON NT.NguoiLienHe = ND.MaNguoiDung 
	JOIN DANHGIA DG
	ON DG.MaNhaTro = NT.MaNhaTro
	WHERE DG.DanhGia LIKE 'Like' 
	ORDER BY DG.DanhGia DESC
GO

SELECT * FROM dbo.asm_y3_2_d
GO
/* e. Viết một Stored Procedure nhận tham số đầu vào là mã nhà trọ (cột khóa chính của bảng NHATRO). 
SP này trả về tập kết quả gồm các thông tin sau:
- Mã nhà trọ
- Tên người đánh giá
- Trạng thái LIKE hay DISLIKE
- Nội dung đánh giá */
CREATE OR ALTER PROC asm_y3_2_e
	@manhatro int
AS
	BEGIN
		SELECT NT.MaNhaTro,ND.TenNguoiDung,DG.DanhGia,DG.NoiDungDanhGia
		FROM NHATRO NT JOIN NGUOIDUNG ND
		ON NT.NguoiLienHe = ND.MaNguoiDung
		JOIn DANHGIA DG ON DG.MaNhaTro = NT.MaNhaTro
		WHERE NT.MaNhaTro = @manhatro
	END
GO

EXEC asm_y3_2_e 2208
GO

------------------------------------------------------------------------------------------------------
-- 3. Xóa thông tin

/*a. Viết một SP nhận một tham số đầu vào kiểu int là số lượng DISLIKE.
SP này thực hiện thao tác xóa thông tin của các nhà trọ và thông tin đánh giá của chúng,
nếu tổng số lượng DISLIKE tương ứng với nhà trọ này lớn hơn giá trị tham số được truyền vào.
Yêu cầu: Sử dụng giao dịch trong thân SP, để đảm bảo tính toàn vẹn dữ liệu
khi một thao tác xóa thực hiện không thành công.*/
CREATE OR ALTER PROC asm_y3_3_a @soluongdislike int
AS
	BEGIN
		SET XACT_ABORT ON
		BEGIN TRAN
		BEGIN TRY
			DECLARE @nt table (mant int)
			INSERT INTO @nt
			SELECT MaNhaTro FROM NHATRO WHERE dbo.asm_y3_2_c_dislike(MaNhaTro) > @soluongdislike
			DELETE DANHGIA WHERE MaNhaTro IN (SELECT mant FROM @nt)
			DELETE NHATRO WHERE MaNhaTro IN (SELECT mant FROM @nt)
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			PRINT N'xóa dữ liệu thất bại'
		END CATCH
	END
GO

EXEC asm_y3_3_a 2
GO

/* b. Viết một SP nhận hai tham số đầu vào là khoảng thời gian đăng tin. SP này thực hiện
thao tác xóa thông tin những nhà trọ được đăng trong khoảng thời gian được truyền vào 
qua các tham số.
Lưu ý: SP cũng phải thực hiện xóa thông tin đánh giá của các nhà trọ này.
Yêu cầu: Sử dụng giao dịch trong thân SP, để đảm bảo tính toàn vẹn dữ liệu khi một thao tác 
xóa thực hiện không thành công*/
CREATE OR ALTER PROC asm_y3_3_b @khoangbatdau date,@khoangketthuc date
AS
	BEGIN
		SET XACT_ABORT ON
		BEGIN TRAN
		IF(@khoangbatdau > @khoangketthuc)
			BEGIN
				PRINT N'ngày bắt đầu phải bé hơn ngày ngày kết thúc'
				ROLLBACK TRAN
				SET XACT_ABORT OFF
				RETURN
			END
		ELSE
			BEGIN
				DECLARE @nt table(mant int)
				INSERT INTO @nt 
				SELECT MaNhaTro FROM NHATRO WHERE NgayDang BETWEEN @khoangbatdau AND @khoangketthuc
				DELETE FROM DANHGIA WHERE MaNhaTro IN (SELECT mant FROM @nt)
				DELETE FROM NHATRO WHERE MaNhaTro IN (SELECT mant FROM @nt)
				COMMIT TRAN
			END
	END
GO

EXEC asm_y3_3_b '2023-05-15','2023-05-17'
GO

-----------------------------------------------------------------------------------------------------
-- 4. Trigger

/* a. Tạo Trigger ràng buộc khi thêm, sửa thông tin nhà trọ phải thỏa mãn các điều kiện sau:
• Diện tích phòng >=8 (m2)
• Giá phòng >=0*/
CREATE OR ALTER TRIGGER asm_y3_4_a
ON NHATRO
AFTER UPDATE, INSERT
AS
	BEGIN
		DECLARE @dientichphg FLOAT = (SELECT DienTich FROM inserted)
		DECLARE @giaphg MONEY = (SELECT GiaPhong FROM inserted)
		IF(@giaphg < 0)
			BEGIN
				PRINT(N'giá phòng phải là số dương')
				ROLLBACK
				RETURN
			END
		IF(@dientichphg < 8)
			BEGIN
				PRINT(N'diện tích phải lớn hơn hoặc bằng 8')
				ROLLBACK
				RETURN
			END
	END
GO

UPDATE NHATRO SET GiaPhong = -1 WHERE MaNhaTro = 2201
UPDATE NHATRO SET DienTich = 7 WHERE MaNhaTro = 2201
GO

/* b. Tạo Trigger để khi xóa thông tin người dùng
• Nếu có các đánh giá của người dùng đó thì xóa cả đánh giá
• Nếu có thông tin liên hệ của người dùng đó trong nhà trọ thì sửa thông tin liên hệ
sang người dùng khác hoặc để trống thông tin liên hệ */
CREATE OR ALTER TRIGGER asm_y3_4_b
ON NGUOIDUNG
INSTEAD OF DELETE
AS
	BEGIN
		DELETE DANHGIA WHERE MaNgDG IN (SELECT MaNguoiDung FROM deleted)
		UPDATE NHATRO SET NguoiLienHe = null WHERE NguoiLienHe IN (SELECT MaNguoiDung FROM deleted)
		DELETE NGUOIDUNG WHERE MaNguoiDung IN (SELECT MaNguoiDung FROM deleted)
	END
GO

DELETE NGUOIDUNG WHERE MaNguoiDung = 8417

-----------------------------------------------------------------------------------------------------
-- 5. Yêu cầu quản trị CSDL
-- a. Tạo hai người dùng CSDL.
/* Một người dùng với vai trò nhà quản trị CSDL. Phân quyền cho người dùng
này chỉ được phép thao tác trên CSDL quản lý nhà trọ cho thuê và có toàn 
quyền thao tác trên CSDL đó */
CREATE LOGIN [userowner] WITH PASSWORD = '123456'
CREATE USER [userowner] FOR LOGIN [userowner]

-- cấp toàn quyền cho userowner trong csdl quản lý nhà trọ
EXEC sp_addrolemember N'db_owner', N'userowner'

-- cấp quyền sysadmin cho userowner
USE [master];
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [userowner];
GO

-- cấp quyền thực hiện tự động sao lưu cho userowner
EXEC sp_addrolemember N'db_backupoperator',N'userowner'



/*Một người dùng thông thường. Phân cho người dùng này toàn bộ quyền thao
tác trên các bảng của CSDL và quyền thực thi các SP và các hàm được tạo ra từ
các yêu cầu trên*/
CREATE LOGIN [user1] WITH PASSWORD = '123456'
CREATE USER [user1] FOR LOGIN [user1]

-- cấp quyền CRUD cho user1
EXEC sp_addrolemember N'db_datareader', N'user1'
EXEC sp_addrolemember N'db_datawritter', N'user1'

-- tạo role cho vào gán quyền được thực thi tất cả cho role đó 
CREATE ROLE db_excutor
GRANT EXECUTE TO db_excutor

-- cấp quyên thực thi tất cả các store procedure cho người dùng user1
EXEC sp_addrolemember N'db_executor', N'user1'

