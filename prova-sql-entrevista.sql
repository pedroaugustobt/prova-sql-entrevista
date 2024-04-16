-- Lista de funcionários ordenando pelo salário decrescente
SELECT *
FROM VENDEDORES
ORDER BY salario DESC;

-- Lista de pedidos de vendas ordenado por data de emissão
SELECT *
FROM PEDIDO
ORDER BY data_emissao;

-- Valor de faturamento por cliente
SELECT CLIENTES.id_cliente, CLIENTES.razao_social AS cliente, SUM(PEDIDO.valor_total) AS faturamento
FROM PEDIDO
JOIN CLIENTES ON PEDIDO.id_cliente = CLIENTES.id_cliente
GROUP BY CLIENTES.id_cliente, CLIENTES.razao_social
ORDER BY faturamento DESC;

-- Valor de faturamento por empresa
SELECT c.id_empresa, e.razao_social AS empresa, SUM(p.valor_total) AS faturamento
FROM PEDIDO p
JOIN CLIENTES c ON p.id_cliente = c.id_cliente
JOIN EMPRESA e ON c.id_empresa = e.id_empresa
GROUP BY c.id_empresa, e.razao_social
ORDER BY faturamento DESC;

-- Valor de faturamento por vendedor
SELECT v.id_vendedor, v.nome AS vendedor, SUM(p.valor_total) AS faturamento
FROM PEDIDO p
JOIN CLIENTES c ON p.id_cliente = c.id_cliente
JOIN VENDEDORES v ON c.id_vendedor = v.id_vendedor
GROUP BY v.id_vendedor, v.nome
ORDER BY faturamento DESC;

-- Consulta de junção
SELECT
    p.id_produto,
    p.descricao AS descricao_produto,
    c.id_cliente,
    c.razao_social AS razao_social_cliente,
    c.id_empresa,
    e.razao_social AS razao_social_empresa,
    c.id_vendedor,
    v.nome AS nome_vendedor,
    cp.preco_minimo,
    cp.preco_maximo,
    COALESCE(ip.preco_praticado, cp.preco_minimo) AS preco_base
FROM
    PRODUTOS p
JOIN
    (
        SELECT
            ip.id_produto,
            c.id_cliente,
            MAX(ip.id_item_pedido) AS ultimo_pedido
        FROM
            ITENS_PEDIDO ip
        JOIN
            CLIENTES c ON ip.id_pedido = c.id_cliente
        GROUP BY
            ip.id_produto,
            c.id_cliente
    ) AS ultimos_pedidos ON p.id_produto = ultimos_pedidos.id_produto
JOIN
    ITENS_PEDIDO ip ON ultimos_pedidos.ultimo_pedido = ip.id_item_pedido
JOIN
    CLIENTES c ON ip.id_pedido = c.id_cliente
JOIN
    EMPRESA e ON c.id_empresa = e.id_empresa
JOIN
    VENDEDORES v ON c.id_vendedor = v.id_vendedor
JOIN
    CONFIG_PRECO_PRODUTO cp ON p.id_produto = cp.id_produto AND c.id_vendedor = cp.id_vendedor AND c.id_empresa = cp.id_empresa
ORDER BY
    p.id_produto,
    c.id_cliente;

