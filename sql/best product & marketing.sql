use lull;

# the best-selling product and most successful marketing source in the month of January 2021
with orders_filtered as (
    # orders filtered by year & month in one place to reuse multiple times below
    select
        id,
        product_id,
        product_quantity
    from orders
    where year(ordered_at) = 2021 and month(ordered_at) = 1
),
best_product as (
    select 
        product_id,
        sum(product_quantity) as sold
    from orders_filtered
    group by product_id
    order by sold desc
    limit 1
), 
best_marketing as(
    select 
        mo.marketing_id,
        sum(product_quantity) as sold
    from orders_filtered o
    join marketing_orders mo on mo.order_id = o.id
    group by mo.marketing_id
    order by sold desc
    limit 1
)
select
    p.name as product_name,
    bp.sold as quantity_sold,
    m.ad_network as marketing_ad_network,
    m.source as marketing_source
from best_product bp
cross join best_marketing bm 
join products p on p.id = bp.product_id
join marketing m on m.id = bm.marketing_id
