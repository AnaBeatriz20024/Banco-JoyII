CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE produtos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(id) ON DELETE CASCADE,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) NOT NULL
);

CREATE TABLE itens_pedido (
    id SERIAL PRIMARY KEY,
    pedido_id INT REFERENCES pedidos(id) ON DELETE CASCADE,
    produto_id INT REFERENCES produtos(id) ON DELETE CASCADE,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL
);

CREATE TABLE log_pedidos (
    id SERIAL PRIMARY KEY,
    pedido_id INT,
    cliente_id INT,
    data_log TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mensagem TEXT
);

CREATE OR REPLACE FUNCTION registrar_novo_pedido()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_pedidos (pedido_id, cliente_id, mensagem)
    VALUES (NEW.id, NEW.cliente_id, 'Novo pedido inserido no sistema.');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_novo_pedido
AFTER INSERT ON pedidos
FOR EACH ROW
EXECUTE FUNCTION registrar_novo_pedido();

INSERT INTO clientes (nome, email, telefone) VALUES ('João Silva', 'joao@email.com', '11999999999');
INSERT INTO produtos (nome, descricao, preco, estoque) VALUES ('Camiseta Personalizada', 'Camiseta com logo da empresa', 50.00, 100);


INSERT INTO pedidos (cliente_id, total) VALUES (1, 150.00);


SELECT * FROM log_pedidos;
