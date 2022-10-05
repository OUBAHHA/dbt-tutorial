select 
{{ dbt_utils.surrogate_key(['o.orderid', 'c.customerid', 'p.productid'])}} as sk_orders,
-- from raw_orders
o.orderid,
o.orderdate,
o.shipdate,
o.shipmode, 
o.ordersellingprice - o.ordercostprice as orderprofit,
o.ordersellingprice,
o.ordercostprice, 
-- from raw_customer
c.customername,
c.segment,
c.country,
c.customerid,
-- from raw_product
p.category,
p.productname,
p.subcategory,
p.productid,
{{ markup('ordersellingprice', 'ordercostprice')}} as markup,
d.delivery_team
from {{ ref('raw_order') }} as o
left join {{ ref('raw_customer') }} as c 
on o.customerid = c.customerid
left join {{ ref('raw_product') }} as p
on o.productid = p.productid
left join {{ ref('delivery_team') }} as d
on o.shipmode = d.shipmode