from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import pandas as pd
from sqlalchemy import create_engine

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2025, 1, 1),
    'retries': 1
}

def transform_data():
    engine = create_engine('postgresql://admin:admin@postgres:5432/battery_db')
    
    # 1. Ambil data dari Staging
    df_usage = pd.read_sql("SELECT * FROM staging.stg_activity", engine)
    
    # Ambil data cuaca dengan proteksi (jika tabel tidak ada, pakai default 30)
    try:
        df_weather = pd.read_sql("SELECT * FROM staging.stg_weather", engine)
        temp_now = df_weather['temp_c'].iloc[0]
    except Exception:
        temp_now = 30.0  # Suhu default jika tabel staging.stg_weather belum ada
    
    # 2. Logika Rekomendasi
    df_usage['recommendation'] = df_usage['battery_usage_percent'].apply(
        lambda x: "Charge Sekarang (Boros)" if x > 15 else "Baterai Aman"
    )
    
    if temp_now > 30:
        advice = f"Suhu Banjarmasin Panas ({temp_now}°C), jangan gunakan Fast Charging!"
    else:
        advice = "Suhu Ideal untuk Charging."

    # 3. Simpan ke Data Warehouse
    df_usage['weather_advice'] = advice
    
    # Pastikan skema DWH ada
    from sqlalchemy import text
    with engine.begin() as conn:
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS datawarehouse;"))

    df_usage.to_sql('final_recommendations', engine, schema='datawarehouse', if_exists='replace', index=False)
    print("✅ Transformasi ETL Berhasil!")
    
with DAG('battery_optimization_etl', default_args=default_args, schedule_interval='@daily', catchup=False) as dag:
    
    task_etl = PythonOperator(
        task_id='run_battery_transformation',
        python_callable=transform_data
    )