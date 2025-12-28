
DROP DATABASE IF EXISTS session02_full;
CREATE DATABASE session02_full;
USE session02_full;

DROP TABLE IF EXISTS DangKy;
DROP TABLE IF EXISTS MonHoc;
DROP TABLE IF EXISTS SinhVien;

-- 1) Bảng SinhVien
CREATE TABLE SinhVien (
    ma_sv        CHAR(10)        PRIMARY KEY,                
    ho_ten       VARCHAR(100)    NOT NULL,                
    ngay_sinh    DATE            NOT NULL,                    
    gioi_tinh    ENUM('M','F','O') NOT NULL,                 
    email        VARCHAR(150)    NOT NULL,                  
    ten_lop      VARCHAR(30)     NOT NULL                     
) ENGINE=InnoDB;

CREATE TABLE MonHoc (
    ma_mh        CHAR(10)        PRIMARY KEY,                 
    ten_mh       VARCHAR(100)    NOT NULL,                  
    credits      TINYINT UNSIGNED NOT NULL DEFAULT 3         
) ENGINE=InnoDB;

CREATE TABLE DangKy (
    ma_sv        CHAR(10)        NOT NULL,                  
    ma_mh        CHAR(10)        NOT NULL,               
    semester     VARCHAR(10)     NOT NULL,                 
    regist       DATE            NOT NULL DEFAULT (CURRENT_DATE),
    
    CONSTRAINT pk_DangKy PRIMARY KEY (ma_sv, ma_mh, semester),

    CONSTRAINT fk_DangKy_SinhVien FOREIGN KEY (ma_sv)
        REFERENCES SinhVien(ma_sv)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_DangKy_MonHoc FOREIGN KEY (ma_mh)
        REFERENCES MonHoc(ma_mh)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;



ALTER TABLE SinhVien
ADD COLUMN so_dien_thoai VARCHAR(15) NULL;

ALTER TABLE SinhVien
ADD CONSTRAINT uq_SinhVien_email UNIQUE (email);


ALTER TABLE DangKy
MODIFY COLUMN semester TINYINT UNSIGNED NOT NULL;

ALTER TABLE DangKy
ADD CONSTRAINT chk_DangKy_semester CHECK (semester BETWEEN 1 AND 3);

ALTER TABLE MonHoc
ADD CONSTRAINT chk_MonHoc_credits CHECK (credits BETWEEN 1 AND 6);

ALTER TABLE SinhVien
DROP COLUMN ten_lop;



SHOW TABLES;

DESCRIBE SinhVien;
DESCRIBE MonHoc;
DESCRIBE DangKy;

SHOW CREATE TABLE SinhVien;
SHOW CREATE TABLE MonHoc;
SHOW CREATE TABLE DangKy;
