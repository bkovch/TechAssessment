use lull_reports;

drop table if exists lull_reports.order_products;

create table lull_reports.order_products as
with orders_transformed as (
    select 
        o.id as order_id,
        o.product_id,
        cast(date_format(o.ordered_at, '%Y-%m-01') as date) as month,
        cast(o.product_quantity as signed) as num_sold
    from lull_staging.orders o
)
select
    row_number() over (order by product_id, month) as id,
    product_id,
    month,
    sum(num_sold) as num_sold
from orders_transformed
group by product_id, month
order by id;

alter table lull_reports.order_products add  (
    constraint pk_order_products primary key (id),
    constraint fk_order_products_product foreign key (product_id) references lull_staging.products(id),
    unique index ix_order_products_month (product_id, month)
);

select * from lull_reports.order_products;

describe lull_reports.order_products;