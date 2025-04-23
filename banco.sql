import sqlite3

DATABASE_FILE = 'ponto.db'

def criar_tabela():
    conn = sqlite3.connect(DATABASE_FILE)
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS registros_ponto (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            funcionario_id TEXT NOT NULL,
            data_hora DATETIME NOT NULL
        )
    ''')
    conn.commit()
    conn.close()

def registrar_ponto(funcionario_id):
    conn = sqlite3.connect(DATABASE_FILE)
    cursor = conn.cursor()
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    try:
        cursor.execute("INSERT INTO registros_ponto (funcionario_id, data_hora) VALUES (?, ?)", (funcionario_id, now))
        conn.commit()
        conn.close()
        return True
    except Exception as e:
        print(f"Erro ao registrar ponto no banco de dados: {e}")
        conn.rollback()
        conn.close()
        return False

def listar_registros():
    conn = sqlite3.connect(DATABASE_FILE)
    cursor = conn.cursor()
    cursor.execute("SELECT id, funcionario_id, data_hora FROM registros_ponto ORDER BY data_hora DESC")
    registros = cursor.fetchall()
    conn.close()
    return registros

if __name__ == '__main__':
    from datetime import datetime
    criar_tabela()
    print("Tabela 'registros_ponto' criada (se não existia).")

    # Exemplo de registro
    funcionario_exemplo = "FUNC001"
    if registrar_ponto(funcionario_exemplo):
        print(f"Ponto registrado para {funcionario_exemplo} com sucesso.")
    else:
        print(f"Falha ao registrar ponto para {funcionario_exemplo}.")

    # Exemplo de listagem
    registros = listar_registros()
    if registros:
        print("\nRegistros de Ponto:")
        for registro in registros:
            print(f"ID: {registro[0]}, Funcionário: {registro[1]}, Data/Hora: {registro[2]}")
    else:
        print("\nAinda não há registros de ponto.")
