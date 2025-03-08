-- Удаление таблиц, если они существуют
DROP TABLE IF EXISTS public.campaigns;
DROP TABLE IF EXISTS public.client_first_purchase_date;
DROP TABLE IF EXISTS public.events;
DROP TABLE IF EXISTS public.friends;
DROP TABLE IF EXISTS public.messages;

-- Создание таблиц
CREATE TABLE IF NOT EXISTS public.campaigns (
    id SERIAL,
    campaign_type VARCHAR(20),
    channel VARCHAR(20),
    topic TEXT,
    started_at TIMESTAMP,
    finished_at TIMESTAMP,
    total_count NUMERIC,
    ab_test BOOLEAN,
    warmup_mode BOOLEAN,
    hour_limit NUMERIC,
    subject_length NUMERIC,
    subject_with_personalization BOOLEAN,
    subject_with_deadline BOOLEAN,
    subject_with_emoji BOOLEAN,
    subject_with_bonuses BOOLEAN,
    subject_with_discount BOOLEAN,
    subject_with_saleout BOOLEAN,
    is_test BOOLEAN,
    position NUMERIC
);

CREATE TABLE IF NOT EXISTS public.client_first_purchase_date (
    client_id BIGINT NOT NULL PRIMARY KEY,
    first_purchase_date DATE,
    user_id BIGINT NOT NULL,
    user_device_id INTEGER
);

CREATE TABLE IF NOT EXISTS public.events (
    event_time TIMESTAMP NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    product_id BIGINT,
    category_id BIGINT,
    category_code VARCHAR(255),
    brand VARCHAR(255),
    price NUMERIC(10, 2),
    user_id BIGINT NOT NULL,
    user_session UUID
);

CREATE TABLE IF NOT EXISTS public.friends (
    user_id_1 INTEGER NOT NULL,
    user_id_2 INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS public.messages (
    id BIGINT,
    message_id TEXT,
    campaign_id BIGINT NOT NULL,
    message_type VARCHAR(255),
    client_id BIGINT NOT NULL,
    channel VARCHAR,
    platform VARCHAR,
    email_provider VARCHAR,
    stream VARCHAR,
    date DATE,
    sent_at TIMESTAMP,
    is_opened BOOLEAN,
    opened_first_time_at TIMESTAMP,
    opened_last_time_at TIMESTAMP,
    is_clicked BOOLEAN,
    clicked_first_time_at TIMESTAMP,
    clicked_last_time_at TIMESTAMP,
    is_unsubscribed BOOLEAN,
    unsubscribed_at TIMESTAMP,
    is_hard_bounced BOOLEAN,
    hard_bounced_at TIMESTAMP,
    is_soft_bounced BOOLEAN,
    soft_bounced_at TIMESTAMP,
    is_complained BOOLEAN,
    complained_at DATE,
    is_blocked BOOLEAN,
    blocked_at TIMESTAMP,
    is_purchased BOOLEAN,
    purchased_at TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    user_device_id INTEGER,
    user_id INTEGER
);

-- Загрузка данных из CSV файлов
-- Убедись, что файлы находятся в доступном месте

-- Загрузка данных в таблицу campaigns
\copy public.campaigns FROM 'C:/Users/User/Desktop/data/cleaned_campaigns.csv' DELIMITER ',' CSV HEADER;

-- -- Загрузка данных в таблицу client_first_purchase_date
\copy public.client_first_purchase_date FROM 'C:/Users/User/Desktop/data/cleaned_client_first_purchase_date.csv' DELIMITER ',' CSV HEADER;

-- -- Загрузка данных в таблицу events
\copy public.events FROM 'C:/Users/User/Desktop/data/cleaned_events.csv' DELIMITER ',' CSV HEADER;

-- -- Загрузка данных в таблицу friends
\copy public.friends FROM 'C:/Users/User/Desktop/data/cleaned_friends.csv' DELIMITER ',' CSV HEADER;

-- Загрузка данных в таблицу messages
\copy public.messages FROM 'C:/Users/User/Desktop/data/cleaned_messages.csv' DELIMITER ',' CSV HEADER;



-- Создание индексов для ускорения запросов
CREATE INDEX IF NOT EXISTS campaigns_start_idx ON public.campaigns USING btree (started_at);
CREATE INDEX IF NOT EXISTS campaigns_type_idx ON public.campaigns USING btree (campaign_type);
CREATE INDEX IF NOT EXISTS client_purchase_user_idx ON public.client_first_purchase_date USING btree (user_id);
CREATE INDEX IF NOT EXISTS events_product_idx ON public.events USING btree (product_id);
CREATE INDEX IF NOT EXISTS events_user_idx ON public.events USING btree (user_id);
CREATE INDEX IF NOT EXISTS friends_user1_idx ON public.friends USING btree (user_id_1);
CREATE INDEX IF NOT EXISTS friends_user2_idx ON public.friends USING btree (user_id_2);
CREATE INDEX IF NOT EXISTS messages_client_idx ON public.messages USING btree (client_id);
CREATE INDEX IF NOT EXISTS messages_date_idx ON public.messages USING btree (date);

-- Завершение скрипта
