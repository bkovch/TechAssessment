use lull_reports;

drop table if exists lull_reports.marketing_orders;

create table lull_reports.marketing_orders as
with marketing_products as (
    select
        mo.marketing_id, # represents "ad network" + "source"
        o.product_id,
        sum(o.product_quantity) as product_quantity,
        max(o.ordered_at) as most_recent_sold_date
    from lull_staging.orders o
    left join lull_staging.marketing_orders mo on mo.order_id = o.id
    group by o.product_id, mo.marketing_id
    order by product_quantity desc
),
top_marketing_products as (
    select
        marketing_id,
        product_id,
        product_quantity,
        most_recent_sold_date,
        row_number() over (
            partition by marketing_id
            order by product_quantity desc, most_recent_sold_date desc
        ) as product_rank
    from marketing_products
)
select
    t.marketing_id as id,
    m.ad_network,
    m.source,
    p.name as top_product,
    t.product_quantity as top_product_quantity,
    t.most_recent_sold_date as top_most_recent_sold_date    
from top_marketing_products t
left join lull_staging.marketing m on m.id = t.marketing_id
left join lull_staging.products p on p.id = t.product_id
where product_rank = 1;

alter table lull_reports.marketing_orders add  (
    constraint pk_marketing_orders primary key (id),
    constraint fk_marketing_orders_marketing foreign key (id) references lull_staging.marketing(id),
    unique index ix_marketing_orders_ad_network_source (ad_network, source)
);

select * from lull_reports.marketing_orders;

describe lull_reports.marketing_orders;