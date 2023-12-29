/*

PROJECT: STORE P&L ANALYSIS OF A PHARMACY CHAIN
Last update: 30-11-2023
Objective: extract data for visualization

*/

select [Month end], Year, Month, [Store Code], [Area/ Region], [Cities/ Province], [NET_Revenue after extra care]
from Pharmacity..[raw 2019-2022]
inner join Pharmacity..[Store data]
on [raw 2019-2022].[Store Code] = [Store data].[Store ID]
order by 1

select *
from Pharmacity..[Sep 2022]
inner join Pharmacity..[Store data]
on [Sep 2022].[Store Code] = [Store data].[Store ID]
