LOAD CSV WITH HEADERS FROM 'file:///cleaned_campaigns.csv' AS row
WITH row, 
     toInteger(row.id) AS id, 
     datetime(replace(row.started_at, ' ', 'T')) AS started_at, 
     datetime(replace(row.finished_at, ' ', 'T')) AS finished_at,
     toFloat(row.total_count) AS total_count,
     toFloat(row.hour_limit) AS hour_limit,
     toInteger(row.subject_length) AS subject_length,
     toFloat(row.position) AS position
CREATE (c:Campaign {
    id: id,
    campaign_type: row.campaign_type,
    channel: row.channel,
    topic: row.topic,
    started_at: started_at,
    finished_at: finished_at,
    total_count: total_count,
    ab_test: row.ab_test = 'true',
    warmup_mode: row.warmup_mode = 'true',
    hour_limit: hour_limit,
    subject_length: subject_length,
    subject_with_personalization: row.subject_with_personalization = 'true',
    subject_with_deadline: row.subject_with_deadline = 'true',
    subject_with_emoji: row.subject_with_emoji = 'true',
    subject_with_bonuses: row.subject_with_bonuses = 'true',
    subject_with_discount: row.subject_with_discount = 'true',
    subject_with_saleout: row.subject_with_saleout = 'true',
    is_test: row.is_test = 'true',
    position: position
});

LOAD CSV WITH HEADERS FROM 'file:///cleaned_client_first_purchase_date.csv' AS row
WITH row, 
     toInteger(row.client_id) AS client_id, 
     date(row.first_purchase_date) AS first_purchase_date, 
     toInteger(row.user_id) AS user_id, 
     toInteger(row.user_device_id) AS user_device_id
CREATE (c:ClientFirstPurchaseDate {
    client_id: client_id,
    first_purchase_date: first_purchase_date,
    user_id: user_id,
    user_device_id: user_device_id
});

LOAD CSV WITH HEADERS FROM 'file:///cleaned_events.csv' AS row
WITH row, 
     datetime(replace(row.event_time, ' ', 'T')) AS event_time, 
     toInteger(row.product_id) AS product_id, 
     toInteger(row.category_id) AS category_id, 
     toFloat(row.price) AS price, 
     toInteger(row.user_id) AS user_id
CREATE (e:Event {
    event_time: event_time,
    event_type: row.event_type,
    product_id: product_id,
    category_id: category_id,
    category_code: row.category_code,
    brand: row.brand,
    price: price,
    user_id: user_id,
    user_session: row.user_session
});

LOAD CSV WITH HEADERS FROM 'file:///cleaned_friends.csv' AS row
WITH row, 
     toInteger(row.user_id_1) AS user_id_1, 
     toInteger(row.user_id_2) AS user_id_2
MATCH (u1:User {id: user_id_1}), (u2:User {id: user_id_2})
MERGE (u1)-[:FRIEND_OF]->(u2);

LOAD CSV WITH HEADERS FROM 'file:///cleaned_messages.csv' AS row
WITH row, 
     toInteger(row.id) AS id, 
     toInteger(row.campaign_id) AS campaign_id, 
     toInteger(row.client_id) AS client_id, 
     date(row.date) AS date,
     datetime(replace(substring(row.sent_at, 0, 19), ' ', 'T')) AS sent_at,
     CASE WHEN row.is_opened = 'true' THEN true ELSE false END AS is_opened,
     CASE WHEN row.is_clicked = 'true' THEN true ELSE false END AS is_clicked,
     CASE WHEN row.is_unsubscribed = 'true' THEN true ELSE false END AS is_unsubscribed,
     CASE WHEN row.is_hard_bounced = 'true' THEN true ELSE false END AS is_hard_bounced,
     CASE WHEN row.is_soft_bounced = 'true' THEN true ELSE false END AS is_soft_bounced,
     CASE WHEN row.is_complained = 'true' THEN true ELSE false END AS is_complained,
     CASE WHEN row.is_blocked = 'true' THEN true ELSE false END AS is_blocked,
     CASE WHEN row.is_purchased = 'true' THEN true ELSE false END AS is_purchased,
     datetime(replace(substring(row.created_at, 0, 19), ' ', 'T')) AS created_at,
     datetime(replace(substring(row.updated_at, 0, 19), ' ', 'T')) AS updated_at,
     toInteger(row.user_device_id) AS user_device_id,
     toInteger(row.user_id) AS user_id
CREATE (m:Message {
    id: id,
    message_id: row.message_id,
    campaign_id: campaign_id,
    message_type: row.message_type,
    client_id: client_id,
    channel: row.channel,
    platform: row.platform,
    email_provider: row.email_provider,
    stream: row.stream,
    date: date,
    sent_at: sent_at,
    is_opened: is_opened,
    opened_first_time_at: CASE WHEN row.opened_first_time_at IS NOT NULL AND row.opened_first_time_at <> '' THEN datetime(replace(substring(row.opened_first_time_at, 0, 19), ' ', 'T')) ELSE null END,
    opened_last_time_at: CASE WHEN row.opened_last_time_at IS NOT NULL AND row.opened_last_time_at <> '' THEN datetime(replace(substring(row.opened_last_time_at, 0, 19), ' ', 'T')) ELSE null END,
    is_clicked: is_clicked,
    clicked_first_time_at: CASE WHEN row.clicked_first_time_at IS NOT NULL AND row.clicked_first_time_at <> '' THEN datetime(replace(substring(row.clicked_first_time_at, 0, 19), ' ', 'T')) ELSE null END,
    clicked_last_time_at: CASE WHEN row.clicked_last_time_at IS NOT NULL AND row.clicked_last_time_at <> '' THEN datetime(replace(substring(row.clicked_last_time_at, 0, 19), ' ', 'T')) ELSE null END,
    is_unsubscribed: is_unsubscribed,
    unsubscribed_at: CASE WHEN row.unsubscribed_at IS NOT NULL AND row.unsubscribed_at <> '' THEN datetime(replace(substring(row.unsubscribed_at, 0, 19), ' ', 'T')) ELSE null END,
    is_hard_bounced: is_hard_bounced,
    hard_bounced_at: CASE WHEN row.hard_bounced_at IS NOT NULL AND row.hard_bounced_at <> '' THEN datetime(replace(substring(row.hard_bounced_at, 0, 19), ' ', 'T')) ELSE null END,
    is_soft_bounced: is_soft_bounced,
    soft_bounced_at: CASE WHEN row.soft_bounced_at IS NOT NULL AND row.soft_bounced_at <> '' THEN datetime(replace(substring(row.soft_bounced_at, 0, 19), ' ', 'T')) ELSE null END,
    is_complained: is_complained,
    complained_at: CASE WHEN row.complained_at IS NOT NULL AND row.complained_at <> '' THEN date(row.complained_at) ELSE null END,
    is_blocked: is_blocked,
    blocked_at: CASE WHEN row.blocked_at IS NOT NULL AND row.blocked_at <> '' THEN datetime(replace(substring(row.blocked_at, 0, 19), ' ', 'T')) ELSE null END,
    is_purchased: is_purchased,
    purchased_at: CASE WHEN row.purchased_at IS NOT NULL AND row.purchased_at <> '' THEN datetime(replace(substring(row.purchased_at, 0, 19), ' ', 'T')) ELSE null END,
    created_at: created_at,
    updated_at: updated_at,
    user_device_id: user_device_id,
    user_id: user_id
});

CREATE INDEX IF NOT EXISTS FOR (c:Campaign) ON (c.started_at);
CREATE INDEX IF NOT EXISTS FOR (c:Campaign) ON (c.campaign_type);
CREATE INDEX IF NOT EXISTS FOR (cf:ClientFirstPurchaseDate) ON (cf.user_id);
CREATE INDEX IF NOT EXISTS FOR (e:Event) ON (e.product_id);
CREATE INDEX IF NOT EXISTS FOR (e:Event) ON (e.user_id);
CREATE INDEX IF NOT EXISTS FOR (f:Friend) ON (f.user_id_1);
CREATE INDEX IF NOT EXISTS FOR (f:Friend) ON (f.user_id_2);
CREATE INDEX IF NOT EXISTS FOR (m:Message) ON (m.client_id);
CREATE INDEX IF NOT EXISTS FOR (m:Message) ON (m.date);
