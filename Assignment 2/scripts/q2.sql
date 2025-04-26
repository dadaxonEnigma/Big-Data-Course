SELECT 
    e.user_id,
    e.product_id,
    COUNT(*) AS interaction_count,
    SUM(CASE WHEN e.event_type = 'purchase' THEN 1 ELSE 0 END) AS purchase_count
FROM public.events e
WHERE e.event_type IN ('view', 'cart', 'purchase')
GROUP BY e.user_id, e.product_id
HAVING SUM(CASE WHEN e.event_type = 'purchase' THEN 1 ELSE 0 END) > 1
ORDER BY e.user_id, purchase_count DESC, interaction_count DESC
LIMIT 10;
