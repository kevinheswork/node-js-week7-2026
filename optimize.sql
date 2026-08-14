-- ============================================================
-- 🚑 你的處方箋（工單 1~5 的解法寫在這裡）
--
-- 寫法：對症下索引，例如
--   CREATE INDEX idx_xxx ON 表名 (欄位);
--
-- 提醒：
-- 1. 跑 npm run optimize 會執行這個檔案（重複執行可在 CREATE INDEX 後加上 IF NOT EXISTS）
-- 2. 如果更換新索引，原先沒有使用的索引記得 DROP（索引並非越多越好）
-- 3. 工單 6 的撰寫可到：queries/06-rewrite.sql
-- ============================================================

-- 工單 1：客服查會員
CREATE INDEX idx_email ON users(email);
SELECT * FROM users WHERE email = 'user250000@livefit.tw';

-- 工單 2：企業會員的課表
-- CREATE INDEX idx_user_id_cancelled_at ON course_bookings(user_id,cancelled_at);
CREATE INDEX idx_cancelled_at_is_null ON course_bookings(cancelled_at) WHERE cancelled_at IS NULL;
SELECT * FROM course_bookings WHERE user_id = 1003 AND cancelled_at IS NULL

-- 工單 3：最新購買紀錄牆
CREATE INDEX idx_purchase_at ON credit_purchases(purchase_at);
SELECT * FROM credit_purchases ORDER BY purchase_at DESC LIMIT 100


-- 工單 4：首頁「進行中課程」
CREATE INDEX idx_start_at_end_at ON courses(start_at, end_at);
SELECT * FROM courses WHERE start_at <= NOW() AND end_at > NOW()

-- 工單 5：上週開課課程的教練報名統計（思考方向：需新增兩個索引）
CREATE INDEX idx_course_id ON course_bookings(course_id);
SELECT u.name, COUNT(*) AS bookings
FROM courses c
JOIN course_bookings b ON b.course_id = c.id
JOIN users u ON u.id = c.user_id
WHERE c.start_at >= NOW() - interval '7 days'
  AND c.start_at <  NOW()
  AND b.cancelled_at IS NULL
GROUP BY u.name


-- 加分題（選做）：使用部分索引（partial index）讓工單 2 的索引更小、更有效率

