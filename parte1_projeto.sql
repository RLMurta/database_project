-- Criando as tabelas (DDL)

create table cliente(
	id serial primary key not null,
	nome varchar(255) not null,
	cpf varchar(11) not null,
	data_nasc timestamp,
	email varchar(255),
	telefone varchar(20)
)

create table reserva(
	id serial primary key not null,
	timestamp timestamp not null,
	cliente_id integer not null,
	foreign key(cliente_id) references cliente(id) 
)

create table mesa(
	id serial primary key not null,
	numero integer not null,
	capacidade integer not null
)

create table reserva_mesa(
	id serial primary key not null,
	reserva_id integer not null,
	mesa_id integer not null,
	foreign key(reserva_id) references reserva(id),
	foreign key(mesa_id) references mesa(id) 
)

create table pedido(
	id serial primary key not null,
	timestamp timestamp not null,
	mesa_id integer not null,
	cliente_id integer not null,
	foreign key(mesa_id) references mesa(id),
	foreign key(cliente_id) references cliente(id)
)

create table prato(
	id serial primary key not null,
	nome varchar(255) not null,
	preco float not null,
	descricao varchar(255)
)

create table prato_pedido(
	id serial primary key not null,
	prato_id integer not null,
	pedido_id integer not null,
	foreign key(prato_id) references prato(id),
	foreign key(pedido_id) references pedido(id)
)

create table cargo(
	id serial primary key not null,
	nome varchar(255) not null,
	descricao varchar(255)
)

create table funcionario(
	id serial primary key not null,
	nome varchar(255) not null,
	cpf varchar(11) not null,
	telefone varchar(20) not null,
	cargo_id integer not null,
	foreign key(cargo_id) references cargo(id)
)

create table funcionario_pedido(
	id serial primary key not null,
	funcionario_id integer not null,
	pedido_id integer not null,
	foreign key(funcionario_id) references funcionario(id),
	foreign key(pedido_id) references pedido(id)
)

-- Inserindo dados nas tabelas (DML)

INSERT INTO cliente (nome, cpf, data_nasc, email, telefone) VALUES 
('João Silva', '12345678901', '1980-05-10', 'joao.silva@email.com', '(11) 91234-5678'),
('Maria Oliveira', '23456789012', '1992-03-22', 'maria.oliveira@email.com', '(21) 92345-6789'),
('Carlos Souza', '34567890123', '1985-07-15', 'carlos.souza@email.com', '(31) 93456-7890'),
('Ana Costa', '45678901234', '1990-10-05', 'ana.costa@email.com', '(41) 94567-8901'),
('Fernanda Lima', '56789012345', '1988-12-01', 'fernanda.lima@email.com', '(51) 95678-9012');

INSERT INTO reserva (timestamp, cliente_id) VALUES 
('2024-09-25 18:30:00', 1),
('2024-09-25 20:00:00', 2),
('2024-09-27 19:45:00', 3),
('2024-09-27 21:15:00', 4),
('2024-09-27 18:00:00', 5);

INSERT INTO mesa (numero, capacidade) VALUES 
(1, 4),
(2, 6),
(3, 2),
(4, 8),
(5, 4);

INSERT INTO reserva_mesa (reserva_id, mesa_id) VALUES 
(1, 1),
(2, 2),
(3, 1),
(4, 4),
(5, 5);

INSERT INTO pedido (timestamp, mesa_id, cliente_id) VALUES 
('2024-09-25 19:00:00', 1, 1),
('2024-09-26 20:30:00', 2, 2),
('2024-09-27 20:00:00', 1, 3),
('2024-09-28 21:30:00', 4, 4),
('2024-09-29 18:30:00', 5, 5);

INSERT INTO prato (nome, preco, descricao) VALUES 
('Spaghetti Carbonara', 45.90, 'Massa italiana com bacon e molho carbonara'),
('Frango à Parmegiana', 38.50, 'Filé de frango empanado com molho de tomate e queijo'),
('Salmão Grelhado', 62.00, 'Salmão grelhado com legumes ao vapor'),
('Pizza Margherita', 32.00, 'Pizza tradicional de tomate, manjericão e queijo'),
('Churrasco Misto', 70.00, 'Carnes variadas grelhadas');

INSERT INTO prato_pedido (prato_id, pedido_id) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO cargo (nome, descricao) VALUES 
('Garçom', 'Atendimento ao cliente e entrega de pedidos'),
('Cozinheiro', 'Preparação dos pratos'),
('Gerente', 'Gerenciamento geral do restaurante'),
('Auxiliar de Cozinha', 'Apoio na preparação de pratos'),
('Caixa', 'Recebimento de pagamentos e fechamento de contas');

INSERT INTO funcionario (nome, cpf, telefone, cargo_id) VALUES 
('Pedro Ferreira', '67890123456', '(11) 91234-5678', 1),
('Lucas Almeida', '78901234567', '(21) 92345-6789', 2),
('Sofia Ribeiro', '89012345678', '(31) 93456-7890', 3),
('Julia Santos', '90123456789', '(41) 94567-8901', 4),
('Rafael Mendes', '01234567890', '(51) 95678-9012', 5);

INSERT INTO funcionario_pedido (funcionario_id, pedido_id) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);


-- Editando dados nas tabelas (DML)

UPDATE cliente 
SET nome = 'João Pedro Silva' 
WHERE id = 1;

UPDATE prato 
SET preco = 48.90 
WHERE id = 1;

delete from prato_pedido
where pedido_id = 
	(select id from pedido
	where cliente_id = 1);

delete from funcionario_pedido
where pedido_id = 
	(select id from pedido
	where cliente_id = 1);

delete from pedido
where cliente_id = 1;

delete from reserva_mesa
where reserva_id =
	(select id from reserva
	where cliente_id = 1);

DELETE FROM reserva
WHERE cliente_id = 1;

DELETE FROM cliente
WHERE id = 1;

-- Consultando dados (DQL)

-- Seleciona todos os pedidos feitos e as pessoas que o fizeram
select c.nome, p.nome as pedido, p.preco
from cliente c 
inner join pedido pd on c.id = pd.cliente_id
inner join prato_pedido pp on pd.id = pp.pedido_id
inner join prato p on pp.prato_id = p.id;

-- Seleciona todas as reservas, quem as fez e seu horario
select c.nome, r.timestamp as data_e_horario_da_reserva, m.numero as numero_da_mesa, m.capacidade
from cliente c
inner join reserva r on c.id = r.cliente_id 
inner join reserva_mesa rm on r.id = rm.reserva_id 
inner join mesa m on rm.mesa_id = m.id;

-- Seleciona todos os pratos, quando foram feitos, os funcionarios responsáveis por eles e seus cargos
select p.nome, pd.timestamp, f.nome, c.nome
from prato p
inner join prato_pedido pp on p.id = pp.prato_id 
inner join pedido pd on pp.pedido_id = pd.id 
inner join funcionario_pedido fp on pd.id = fp.pedido_id 
inner join funcionario f on fp.funcionario_id = f.id 
inner join cargo c on f.cargo_id = c.id;

-- Seleciona os clientes e seu total de pedidos
select c.nome as nome_cliente, count(p.id) as total_pedidos
from cliente c
left join pedido p on c.id = p.cliente_id
group by c.nome
order by total_pedidos desc;


