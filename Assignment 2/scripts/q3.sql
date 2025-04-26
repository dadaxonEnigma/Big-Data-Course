SELECT DISTINCT e.product_id, 
       e.category_code, 
       e.brand, 
       e.price,
       to_tsvector('english', e.category_code) AS tsvector
FROM public.events e
LIMIT 10;
