-- Sample data for the Pascal-case schema: 1 user, 5 devices, 2 sensing flows and 2 actuation rules per device.
-- Load order matters (foreign keys): Users, Devices, SensingFlows, ActuationRules.
--
-- Mode:              0 Dataset, 1 Realtime
-- GenModel:          0 Bernoulli, 1 MarkovTwoState, 4 PoissonOnset, 6 HiddenMarkov, 9 DeterministicPattern
-- FlowType:          0 BaseLine, 1 Normal, 2 Spikes, 3 Dead, 4 Stuck, 5 Offset, 6 Noise, 7 DriftLinear, 8 DriftStepped
-- ConditionType:     0 Equals, 1 EqualsOrLesser, 2 EqualsOrGreater, 3 Lesser, 4 Greater
-- TargetType:        0 GPIO, 1 I2C, 2 SPI, 3 UART, 4 BLE
-- Numeric values are scale 100. 1793145600 = 2026-10-28 00:00:00 UTC. Durations are in seconds.
-- RuleId is the sole primary key, so it is unique across all devices (hence the DEV-xxx- prefix).
-- PassCode values are placeholders; store real hashes, not plain text.

INSERT INTO "Users" ("UserId", "PassCode1", "PassCode2", "IsFirstLogin")
VALUES
    ('USR-001', 'CHANGE-ME-1', 'CHANGE-ME-2', 1);

INSERT INTO "Devices"
    ("DeviceId", "UserId", "DeviceName", "Make", "Model", "NumberOfFlows", "RepeatFlowSequence", "FlowSequenceEnd",
     "Mode", "OperatingMax", "OperatingMin", "Latitude", "Longitude", "Altitude", "GenModel", "UnitOfMeasurement", "Scale")
VALUES
    ('DEV-001', 'USR-001', 'Boiler Temperature Probe', 'Acme',     'T-100', 2, true,  1900000000, 1, 15000,   0, 2257, 8836,  1100, 1, "degC", 10),
    ('DEV-002', 'USR-001', 'Line Pressure Transducer',  'Borealis', 'P-250', 2, false, 1895000000, 0, 40000, 500, 1908, 7288,  1400, 0, "bar", 10),
    ('DEV-003', 'USR-001', 'Coolant Flow Meter',        'Cirrus',   'F-30',  2, true,  1910000000, 1,  9000, 100, 1308, 8027,   600, 4, "cusec", 10),
    ('DEV-004', 'USR-001', 'Motor Vibration Sensor',    'Delta',    'V-8',   2, true,  1905000000, 0,  2000,   0, 2861, 7721, 21600, 6, "khz", 10),
    ('DEV-005', 'USR-001', 'Tank Level Switch',         'Eon',      'L-5',   2, false, 1890000000, 1,  1000,   0, 1297, 7759, 92000, 9, "cm", 10);

INSERT INTO "SensingFlows"
    ("FlowId", "DeviceId", "FlowType", "Scale", "Duration", "UnixEpochStart", "UnixEpochEnd", "Minimum", "Maximum", "UnitOfMeasurement", "DatasetFilename")
VALUES
    ('10001', 'DEV-001', 1, 100, 3600, 1793145600, 1793149200,  6000,  9000, 'degC',  ''),
    ('10002', 'DEV-001', 2, 100, 1800, 1793149200, 1793151000,  6000, 14000, 'degC',  ''),
    ('10003', 'DEV-002', 1, 100, 7200, 1793145600, 1793152800, 15000, 25000, 'kPa',   'dev002_normal.csv'),
    ('10004', 'DEV-002', 7, 100, 3600, 1793152800, 1793156400, 15000, 35000, 'kPa',   'dev002_drift.csv'),
    ('10005', 'DEV-003', 1, 100, 3600, 1793145600, 1793149200,  3000,  6000, 'L/min', ''),
    ('10006', 'DEV-003', 4, 100,  900, 1793149200, 1793150100,  4500,  4500, 'L/min', ''),
    ('10007', 'DEV-004', 1, 100, 1800, 1793145600, 1793147400,   100,   500, 'mm/s',  'dev004_normal.csv'),
    ('10008', 'DEV-004', 6, 100, 1800, 1793147400, 1793149200,   100,  1200, 'mm/s',  'dev004_noise.csv'),
    ('10009', 'DEV-005', 1, 100, 3600, 1793145600, 1793149200,   200,   800, 'm',     ''),
    ('10010', 'DEV-005', 3, 100,  600, 1793149200, 1793149800,     0,     0, 'm',     '');

INSERT INTO "ActuationRules"
    ("RuleId", "DeviceId", "ConditionType", "ValueThreshold", "Scale", "TargetType", "TargetDeviceName",
     "TargetActionValue", "IsChained", "RuleIdIfConditionFalse", "RuleIdIfConditionTrue")
VALUES
    ('DEV-001-r1', 'DEV-001', 4,  9500, 100, 0, 'cooling_fan_relay',  1,    true,  'DEV-001-r2', ''),
    ('DEV-001-r2', 'DEV-001', 3,  5000, 100, 0, 'heater_relay',       1,    false, '',           ''),
    ('DEV-002-r1', 'DEV-002', 4, 30000, 100, 1, 'relief_valve_ctrl',  1,    true,  'DEV-002-r2', ''),
    ('DEV-002-r2', 'DEV-002', 3,  1000, 100, 1, 'pump_ctrl',          1,    false, '',           ''),
    ('DEV-003-r1', 'DEV-003', 3,  2000, 100, 0, 'bypass_valve',       1,    true,  'DEV-003-r2', ''),
    ('DEV-003-r2', 'DEV-003', 4,  8000, 100, 2, 'flow_throttle_dac',  2048, false, '',           ''),
    ('DEV-004-r1', 'DEV-004', 4,  1000, 100, 3, 'motor_drive_ctrl',   0,    true,  '',           'DEV-004-r2'),
    ('DEV-004-r2', 'DEV-004', 2,   800, 100, 4, 'alarm_beacon',       1,    false, '',           ''),
    ('DEV-005-r1', 'DEV-005', 2,   750, 100, 0, 'inlet_valve',        0,    true,  'DEV-005-r2', ''),
    ('DEV-005-r2', 'DEV-005', 1,   250, 100, 0, 'inlet_valve',        1,    false, '',           '');
