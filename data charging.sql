CREATE TABLE devices (
    device_id VARCHAR(50) PRIMARY KEY,
    device_type VARCHAR(30) NOT NULL,
    brand_name VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL
);

CREATE TABLE charging_logs (
    charge_id INT AUTO_INCREMENT PRIMARY KEY,
    device_id VARCHAR(50) NOT NULL,
    plug_in_time DATETIME NOT NULL,
    plug_out_time DATETIME NOT NULL,
    start_level INT NOT NULL,
    end_level INT NOT NULL,
    charge_temp DECIMAL(4,1) NOT NULL,
    CONSTRAINT fk_device
        FOREIGN KEY (device_id)
        REFERENCES devices(device_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO devices (device_id, device_type, brand_name, model)
VALUES
('DV001', 'Smartphone', 'Samsung', 'Galaxy A54'),
('DV002', 'Smartphone', 'Xiaomi', 'Redmi Note 12'),
('DV003', 'Smartphone', 'Apple', 'iPhone 13'),
('DV004', 'Tablet', 'Samsung', 'Galaxy Tab S7'),
('DV005', 'Smartphone', 'Oppo', 'Reno 8'),
('DV006', 'Smartphone', 'Vivo', 'Y20');

INSERT INTO charging_logs
(device_id, plug_in_time, plug_out_time, start_level, end_level, charge_temp)
VALUES
('DV001', '2024-01-03 22:10:00', '2024-01-04 00:05:00', 18, 92, 36.5),
('DV002', '2024-01-05 21:45:00', '2024-01-05 23:10:00', 25, 88, 34.2),
('DV003', '2024-01-06 20:30:00', '2024-01-06 22:15:00', 30, 90, 35.8),
('DV004', '2024-01-07 18:00:00', '2024-01-07 20:40:00', 22, 95, 37.1),
('DV005', '2024-01-08 23:00:00', '2024-01-09 00:20:00', 40, 100, 33.9),
('DV006', '2024-01-09 19:15:00', '2024-01-09 21:05:00', 15, 85, 38.0);
