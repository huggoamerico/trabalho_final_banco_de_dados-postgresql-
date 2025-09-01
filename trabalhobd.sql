--criando tabelas--
CREATE TABLE paciente (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    endereco VARCHAR(200) NOT NULL
);

CREATE TABLE dentista (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    cro VARCHAR(20) UNIQUE NOT NULL,
    especialidade VARCHAR(100) NOT NULL
);

CREATE TABLE horario_dentista (
    id SERIAL PRIMARY KEY,
    id_dentista INT NOT NULL REFERENCES dentista(id),
    dia_semana VARCHAR(20) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL
);
CREATE TABLE procedimento_od (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    duracao_media INT NOT NULL
);
CREATE TABLE consulta (
    id SERIAL PRIMARY KEY,
    id_paciente INT NOT NULL REFERENCES paciente(id),
    id_dentista INT NOT NULL REFERENCES dentista(id),
    data DATE NOT NULL,
    hora TIME NOT NULL,
    descricao TEXT,
    prescricao TEXT
);

CREATE TABLE consulta_procedimento (
    id SERIAL PRIMARY KEY,
    id_consulta INT NOT NULL REFERENCES consulta(id),
    id_procedimento INT NOT NULL REFERENCES procedimento_od(id)
);
--fim das tabelas--


--consulta por especialidade--
SELECT d.especialidade, COUNT(c.id) AS total_consultas
FROM dentista d
LEFT JOIN consulta c ON d.id = c.id_dentista
GROUP BY d.especialidade;
--fim da consulta por especialidade--

--consulta por dentistas--
select d.nome, count(c.id) as consultas_dentistas
from dentista d
left join consulta c on d.id = c.id_dentista 
group by d.nome 
order by consultas_dentistas desc ;

--consulta por pacientes--
select p.nome , count (c.id) as consultas_clientes
from paciente p 
left join consulta c on p.id = c.id_paciente
group by p.nome
order by consultas_clientes desc ;

--view da data-- 
CREATE VIEW vw_consultas_ordenadas AS
SELECT 
    c.id AS id_consulta,
    p.nome AS nome_paciente,
    d.nome AS nome_dentista,
    c.data AS data_consulta,
    c.hora AS hora_consulta,
    c.descricao AS descricao,
    c.prescricao AS prescricao
FROM consulta c
JOIN paciente p ON c.id_paciente = p.id
JOIN dentista d ON c.id_dentista = d.id
ORDER BY c.data DESC, c.hora DESC;

SELECT * FROM vw_consultas_ordenadas;
--fim view data--

--media dentistas--
SELECT AVG(contagem) AS media_consultas
FROM (
    SELECT COUNT(*) AS contagem
    FROM consulta
    GROUP BY id_dentista
) AS t;

--indices--
CREATE INDEX idx_paciente_cpf ON paciente(cpf);
SELECT * FROM paciente WHERE cpf = '88888888888';

create index idx_especialidade on dentista(especialidade);
select * from dentista where especialidade = 'Ortodontia';


--inserts--
select * from paciente;
    select * from dentista;
    select * from consulta;
    select * from procedimento_od;
	select * from horario_dentista; 


INSERT INTO paciente (nome, cpf, data_nascimento, telefone, email, endereco) VALUES
('Ana Silva', '11111111111', '1990-01-01', '11999999901', 'ana@email.com', 'Rua A, 10'),
('Bruno Souza', '22222222222', '1985-02-15', '11999999902', 'bruno@email.com', 'Rua B, 20'),
('Carlos Lima', '33333333333', '1978-03-20', '11999999903', 'carlos@email.com', 'Rua C, 30'),
('Daniela Costa', '44444444444', '1992-04-10', '11999999904', 'daniela@email.com', 'Rua D, 40'),
('Eduardo Gomes', '55555555555', '1995-05-05', '11999999905', 'eduardo@email.com', 'Rua E, 50'),
('Fernanda Alves', '66666666666', '1989-06-25', '11999999906', 'fernanda@email.com', 'Rua F, 60'),
('Gabriel Martins', '77777777777', '1980-07-30', '11999999907', 'gabriel@email.com', 'Rua G, 70'),
('Helena Rocha', '88888888888', '2000-08-12', '11999999908', 'helena@email.com', 'Rua H, 80'),
('Igor Ferreira', '99999999999', '1993-09-09', '11999999909', 'igor@email.com', 'Rua I, 90'),
('Julia Mendes', '10101010101', '1998-10-18', '11999999910', 'julia@email.com', 'Rua J, 100');

insert into paciente (nome, cpf, data_nascimento, telefone, email, endereco)values
('Hugo', '16926401782', '2005-02-22', '219845799901', 'hugosamerico@gmail.com', 'Rua Walci, 133'),
('Rodrigo Guloso', '24242424242', '2004-02-24', '24969899802', 'rodrigoguloso@gmail.com', 'Rua B, 24');


INSERT INTO dentista (nome, cpf, cro, especialidade) VALUES
('Dr. Marcos Pinto', '09274526718', 'CRO1334', 'Ortodontia'),
('Dra. Laura Ramos', '13121313131', 'CRO2345', 'Endodontia'),
('Dr. Pedro Henrique', '14141414141', 'CRO3456', 'Implantodontia'),
('Dra. Camila Torres', '15151515151', 'CRO4567', 'Clínico Geral'),
('Dr. Thiago Moreira', '16161616161', 'CRO5678', 'Periodontia'),
('Dra. Patrícia Nunes', '17171717171', 'CRO6789', 'Odontopediatria'),
('Dr. Renato Lopes', '18181818181', 'CRO7890', 'Ortodontia'),
('Dra. Luana Carvalho', '19191919191', 'CRO8901', 'Clínico Geral'),
('Dr. Felipe Andrade', '20202020202', 'CRO9012', 'Endodontia'),
('Dra. Rafaela Monteiro', '21212121212', 'CRO0123', 'Implantodontia');

INSERT INTO horario_dentista (id_dentista, dia_semana, hora_inicio, hora_fim) VALUES
(1, 'Segunda', '08:00', '12:00'),
(2, 'Terça', '13:00', '17:00'),
(3, 'Quarta', '08:00', '12:00'),
(4, 'Quinta', '13:00', '17:00'),
(5, 'Sexta', '08:00', '12:00'),
(6, 'Segunda', '13:00', '17:00'),
(7, 'Terça', '08:00', '12:00'),
(8, 'Quarta', '13:00', '17:00'),
(9, 'Quinta', '08:00', '12:00'),
(10, 'Sexta', '13:00', '17:00');

INSERT INTO procedimento_od (nome, descricao, duracao_media) VALUES
('Limpeza', 'Higienização geral', 30),
('Canal', 'Tratamento de canal', 65),
('Extração', 'Remoção de dente', 60),
('Clareamento', 'Clareamento dental', 15),
('Implante', 'Implante dentário', 75),
('Restauração', 'Restauração de cáries', 40),
('Ortodontia', 'Ajustes ortodônticos', 20),
('Periodontia', 'Tratamento de gengiva', 25),
('Avaliação', 'Consulta inicial', 30),
('Raio-x', 'Exame radiográfico', 25);

INSERT INTO consulta (id_paciente, id_dentista, data, hora, descricao, prescricao) VALUES
(1, 1, '2025-09-01', '09:00', 'Consulta inicial', 'Nenhuma'),
(1, 2, '2025-09-02', '15:00', 'Canal no dente 36', 'Antibiótico'),
(3, 3, '2025-09-03', '10:00', 'Implante pré-molar', 'Analgésico'),
(4, 4, '2025-09-04', '11:00', 'Limpeza geral', 'Nenhuma'),
(5, 5, '2025-09-05', '13:30', 'Tratamento gengival', 'Enxaguante'),
(6, 6, '2025-09-08', '14:00', 'Odontopediatria revisão', 'Nenhuma'),
(7, 7, '2025-09-09', '09:00', 'Ajuste aparelho', 'Nenhuma'),
(8, 8, '2025-09-10', '16:00', 'Clareamento', 'Nenhuma'),
(9, 9, '2025-09-11', '10:00', 'Canal incisivo', 'Antibiótico'),
(10, 10, '2025-09-12', '15:00', 'Implante molar', 'Analgésico');

INSERT INTO consulta_procedimento (id_consulta, id_procedimento) VALUES
(1, 9), (2, 3), (3, 6), (4, 1), (5, 5),
(6, 10), (7, 7), (8, 5), (9, 3), (10, 6);

--updates--
UPDATE paciente SET nome = 'Rodrigo Da Silva Guloso' WHERE id = 12;
UPDATE dentista SET especialidade = 'Ortodontia' WHERE id = 2;
UPDATE paciente SET telefone = '21984379627' WHERE id = 2
;
--fim updates--

-- Excluindo uma consulta específica
DELETE FROM horario_dentista WHERE id = 4;
DELETE FROM paciente WHERE id = 5;
DELETE FROM dentista WHERE id = 6;

select * from paciente




