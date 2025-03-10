SELECT 
    campaigns.id,  
    campaigns.campaign_type, 
    campaigns.channel, 
    campaigns.total_count, 
    campaigns.is_test, 
    campaigns.position, 
    COUNT(DISTINCT messages.client_id) AS clients_reached,
    SUM(messages.total_purchases) AS purchases_made,
    ROUND(100.0 * SUM(messages.total_purchases) / NULLIF(COUNT(DISTINCT messages.client_id), 0), 2) AS purchase_rate
FROM public.campaigns  
INNER JOIN (
    SELECT campaign_id, client_id, 
           SUM(CASE WHEN is_purchased THEN 1 ELSE 0 END) AS total_purchases
    FROM public.messages
    GROUP BY campaign_id, client_id
) messages ON campaigns.id = messages.campaign_id
GROUP BY campaigns.id, campaigns.campaign_type, campaigns.channel, campaigns.total_count, campaigns.is_test, campaigns.position
HAVING COUNT(DISTINCT messages.client_id) > 0
ORDER BY purchase_rate DESC
LIMIT 10;
