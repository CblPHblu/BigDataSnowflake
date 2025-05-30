import csv
import psycopg2

# Подключение к БД
conn = psycopg2.connect(
    dbname="bigdata",
    user="postgres",
    password="postgres",
    host="localhost",
    port="5432"
)
cursor = conn.cursor()

def import_csv_to_postgres(path):
    with open(path, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            cursor.execute("SELECT id FROM sales_data WHERE id = %s", (row['id'],))
            if cursor.fetchone():
                cursor.execute("SELECT MAX(id) FROM sales_data")
                max_id = cursor.fetchone()[0] or 0
                row['id'] = int(max_id) + 1

            cursor.execute("""
                INSERT INTO sales_data (
                    id, customer_first_name, customer_last_name, customer_age, customer_email,
                    customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
                    customer_pet_breed, seller_first_name, seller_last_name, seller_email,
                    seller_country, seller_postal_code, product_name, product_category,
                    product_price, product_quantity, sale_date, sale_customer_id, sale_seller_id,
                    sale_product_id, sale_quantity, sale_total_price, store_name, store_location,
                    store_city, store_state, store_country, store_phone, store_email, pet_category,
                    product_weight, product_color, product_size, product_brand, product_material,
                    product_description, product_rating, product_reviews, product_release_date,
                    product_expiry_date, supplier_name, supplier_contact, supplier_email,
                    supplier_phone, supplier_address, supplier_city, supplier_country
                ) VALUES (%(id)s, %(customer_first_name)s, %(customer_last_name)s, %(customer_age)s,
                          %(customer_email)s, %(customer_country)s, %(customer_postal_code)s,
                          %(customer_pet_type)s, %(customer_pet_name)s, %(customer_pet_breed)s,
                          %(seller_first_name)s, %(seller_last_name)s, %(seller_email)s,
                          %(seller_country)s, %(seller_postal_code)s, %(product_name)s,
                          %(product_category)s, %(product_price)s, %(product_quantity)s,
                          %(sale_date)s, %(sale_customer_id)s, %(sale_seller_id)s,
                          %(sale_product_id)s, %(sale_quantity)s, %(sale_total_price)s,
                          %(store_name)s, %(store_location)s, %(store_city)s, %(store_state)s,
                          %(store_country)s, %(store_phone)s, %(store_email)s, %(pet_category)s,
                          %(product_weight)s, %(product_color)s, %(product_size)s,
                          %(product_brand)s, %(product_material)s, %(product_description)s,
                          %(product_rating)s, %(product_reviews)s, %(product_release_date)s,
                          %(product_expiry_date)s, %(supplier_name)s, %(supplier_contact)s,
                          %(supplier_email)s, %(supplier_phone)s, %(supplier_address)s,
                          %(supplier_city)s, %(supplier_country)s
                )
            """, row)

    conn.commit()
    print(f"[OK] Загружен файл: {path}")

# Загрузка всех файлов
for i in range(10):
    path = "mock_data/MOCK_DATA.csv" if i == 0 else f"mock_data/MOCK_DATA ({i}).csv"
    import_csv_to_postgres(path)

cursor.close()
conn.close()
