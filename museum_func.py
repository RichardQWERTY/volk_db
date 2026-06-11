import psycopg2
from psycopg2 import Error as PsycopgError
import hashlib
import os

DB_CONFIG = {
    'dbname': 'museum_db',
    'user': 'юз',
    'password': 'пароль',
    'host': 'localhost',
    'port': '5432'
}

ROLES = {
    '1': 'admin',
    '2': 'curator',
    '3': 'conservator',
    '4': 'registrar',
    '5': 'viewer',
}


def get_connection():
    return psycopg2.connect(**DB_CONFIG)


def hash_password(password: str) -> str:
    """SHA-256 хэш пароля с солью."""
    salt = os.urandom(16).hex()
    digest = hashlib.sha256((salt + password).encode()).hexdigest()
    return f"{salt}:{digest}"


def add_exhibit():
    # добавление нового экспоната
    conn = get_connection()
    cur = conn.cursor()
    try:
        inv_num    = input("Инвентарный номер например ГЭ-####: ").strip()
        title_ru   = input("Название на русском: ").strip()
        title_en   = input("Название на английском: ").strip()
        category_id   = int(input("ID категории (1-живопись, 2-скульптура, 3-декоративное, 4-археология): ").strip())
        department_id = int(input("ID отдела (1-западноевропейское, 2-русское, 3-древний мир): ").strip())
        century    = input("Век создания (например XVII век): ").strip()
        hall_id    = input("ID зала (оставьте пустым если в хранилище): ").strip()
        storage_id = input("ID хранилища (оставьте пустым если в зале): ").strip()

        hall_id    = int(hall_id)    if hall_id    else None
        storage_id = int(storage_id) if storage_id else None

        # вызов функции из PostgreSQL
        cur.execute("""
            SELECT add_new_exhibit(%s, %s, %s, %s, %s, %s, %s, %s)
        """, (inv_num, title_ru, title_en, category_id, department_id,
              century, hall_id, storage_id))

        exhibit_id = cur.fetchone()[0]
        conn.commit()
        print(f"Экспонат успешно добавлен, ID: {exhibit_id}")
    except PsycopgError as e:
        conn.rollback()
        if e.pgcode == '23503':
            print("Ошибка: указан несуществующий ID категории/отдела/зала")
        elif e.pgcode == '23505':
            print("Ошибка: экспонат с таким инвентарным номером уже существует")
        else:
            print(f"Ошибка базы данных: {e}")
    except ValueError:
        print("Ошибка: ID должны быть числами")
    finally:
        cur.close()
        conn.close()


def show_full_exhibit_card():
    # полная карточка экспоната
    conn = get_connection()
    cur = conn.cursor()
    try:
        inv_num = input("Инвентарный номер: ").strip()

        # вызов функции из PostgreSQL
        cur.execute("SELECT * FROM get_full_exhibit_card(%s)", (inv_num,))

        row = cur.fetchone()
        if not row:
            print("Экспонат не найден")
            return

        print(f"\n{'=' * 60}")
        print(f"ИНВЕНТАРНЫЙ НОМЕР: {row[0]}")
        print(f"{'=' * 60}")
        print(f"Название:        {row[1]}")
        print(f"Век создания:    {row[2]}")
        print(f"Отдел:           {row[3]}")
        print(f"Местоположение:  {row[4] or 'в хранилище'}")
        print(f"Здание:          {row[5] or '-'}")
        print(f"Категория:       {row[6]}")
        print(f"Культура:        {row[7] or '-'}")
        print(f"Авторы:          {row[8] or 'неизвестен'}")
        print(f"Материалы:       {row[9] or '-'}")
        print(f"{'=' * 60}")

    except PsycopgError as e:
        print(f"Ошибка: {e}")
    finally:
        cur.close()
        conn.close()


def show_exhibits_in_exhibitions():
    # экспонаты на выставках (подзапрос EXISTS)
    conn = get_connection()
    cur = conn.cursor()
    try:
        # вызов функции из PostgreSQL
        cur.execute("SELECT * FROM get_exhibits_in_exhibitions()")
        rows = cur.fetchall()
        if not rows:
            print("Нет экспонатов на выставках")
            return
        print(f"\n{'Инв.номер':<12} {'Название':<40} {'Век':<10}")
        print("-" * 65)
        for row in rows:
            title = row[1][:37] + "..." if len(row[1]) > 37 else row[1]
            print(f"{row[0]:<12} {title:<40} {row[2]:<10}")
    except PsycopgError as e:
        print(f"Ошибка: {e}")
    finally:
        cur.close()
        conn.close()


def add_staff():
    # добавление нового сотрудника
    conn = get_connection()
    cur = conn.cursor()
    try:
        print("\n--- Добавление сотрудника ---")
        last_name   = input("Фамилия: ").strip()
        first_name  = input("Имя: ").strip()
        middle_name = input("Отчество (оставьте пустым если нет): ").strip() or None
        username    = input("Логин (username): ").strip()
        email       = input("Email: ").strip()
        password    = input("Пароль: ").strip()

        print("\nДоступные роли:")
        for key, val in ROLES.items():
            print(f"  {key}. {val}")
        role_choice = input("Выберите роль (1-5): ").strip()
        role = ROLES.get(role_choice)
        if not role:
            print("Ошибка: недопустимый выбор роли")
            return

        department_id = int(input("ID отдела: ").strip())
        position      = input("Должность: ").strip()

        password_hash = hash_password(password)

        # вызов функции из PostgreSQL
        cur.execute("""
            SELECT public.add_new_staff(
                %s, %s, %s, %s,
                %s, %s, %s,
                %s, %s
            )
        """, (
            username, email, password_hash, role,
            last_name, first_name, middle_name,
            department_id, position
        ))

        user_id = cur.fetchone()[0]
        conn.commit()
        print(f"\nСотрудник успешно добавлен")
        print(f"  ID:       {user_id}")
        print(f"  ФИО:      {last_name} {first_name} {middle_name or ''}")
        print(f"  Роль:     {role}")
        print(f"  Логин:    {username}")

    except PsycopgError as e:
        conn.rollback()
        if e.pgcode == '23505':
            # уточняем какое уникальное поле продублировано
            msg = str(e)
            if 'username' in msg:
                print("Ошибка: пользователь с таким логином уже существует")
            elif 'email' in msg:
                print("Ошибка: пользователь с таким email уже существует")
            else:
                print(f"Ошибка уникальности: {e}")
        elif e.pgcode == '23503':
            print("Ошибка: указан несуществующий ID отдела")
        elif e.pgcode == 'P0001':
            # RAISE EXCEPTION из функции (недопустимая роль и т.д.)
            print(f"Ошибка: {e.diag.message_primary}")
        else:
            print(f"Ошибка базы данных: {e}")
    except ValueError:
        print("Ошибка: ID отдела должен быть числом")
    finally:
        cur.close()
        conn.close()


def main():
    while True:
        print("\n Меню управления музея")
        print("1. Добавить экспонат")
        print("2. Показать карточку с полными данными экспоната")
        print("3. Показать экспонаты на выставках")
        print("4. Добавить сотрудника")
        print("0. Выход")

        choice = input("Выберите пункт: ").strip()

        if choice == '1':
            add_exhibit()
        elif choice == '2':
            show_full_exhibit_card()
        elif choice == '3':
            show_exhibits_in_exhibitions()
        elif choice == '4':
            add_staff()
        elif choice == '0':
            break
        else:
            print("Нужно выбрать от 0 до 4")


if __name__ == "__main__":
    main()
