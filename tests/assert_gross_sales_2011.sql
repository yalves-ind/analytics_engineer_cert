-- Teste de validação solicitado pelo CEO Carlos Silveira.
-- As vendas brutas no ano de 2011 devem ser de $12.646.112,16.
-- Se este teste retornar linhas, significa que o valor está incorreto.

select
    round(sum(gross_amount), 2) as gross_sales_2011
from {{ ref('fct_sales') }}
where extract(year from order_date) = 2011
having round(sum(gross_amount), 2) != 12646112.16
