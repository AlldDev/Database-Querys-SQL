TRABALHO: Banco de Dados Final (SQLs QUERY REVISÃO)
	
#---------------------------------------------
# CRIANDO O BANCO DE DADOS
#---------------------------------------------

create database db_oficina_do_tiao;

#---------------------------------------------
# CRIANDO AS TABELAS
#---------------------------------------------

create table cliente(
	cliente_id int primary key not null,
    cliente_nome varchar(100),
    cliente_cpf_cnpj int(14),
    cliente_telefone int
);

create table produto(
	produto_id int primary key not null,
    produto_descricao varchar(250),
    produto_valor_unit float,
    produto_quant_estoque int,
    produto_marca varchar(15)
);

create table orcamento(
	orcam_id int primary key not null,
    orcam_idveic int not null, # FOREGEIN KEY de veiculo
    orcam_data date,
    orcam_valor float
);

create table prod_orcam(
	prod_orcam_id int primary key not null,
    prod_orcam_idorcam int not null, # FOREIGN KEY de orcamento
    prod_orcam_idprod int not null, # FOREIGN KEY de produto
    prod_orcam_quant int,
    prod_orcam_valor float
);

create table veiculo(
	veiculo_id int primary key not null,
    veiculo_tipo char(1),
    veiculo_idcliente int not null, # FOREIGN KEY de cliente
    veiculo_placa varchar(8),
    veiculo_marca varchar(15),
    veiculo_cor varchar(15),
    veiculo_chassi varchar(25)
);

create table agenda(
	agenda_id int primary key not null,
    agenda_idvec int not null, # FOREIGN KEY de veiculo
    agenda_data date,
    agenda_atendido char(1) # 0 para não atendido e 1 para atendido
);

create table revisao(
	revisao_id int primary key not null,
    revisao_idvec int not null, # FOREIGN KEY de veiculo
    revisao_data date,
    revisao_realizada varchar(10),
    revisao_tipo varchar(20)
);

#-----------------------------------------
# ADICIONANDO AS CHAVES ESTRANGEIRAS
#-----------------------------------------

alter table orcamento
add constraint FK_orcam_vec foreign key(orcam_idveic) references veiculo(veiculo_id);

alter table prod_orcam
add constraint FK_prod_orcam foreign key(prod_orcam_idorcam) references orcamento(orcam_id);

alter table prod_orcam
add constraint FK_prod_id foreign key(prod_orcam_idprod) references produto(produto_id);

alter table veiculo
add constraint FK_veiculo foreign key(veiculo_idcliente) references cliente(cliente_id);

alter table agenda
add constraint FK_agenda foreign key(agenda_idvec) references veiculo(veiculo_id);

alter table revisao
add constraint FK_revisao foreign key(revisao_idvec) references veiculo(veiculo_id);

#------------------------------------------
# CRIANDO VIEWS DE TODAS AS TABELAS
#------------------------------------------

create view view_cliente as
select * from cliente;

create view view_produto as
select * from produto;

create view view_orcamento as
select * from orcamento;

create view view_prod_orcam as
select * from prod_orcam;

create view view_veiculo as
select * from veiculo;

create view view_agenda as
select * from agenda;

create view view_revisao as
select * from revisao;

#---------------------------------
# FAZENDO SELECTS
#---------------------------------

select * from agenda
where agenda_data between '2023/11/01' and '2023/11/31';

create view view_epoca_revisao as
select * from agenda
where agenda_data between '2023/11/01' and '2023/11/31';

select * from produto as p
inner join prod_orcam as prod on prod.prod_orcam_idprod = p.produto_id
inner join orcamento as orc on orc.orcam_id = prod.prod_orcam_idorcam
where orc.orcam_id = 1;

select * from veiculo as v
inner join cliente as c on c.cliente_id = v.veiculo_idcliente
where c.cliente_nome = "Alessandro";

create view prev_agendamento as
select * from agenda as a
inner join veiculo as v on v.veiculo_id  = a.agenda_idvec
where a.agenda_atendido = 0
group by v.veiculo_marca

create view desc_valor_por_marcas as
select sum(o.orcam_valor) from orcamento as o
inner join veiculo as v on v.veiculo_id = o.orcam_idveic
group by v.veiculo_marca desc;
