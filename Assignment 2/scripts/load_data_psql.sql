CREATE TABLE clients (
    user_id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_purchase_date DATE
);

-- Создание таблицы продуктов
CREATE TABLE products (
    product_id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    stock_quantity INTEGER NOT NULL
);

-- Создание таблицы заказов
CREATE TABLE orders (
    order_id UUID PRIMARY KEY,
    user_id UUID REFERENCES clients(user_id) ON DELETE CASCADE,
    order_date TIMESTAMP NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL
);

-- Создание таблицы позиций в заказах
CREATE TABLE orders_items (
    order_item_id UUID PRIMARY KEY,
    order_id UUID REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(product_id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL
);
