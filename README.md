# Adventure Works — Analytics Engineering

Projeto de certificação em Engenharia de Analytics (Indicium), construindo uma plataforma moderna de analytics para a Adventure Works, indústria de bicicletas com mais de 500 produtos, 20.000 clientes e 31.000 pedidos.

## Arquitetura

```
Fonte (PostgreSQL)  →  Databricks (Data Warehouse)  →  dbt Cloud (Transformação)  →  Power BI (BI)
```

## Stack utilizada

| Camada | Ferramenta |
|---|---|
| Data Warehouse | Databricks (Unity Catalog) |
| Transformação | dbt Cloud |
| Repositório | GitHub |
| Visualização | Power BI Desktop |

## Estrutura do projeto dbt

```
models/
├── staging/                          # Camada de limpeza 1:1 das sources
│   ├── _sources.yml                  # Definição das sources + testes
│   ├── stg_sales__salesorderheader.sql
│   ├── stg_sales__salesorderdetail.sql
│   ├── stg_sales__customer.sql
│   ├── stg_sales__creditcard.sql
│   ├── stg_sales__personcreditcard.sql
│   ├── stg_sales__salesreason.sql
│   ├── stg_sales__salesorderheadersalesreason.sql
│   ├── stg_sales__specialofferproduct.sql
│   ├── stg_person__person.sql
│   ├── stg_person__address.sql
│   ├── stg_person__stateprovince.sql
│   ├── stg_person__countryregion.sql
│   ├── stg_production__product.sql
│   ├── stg_production__productsubcategory.sql
│   └── stg_production__productcategory.sql
└── marts/                            # Camada de consumo (fato + dimensões)
    ├── _marts__models.yml            # Documentação e testes dos marts
    ├── fct_sales.sql                 # Tabela fato de vendas
    ├── dim_customer.sql              # Dimensão cliente
    ├── dim_product.sql               # Dimensão produto (com subcategoria e categoria)
    ├── dim_address.sql               # Dimensão endereço (cidade, estado, país)
    ├── dim_credit_card.sql           # Dimensão cartão de crédito
    ├── dim_date.sql                  # Dimensão data
    ├── dim_sales_reason.sql          # Dimensão motivo de venda
    └── bridge_sales_order_reason.sql # Bridge table pedido ↔ motivo (N:N)

tests/
└── assert_gross_sales_2011.sql       # Validação: vendas brutas 2011 = $12.646.112,16
```

## Modelo dimensional (star schema)

```
                    ┌──────────────┐
                    │ dim_customer │
                    └──────┬───────┘
                           │
┌─────────────┐    ┌───────┴───────┐    ┌─────────────────┐
│ dim_product  ├────┤   fct_sales   ├────┤ dim_credit_card │
└─────────────┘    └───┬───┬───┬───┘    └─────────────────┘
                       │   │   │
              ┌────────┘   │   └────────┐
              │            │            │
     ┌────────┴───┐  ┌────┴─────┐  ┌───┴──────┐
     │ dim_address │  │ dim_date │  │  bridge   │
     └────────────┘  └──────────┘  └───┬──────┘
                                       │
                              ┌────────┴────────┐
                              │dim_sales_reason  │
                              └─────────────────┘
```

### Tabela fato

| Tabela | Grão | Origens |
|---|---|---|
| fct_sales | Uma linha por item vendido (sales_order_detail) | sales_salesorderheader + sales_salesorderdetail |

### Dimensões

| Dimensão | PK | Origens |
|---|---|---|
| dim_customer | customer_id | sales_customer + person_person |
| dim_product | product_id | production_product + productsubcategory + productcategory |
| dim_address | address_id | person_address + person_stateprovince + person_countryregion |
| dim_credit_card | credit_card_id | sales_creditcard |
| dim_date | date_key | Derivada de salesorderheader.orderdate |
| dim_sales_reason | sales_reason_id | sales_salesreason |
| bridge_sales_order_reason | sales_order_id + sales_reason_id | sales_salesorderheadersalesreason + sales_salesreason |

### Métricas

| Métrica | Cálculo | Descrição |
|---|---|---|
| order_qty | SUM(orderqty) | Quantidade comprada |
| gross_amount | SUM(unitprice × orderqty) | Valor bruto |
| net_amount | SUM(unitprice × orderqty × (1 - discount)) | Valor líquido |
| Total de Pedidos | DISTINCTCOUNT(sales_order_id) | Número de pedidos únicos |
| Ticket Médio | net_amount / Total de Pedidos | Valor médio por pedido |

## Testes implementados

### Testes de source
- `unique` e `not_null` em todas as PKs das tabelas-fonte

### Testes de modelos
- `unique` e `not_null` em todas as PKs das dimensões e fato

### Teste de dados (validação do negócio)
- **assert_gross_sales_2011**: valida que a soma de vendas brutas em 2011 é igual a $12.646.112,16, conforme informado pela auditoria contábil (solicitação do CEO Carlos Silveira)

## Dashboard (Power BI)

O dashboard possui 2 páginas interativas:

### Página 1 — Sales Overview
- KPIs: total de pedidos, quantidade vendida, valor bruto, ticket médio
- Série temporal de vendas por mês e ano (pergunta E)
- Top 5 cidades por valor (pergunta D)
- Distribuição por tipo de cartão
- Filtros: ano, país, cartão, motivo de venda

### Página 2 — Products & Customers
- Top 10 clientes por valor (pergunta C)
- Top 5 produtos por ticket médio (pergunta B)
- Tabela detalhada por produto (pergunta A)
- Produto com mais unidades em motivo "Promotion" (pergunta F): **Water Bottle - 30 oz.**

## Como executar

```bash
# Materializar todos os modelos
dbt run

# Rodar testes de source
dbt test --select source:*

# Rodar todos os testes
dbt test

# Executar tudo (run + test)
dbt build

# Gerar documentação
dbt docs generate
```

## Autor

Yuri Alves — Indicium