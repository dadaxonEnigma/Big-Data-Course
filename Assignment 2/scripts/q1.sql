SELECT 
    campaigns.id,  
    campaigns.campaign_type, 
    campaigns.channel, 
    campaigns.total_count, 
    campaigns.is_test, 
    campaigns.position, 
    COUNT(DISTINCT messages.client_id) AS clients_reached,
    COALESCE(SUM(CASE WHEN messages.is_purchased THEN 1 ELSE 0 END), 0) AS purchases_made,
    ROUND(100.0 * COALESCE(SUM(CASE WHEN messages.is_purchased THEN 1 ELSE 0 END), 0) / NULLIF(COUNT(DISTINCT messages.client_id), 0), 2) AS purchase_rate
FROM public.campaigns  
LEFT JOIN public.messages ON campaigns.id = messages.campaign_id
GROUP BY campaigns.id, campaigns.campaign_type, campaigns.channel, campaigns.total_count, campaigns.is_test, campaigns.position
HAVING COUNT(DISTINCT messages.client_id) > 0
ORDER BY purchase_rate DESC;
