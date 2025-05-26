-- Продавцы
INSERT INTO dim_sellers (
    first_name, last_name, email, country, postal_code
)
SELECT DISTINCT
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM sales_data;

-- Локации
INSERT INTO dim_locations (location, city, state, country)
SELECT DISTINCT
    store_location,
    store_city,
    store_state,
    store_country
FROM sales_data
WHERE store_location IS NOT NULL;

-- Магазины
INSERT INTO dim_stores (name, location_id, phone, email)
SELECT DISTINCT
    s.store_name,
    l.location_id,
    s.store_phone,
    s.store_email
FROM sales_data s
JOIN dim_locations l ON
    s.store_location = l.location AND
    s.store_city = l.city AND
    s.store_state = l.state AND
    s.store_country = l.country;

-- Поставщики
INSERT INTO dim_suppliers (
    name, contact, email, phone, address, city, country
)
SELECT DISTINCT
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
FROM sales_data
ON CONFLICT DO NOTHING;

-- Даты
INSERT INTO dim_dates (
    date_id, day, month, year, quarter, day_of_week, is_weekend
)
SELECT DISTINCT
    sale_date,
    EXTRACT(DAY FROM sale_date),
    EXTRACT(MONTH FROM sale_date),
    EXTRACT(YEAR FROM sale_date),
    EXTRACT(QUARTER FROM sale_date),
    EXTRACT(DOW FROM sale_date) + 1,
    EXTRACT(DOW FROM sale_date) IN (0, 6)
FROM sales_data
WHERE sale_date IS NOT NULL
ON CONFLICT (date_id) DO NOTHING;

-- Домашние животные
INSERT INTO dim_pets (pet_type, pet_name, pet_breed)
SELECT DISTINCT
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed
FROM sales_data
WHERE customer_pet_type IS NOT NULL;

-- Покупатели
INSERT INTO dim_customers (
    first_name, last_name, age, email, country, postal_code, pet_id
)
SELECT DISTINCT
    s.customer_first_name,
    s.customer_last_name,
    s.customer_age::INT,
    s.customer_email,
    s.customer_country,
    s.customer_postal_code,
    p.pet_id
FROM sales_data s
JOIN dim_pets p ON
    s.customer_pet_type = p.pet_type AND
    s.customer_pet_name = p.pet_name AND
    s.customer_pet_breed = p.pet_breed;

-- Категории и параметры
INSERT INTO dim_categories (category_name)
SELECT DISTINCT product_category FROM sales_data WHERE product_category IS NOT NULL;

INSERT INTO dim_brands (brand_name)
SELECT DISTINCT product_brand FROM sales_data WHERE product_brand IS NOT NULL;

INSERT INTO dim_materials (material_name)
SELECT DISTINCT product_material FROM sales_data WHERE product_material IS NOT NULL;

INSERT INTO dim_colors (color_name)
SELECT DISTINCT product_color FROM sales_data WHERE product_color IS NOT NULL;

INSERT INTO dim_sizes (size_name)
SELECT DISTINCT product_size FROM sales_data WHERE product_size IS NOT NULL;

-- Продукты
INSERT INTO dim_products (
    name, category_id, price, weight, color_id, size_id,
    brand_id, material_id, description, rating, reviews,
    release_date, expiry_date, pet_category
)
SELECT DISTINCT
    s.product_name,
    c.category_id,
    s.product_price,
    s.product_weight,
    co.color_id,
    sz.size_id,
    b.brand_id,
    m.material_id,
    s.product_description,
    s.product_rating,
    s.product_reviews,
    s.product_release_date,
    s.product_expiry_date,
    s.pet_category
FROM sales_data s
JOIN dim_categories c ON s.product_category = c.category_name
JOIN dim_colors co ON s.product_color = co.color_name
JOIN dim_sizes sz ON s.product_size = sz.size_name
JOIN dim_brands b ON s.product_brand = b.brand_name
JOIN dim_materials m ON s.product_material = m.material_name;

-- Факты продаж
INSERT INTO fact_sales (
    date_id, customer_id, seller_id, product_id,
    store_id, supplier_id, quantity, total_price
)
SELECT
    t.sale_date,
    c.customer_id,
    s.seller_id,
    p.product_id,
    st.store_id,
    sp.supplier_id,
    t.sale_quantity::INT,
    t.sale_total_price::DECIMAL(10,2)
FROM sales_data t
JOIN dim_customers c ON t.customer_email = c.email
JOIN dim_sellers s ON t.seller_email = s.email
JOIN dim_products p ON t.product_name = p.name
JOIN dim_stores st ON t.store_name = st.name
JOIN dim_suppliers sp ON t.supplier_name = sp.name;
