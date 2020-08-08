--1) RETORNAR A QUANTIDADE DE CLIENTES EM CADA CIDADE ONDE RESIDEM 

select count(cidade) qtd_clientes,
cidade 
from cliente 
join endereco_cliente end_cli on cliente.id_endereco = end_cli.id 
group by cidade;

--2) RETORNAR OS ENDEREÇOS QUE NÃO POSSUEM CLIENTES CADASTRADOS 

select * 
from endereco_cliente 
where id not in (select id from cliente);

--3) RETORNAR OS ENDEREÇOS COMPLETOS DE CLIENTES EM UMA UNICA COLUNA 

select cli.id, 
       nome, 
       cpf,
       carteira,
       sexo,
       data_nascimento,
       'Logradouro: ' || logradouro || ' | Nº: ' || numero ||' | Bairro: ' || bairro ||' | Cidade: ' || cidade || ' | UF: ' || uf || ' | CEP: ' ||  cep  Endereco
from cliente cli
join endereco_cliente end_cli on cli.id_endereco = end_cli.id;

--4) RETORNAR OS CLIENTES QUE NÃO POSSUEM ATENDIMENTO REGISTRADO

select * 
from cliente 
where id not in (select id_cliente 
                 from atendimento
                    union all
                 select id_cliente from atendimentos2);
                 
--5) RETORNAR O VALOR TOTAL DOS ATENDIMENTOS POR DATA DE ATENDIMENTO 

select sum(valor) valor_total,data_atendimento 
from (select * from atendimento
            union all
      select * from atendimentos2)
group by data_atendimento;

--6) TRAZER TODOS OS ENDEREÇOS ONDE A CIDADE NÃO SEJA CARUAR

select * 
from (select to_char(id) id,
            logradouro,
            bairro,
            numero,
            cidade,
            cep,
            uf 
        from endereco_cliente
            union all 
        select id,
            rua
            logradouro, 
            bairro,
            numero, 
            cidade, 
            cep,
            '' uf 
        from endereco_beneficiario) enderecos
where cidade not like 'CARUARU';

--7) TRAZER TODOS OS ATENDIMENTOS COM O NÚMERO DO ATENDIMENTO, DATA DO ATENDIMENTO, NOME DO CLIENTE E NOME DO LOCAL DO ATENDIMENTO. 

select  atendimentos.id num_atendimento,
        atendimentos.data_atendimento,
        cliente.nome cliente,
        local_atendimento.nome local
from (select * from atendimento
         union
      select * from atendimentos2) atendimentos
    join local_atendimento on atendimentos.id_local = local_atendimento.id
    join cliente on atendimentos.id_cliente = cliente.id;
    
    
--8) DE 01/01/2016 ATÉ 31/03/2016 LISTE NOME DISTINTOS DOS CLIENTES QUE TIVERAM ATENDIMENTO. 
 
select distinct nome
from cliente 
    join atendimento on atendimento.id_cliente = cliente.id 
    join atendimentos2 on atendimentos2.id_cliente = cliente.id 
where atendimento.data_atendimento between to_date('01/01/2016','dd/mm/yyyy') and to_date('31/03/2016','dd/mm/yyyy')
      and atendimentos2.data_atendimento between to_date('01/01/2016','dd/mm/yyyy') and to_date('31/03/2016','dd/mm/yyyy');
      
--9) TRAZER O NOME E QUANTIDADE DE ATENDIMENTOS DE CADA CLIENTE NO PERÍODO DE 01/01/2016 ATÉ 10/10/2016 ORDENADOS PELA QUANTIDADE 

select nome,
       count(nome) QTDE_atendimento 
from cliente 
    join atendimento on atendimento.id_cliente = cliente.id 
    join atendimentos2 on atendimentos2.id_cliente = cliente.id 
where atendimento.data_atendimento between to_date('01/01/2016','dd/mm/yyyy') and to_date('10/10/2016','dd/mm/yyyy')
      and atendimentos2.data_atendimento between to_date('01/01/2016','dd/mm/yyyy') and to_date('10/10/2016','dd/mm/yyyy')
group by nome
order by qtde_atendimento


--10) TRAZER OS NOMES, DATA DE ATENDIMENTO E QUANTIDADE DOS CLIENTES QUE POSSUEM MAIS DE UM ATENDIMENTO NO MESMO DIA. 

select cliente.nome,
       atendimentos.data_atendimento,
       count(cliente.nome) QTD_ATENDIMENTO
from (select * from atendimento
        union
      select * from atendimentos2) atendimentos 
    join cliente on atendimentos.id_cliente = cliente.id
having count(nome) > 1
group by nome,
         data_atendimento
order by data_atendimento asc;


--11) TRAZER O NOME E A QUANTIDADE TOTAL DE ATENDIMENTOS POR LOCAL. 

select local_atendimento.nome,
       count(local_atendimento.nome) QTD_TOTAL_ATENDIMENTOS
from(select *
      from atendimento
        union
      select *
      from atendimentos2) atendimentos 
    join local_atendimento on atendimentos.id_local = local_atendimento.id
group by local_atendimento.nome


--12) DE 01/01/2016 ATÉ 31/12/2016 LISTE O CUSTO MÉDIO DOS ATENDIMENTO POR LOCAL DE ATENDIMENTO.

select local_atendimento.nome local,
       avg(valor) custo_medio
from(select *
      from atendimento
        union
      select *
      from atendimentos2) atendimentos 
    join local_atendimento on atendimentos.id_local = local_atendimento.id
where atendimentos.data_atendimento between to_date('01/01/2016','dd/mm/yyyy') and to_date('31/12/2016','dd/mm/yyyy')
group by local_atendimento.nome
order by nome asc;


--13) LISTAR OS PACIENTES QUE FORAM ATENDIDOS EM MAIS DE UM LOCAL ENTRE AS DATAS 01/01/2016 E 10/10/2016, TRAZER NOME DATA DO ATENDIMENTO,
--ENDERECO COMPLETO DO LOCAL E O CUSTO POR LOCAL. 

select cliente.nome,
       local_atendimento.nome,
       atendimentos.data_atendimento,
       endereco_cliente.logradouro,
       endereco_cliente.numero,
       endereco_cliente.bairro,
       endereco_cliente.cidade, 
       endereco_cliente.uf, 
       sum(atendimentos.valor) valor_atendimento
from (select * from atendimento
        union all
      select * from atendimentos2) atendimentos
    join cliente on atendimentos.id_cliente = cliente.id
    join local_atendimento on atendimentos.id_local = local_atendimento.id
    join endereco_cliente on local_atendimento.id_endereco = endereco_cliente.id
where atendimentos.data_atendimento between to_date('01/01/2016','dd/mm/yyyy') and to_date('31/12/2016','dd/mm/yyyy')
      and cliente.id in (select id_cliente 
                         from (select id_cliente,
                                      id_local 
                                from (select * from atendimento
                                        union all 
                                      select * from atendimentos2) atendimentos
                                      group by id_cliente,
                                               id_local)
                         having count(id_cliente) > 1
                         group by id_cliente)
group by cliente.id,
         cliente.nome,
         local_atendimento.nome,
         atendimentos.data_atendimento,
         endereco_cliente.logradouro, 
         endereco_cliente.numero,
         endereco_cliente.bairro,
         endereco_cliente.cidade, 
         endereco_cliente.uf
order by cliente.id asc;

/**14) Trazer todos os atendimentos agrupados por local, com os seguintes campos:
 - Nome do local de atendimento 
 - Data do Atendimento
 - Rank | do menor para o maior (se o atendimento for mais recente, será o 1) **/
 
select nome, 
       data_atendimento,
       rownum rank
from (select local_atendimento.nome,
             atendimentos.data_atendimento
        from(select *
   	     from atendimento
   		union all 
     select * from atendimentos2) atendimentos
join local_atendimento on atendimentos.id_local = local_atendimento.id
group by local_atendimento.nome,
       atendimentos.data_atendimento
order by atendimentos.data_atendimento asc )

/**15) Trazer a quantidade de atendimentos, e o grupo de idade que realizou
 grupos de idade:
 0 - 20
 21 - 50
 51 - 80
 81 acima
 ordenados por grupo ( do menor para o maior ) **/
 
 
select count(grupo_idade) quantidade_atendimento,
       grupo_idade
from
  (select atendimentos.id_cliente,
          data_nascimento,
          trunc((months_between(sysdate, trunc(data_nascimento)))/12) idade,
          case
              when trunc((months_between(sysdate, trunc(data_nascimento)))/12) between 0 and 20 then '0-20'
              when trunc((months_between(sysdate, trunc(data_nascimento)))/12) between 21 and 50 then '21-50'
              when trunc((months_between(sysdate, trunc(data_nascimento)))/12) between 51 and 80 then '51-80'
              when trunc((months_between(sysdate, trunc(data_nascimento)))/12) > 80 then '81 acima'
          end grupo_idade
   from
     (select *
      from atendimento
      union all select *
      from atendimentos2)atendimentos
   join cliente on atendimentos.id_cliente = cliente.id
   order by grupo_idade asc)
group by grupo_idade
order by grupo_idade asc;

 
