COPY client_first_purchase_date (client_id, user_id, first_purchase_date, user_device_id)
FROM 'C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/data/client_first_purchase_date.csv'
DELIMITER ','
CSV HEADER;

COPY events (event_time, user_id, event_type, product_id, category_id, category_code, brand, price, user_session)
FROM 'C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/data/events.csv'
DELIMITER ','
CSV HEADER;

COPY campaigns (campaign_type, channel, topic, started_at, finished_at, total_count, ab_test, warmup_mode, hour_limit, subject_length, subject_with_personalization, subject_with_deadline, subject_with_emoji, subject_with_bonuses, subject_with_discount, subject_with_saleout, is_test, position)
FROM 'C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/data/campaigns.csv'
DELIMITER ','
CSV HEADER;

COPY messages (campaign_id, client_id, message_type, email_provider, platform, stream, date, sent_at, is_opened, opened_first_time_at, opened_last_time_at, is_clicked, clicked_first_time_at, clicked_last_time_at, is_unsubscribed, unsubscribed_at, is_hard_bounced, hard_bounced_at, is_soft_bounced, soft_bounced_at, is_complained, complained_at, is_blocked, blocked_at, is_purchased, purchased_at, channel)
FROM 'C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/data/messages.csv'
DELIMITER ','
CSV HEADER;

COPY friends (user_id_1, user_id_2)
FROM 'C:/Users/User/Desktop/2 Part/Big Data/Assignment 2/data/friends.csv'
DELIMITER ','
CSV HEADER;
