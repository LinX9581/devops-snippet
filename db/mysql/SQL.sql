"GROUP BY hour"
SELECT DATE_FORMAT(`time`, "%H") AS hour, sum(pv) as pv FROM www.realtime WHERE time >= ? AND time < ? GROUP BY hour(time)

"Join Table GROUP TIME "
SELECT SUM(post_views_count) AS pv , DATE_FORMAT(count_time,'%Y-%m-%d %H:%i:%S') AS count_time FROM www.post_info INNER JOIN www.post_pv_count ON `post_info`.`post_id` = `post_pv_count`.`post_id` WHERE (count_time BETWEEN ? AND ?) GROUP BY count_time

"過濾重複值"
count(distinct `post_pv_count`.`post_id`) AS count

"用禮拜排序 算出每個禮拜一 二 三.. 平均值"
SELECT round(avg(pageviews)) as pageviews, round(avg(users)) as users, round(avg(page_per_user),2) as page_per_user, round(avg(session_per_user),2) as session_per_user FROM www.ga_metrics WHERE date >= ? AND date <= ? GROUP BY WEEKDAY(date)