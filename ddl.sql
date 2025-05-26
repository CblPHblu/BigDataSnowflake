-- Таблица продавцов
CREATE TABLE dim_sellers (
    seller_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    country VARCHAR(100),
    postal_code VARCHAR(20)
);

-- Таблица магазинов
CREATE TABLE dim_stores (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    location_id INTEGER REFERENCES dim_locations(location_id),
    phone VARCHAR(50),
    email VARCHAR(255)
);

-- Таблица поставщиков
CREATE TABLE dim_suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    contact VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(50),
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100)
);

-- Таблица дат
CREATE TABLE dim_dates (
    date_id DATE PRIMARY KEY,
    day INTEGER,
    month INTEGER,
    year INTEGER,
    quarter INTEGER,
    day_of_week INTEGER,
    is_weekend BOOLEAN
);

-- Фактовая таблица
CREATE TABLE fact_sales (
    sale_id SERIAL PRIMARY KEY,
    date_id DATE REFERENCES dim_dates(date_id),
    customer_id INTEGER REFERENCES dim_customers(customer_id),
    seller_id INTEGER REFERENCES dim_sellers(seller_id),
    product_id INTEGER REFERENCES dim_products(product_id),
    store_id INTEGER REFERENCES dim_stores(store_id),
    supplier_id INTEGER REFERENCES dim_suppliers(supplier_id),
    quantity INTEGER,
    total_price DECIMAL(10, 2)
);

-- Таблица домашних животных
CREATE TABLE dim_pets (
    pet_id SERIAL PRIMARY KEY,
    pet_type VARCHAR(50),
    pet_name VARCHAR(100),
    pet_breed VARCHAR(100)
);

-- Покупатели
CREATE TABLE dim_customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    age INTEGER,
    email VARCHAR(255),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    pet_id INTEGER REFERENCES dim_pets(pet_id)
);

-- Категориальные таблицы
CREATE TABLE dim_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE dim_brands (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(100)
);

CREATE TABLE dim_materials (
    material_id SERIAL PRIMARY KEY,
    material_name VARCHAR(100)
);

CREATE TABLE dim_colors (
    color_id SERIAL PRIMARY KEY,
    color_name VARCHAR(50)
);

CREATE TABLE dim_sizes (
    size_id SERIAL PRIMARY KEY,
    size_name VARCHAR(20)
);

-- Таблица товаров
CREATE TABLE dim_products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    category_id INTEGER REFERENCES dim_categories(category_id),
    price NUMERIC(10,2),
    weight DECIMAL(10,2),
    color_id INTEGER REFERENCES dim_colors(color_id),
    size_id INTEGER REFERENCES dim_sizes(size_id),
    brand_id INTEGER REFERENCES dim_brands(brand_id),
    material_id INTEGER REFERENCES dim_materials(material_id),
    description TEXT,
    rating DECIMAL(3,1),
    reviews INTEGER,
    release_date DATE,
    expiry_date DATE,
    pet_category VARCHAR(50)
);

-- Таблица локаций
CREATE TABLE dim_locations (
    location_id SERIAL PRIMARY KEY,
    location VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);
