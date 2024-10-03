-- Quais são os filmes (film.title), suas respectivas categorias (category.name) e idioma (language.name)?
select f.title, c.name as category, l.name as language
from film f
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
inner join "language" l on f.language_id = l.language_id;


-- Quais foram os filmes alugados entre os dias 1 de fevereiro e 15 de março de 2006 na loja 1 (store.id = 1).
select f.title, f.film_id
from film f 
inner join inventory i on f.film_id = i.film_id 
inner join rental r on i.inventory_id = r.inventory_id
inner join staff s on r.staff_id = s.staff_id 
inner join store str on s.store_id = str.store_id 
where (date(r.rental_date) between '2006-01-01' and '2006-03-15') 
and str.store_id = 1;

-- Quais são os 5 filmes mais alugados?
select f.title, count(r.rental_id) as total_alugueis
from film f 
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
group by f.title
order by total_alugueis desc limit 5;

-- Qual a quantidade de vezes que cada filme foi alugado?
select f.title, count(r.rental_id) as total_alugueis
from film f 
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
group by f.title
order by total_alugueis desc;

-- Para cada funcionário (staff.staff_id), qual é o valor total retornado em locações (payment.amount) e 
-- qual é a quantidade total de locações (rental.rental_id)?
select s.first_name || ' ' || s.last_name as nome, sum(p.amount) as valor_total_locacoes, count(r.rental_id) as quantidade_locacoes
from staff s
inner join payment p on s.staff_id = p.staff_id 
inner join rental r on p.rental_id = r.rental_id
group by nome;

-- Qual é o nome de categoria de filme (category.name) que nos retorna mais dinheiro no total (payment.total)?
-- Ordene sua consulta para mostrar o resultado em ordem de lucratividade, do nome de categoria mais lucrativo 
-- para o nome de categoria menos lucrativo e garanta que todos os nomes de categorias apareçam no resultado final, 
-- inclusive aquelas que não tiverem nenhuma locação associada a elas.
select c.name, coalesce(sum(p.amount), 0) as valor_total_locacoes
from category c
left join film_category fc on c.category_id = fc.category_id 
left join film f on fc.film_id = f.film_id 
left join inventory i on f.film_id = i.film_id 
left join rental r on i.inventory_id = r.inventory_id 
left join payment p on r.rental_id = p.rental_id
group by c.name
order by valor_total_locacoes desc;


