create schema lull_staging;
create schema lull_reports;

use lull_staging;

create table products (
    id int not null,
    name varchar(10) not null,
    description varchar(100),
    go_live_date date,
    created_at datetime,
    updated_at datetime,
    constraint pk_products primary key (id),
    constraint uc_products_name unique (name)
);

create table marketing (
    id int not null,
    ad_network varchar(10) not null,
    source varchar(15) not null,
    created_at datetime,
    updated_at datetime,
    constraint pk_marketing primary key (id),
    constraint uc_marketing unique (ad_network, source)
);

create table orders (
    id int not null,
    product_id int not null,
    ordered_at datetime,
    product_quantity int, # spec defines as string, but should probably be numeric
    created_at datetime,
    updated_at datetime,
    constraint pk_orders primary key (id),
    constraint fk_orders_product foreign key (product_id) references products(id)
);
 
 create table marketing_orders (
    order_id int not null,
    marketing_id int not null,
    constraint pk_marketing_orders primary key (order_id, marketing_id),
    constraint fk_marketing_orders_orders foreign key (order_id) references orders(id),
    constraint fk_marketing_orders_marketing foreign key (marketing_id) references marketing(id)
 );