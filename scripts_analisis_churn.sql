-- valores nulos o datos extraños
SELECT 
    `Customer ID`, 
    `Tenure in Months`, 
    `Monthly Charge`, 
    `Total Charges`
FROM clientes
WHERE `Total Charges` IS NULL 
   OR `Total Charges` = 0 
   OR `Total Charges` = ' ';
   
SELECT 
    COUNT(*) AS total_registros, 
    -- Verificamos si el ID es nulo
    SUM(CASE WHEN `Customer ID` IS NULL THEN 1 ELSE 0 END) AS nulos_id, 
    -- Verificamos la etiqueta de abandono (Si se fue o no)
    SUM(CASE WHEN `Churn Label` IS NULL THEN 1 ELSE 0 END) AS nulos_churn, 
    -- Verificamos el contrato
    SUM(CASE WHEN `Contract` IS NULL THEN 1 ELSE 0 END) AS nulos_contrato
FROM clientes;

-- Clientes Duplicados
SELECT 
    `Customer ID`, 
    COUNT(*) AS cantidad_repeticiones
FROM clientes
GROUP BY `Customer ID`
HAVING COUNT(*) > 1;

-- ¿Cuál es nuestra tasa de pérdida de clientes?
SELECT 
    `Churn Label`, 
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clientes), 2) AS porcentaje
FROM clientes
GROUP BY `Churn Label`;

-- ¿El tipo de contrato influye en que se vayan?
SELECT 
    `Contract`,
    COUNT(*) AS total_clientes,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS clientes_perdidos,
    ROUND(SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS tasa_churn_por_contrato
FROM clientes
GROUP BY `Contract`
ORDER BY tasa_churn_por_contrato DESC;

-- ¿Cuál es el motivo principal por el que abandonan?
SELECT 
    `Churn Category`,
    COUNT(*) AS total_bajas,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clientes WHERE `Churn Label` = 'Yes'), 2) AS porcentaje_del_total_bajas
FROM clientes
WHERE `Churn Label` = 'Yes'
GROUP BY `Churn Category`
ORDER BY total_bajas DESC;
