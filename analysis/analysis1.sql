/*  
 * How loyal are our clients to the products they've bought?
 */


/* summary */
select  
	o.order_id
	,o.customer_id 
	,o.order_date 
	,op.product_id 
from orders o
join order_positions op on o.order_id = op.order_id 


/* */
with
base_data as 
	(
	select  
		o.order_id
		,o.customer_id 
		,o.order_date 
		,op.product_id 
	from orders o
	join order_positions op on o.order_id = op.order_id 
	),
order_numbers as 
	(
	select
		customer_id
		,count(distinct order_id) as orders_total
	from orders
	group by 1
	)
select
	product_id
	,avg(loyalty_rate) 			as average_loyalty_rate
	,sum(orders_per_product)	as orders_per_product
from
	(
	select 
		bd.customer_id
		,bd.product_id
		,orn.orders_total				as orders_per_customer
		,count(distinct bd.order_id) 	as orders_per_product
		,max(bd.order_date)				as last_order_for_this_product
		,min(bd.order_date)				as first_order_for_this_product
		,count(distinct bd.order_id)/orn.orders_total	as loyalty_rate
	from base_data bd
	inner join order_numbers orn on orn.customer_id = bd.customer_id
	group by 1, 2, 3
	having count(distinct bd.order_id) > 1
	order by 3 desc
	) analysis
	group by 1
	order by 2 desc
 
