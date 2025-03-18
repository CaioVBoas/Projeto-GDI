-- Group by / Having
-- Média das notas de avaliação por professor, retornando só aqueles com média acima de 4.0.
SELECT
    p.nome AS professor,
    AVG(a.nota) AS media_notas
FROM AVALIA a
INNER JOIN PROFESSOR p ON a.fk_professor = p.id_professor
GROUP BY p.nome
HAVING AVG(a.nota) > 4.0;


-- Junção interna
-- Professores e suas cadeiras obrigatórias onde há monitor
SELECT
    p.nome AS professor,
    c.nome AS cadeira,
    co.nome_monitor
FROM PROFESSOR p
INNER JOIN AVALIA a ON p.id_professor = a.fk_professor
INNER JOIN CADEIRA_OBRIGATORIA co
    ON a.fk_universidade = co.fk_universidade
    AND a.fk_cadeira = co.fk_cadeira
INNER JOIN CADEIRA c
    ON co.fk_universidade = c.fk_universidade
    AND co.fk_cadeira = c.id_cadeira
WHERE co.tem_monitor = TRUE;


-- Junção externa
-- Todas as cadeiras da universidade 1, e se são ou não ofertadas como eletiva.
SELECT
    c.nome AS cadeira,
    ce.esta_ofertada
FROM CADEIRA c
LEFT JOIN CADEIRA_ELETIVA ce
    ON c.fk_universidade = ce.fk_universidade
    AND c.id_cadeira = ce.fk_cadeira
WHERE c.fk_universidade = 1;


-- Semi junção
-- Alunos que já avaliaram pelo menos um professor com nota maior que 4.5.
SELECT DISTINCT a.nome
FROM ALUNO a
WHERE EXISTS (
    SELECT 1
    FROM AVALIA av
    WHERE av.fk_aluno = a.id_aluno
    AND av.nota > 4.5
);


-- Anti-junção
-- Professores que nunca receberam avaliação.
SELECT p.nome
FROM PROFESSOR p
WHERE NOT EXISTS (
    SELECT 1
    FROM AVALIA a
    WHERE a.fk_professor = p.id_professor
);


-- Subconsulta do tipo escalar
-- Busca o nome do professor com maior nota média
SELECT nome
FROM PROFESSOR
WHERE nota_media = (
    SELECT MAX(nota_media)
    FROM PROFESSOR
);


-- Subconsulta do tipo linha
-- Retorna o nome e a nota média do professor com a menor média.
SELECT nome, nota_media
FROM PROFESSOR
WHERE (nota_media) = (
    SELECT MIN(nota_media)
    FROM PROFESSOR
);



-- Subconsulta do tipo tabela
-- Professores com nota média maior que a média geral de todos os professores.
SELECT p.*
FROM PROFESSOR p
WHERE p.nota_media > (
    SELECT AVG(nota_media)
    FROM PROFESSOR
);


-- Operação de conjunto
-- Ids dos Alunos que avaliaram professores OU que fizeram comentários.
SELECT fk_aluno AS id_aluno
FROM AVALIA
UNION
SELECT fk_aluno
FROM COMENTARIO;
