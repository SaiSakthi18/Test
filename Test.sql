-- 1) create a temp table to hold numbered notes
IF OBJECT_ID('tempdb..#numbered') IS NOT NULL DROP TABLE #numbered;

CREATE TABLE #numbered (
    itemid INT,
    note  NVARCHAR(MAX),
    note_num INT
);

-- 2) populate it from your existing query, numbering notes by timestamp (chronological)
INSERT INTO #numbered (itemid, note, note_num)
SELECT
    itemid,
    note,
    ROW_NUMBER() OVER (PARTITION BY itemid ORDER BY newts ASC) AS note_num
FROM (
    -- your base query (returns itemid, note, newts)
    SELECT 
        reportevent.itemid,
        persons.uid + ' : ' + reportevent.descr AS note,
        reportevent.newts
    FROM reportevent
    INNER JOIN persons 
        ON reportevent.newby = persons.userid
    WHERE reportevent.itemid IN (1, 2, 3)
      AND reportevent.undooper IS NULL
) AS base_data;

-- 3) build the IN-list for PIVOT (e.g. [1],[2],[3],...) using FOR XML PATH
DECLARE @colsNums NVARCHAR(MAX), @colsSelect NVARCHAR(MAX), @query NVARCHAR(MAX);

SELECT @colsNums = STUFF((
    SELECT DISTINCT ',' + QUOTENAME(note_num)
    FROM #numbered
    ORDER BY 1
    FOR XML PATH(''), TYPE
).value('.','NVARCHAR(MAX)'), 1, 1, '');

-- 4) build the select-list that aliases [1] AS note1, [2] AS note2, ...
SELECT @colsSelect = STUFF((
    SELECT DISTINCT ', ' + QUOTENAME(note_num) + ' AS ' + QUOTENAME('note' + CAST(note_num AS VARCHAR(10)))
    FROM #numbered
    ORDER BY 1
    FOR XML PATH(''), TYPE
).value('.','NVARCHAR(MAX)'), 1, 2, '');

-- 5) construct and execute dynamic pivot query
SET @query = '
SELECT itemid, ' + @colsSelect + '
FROM #numbered
PIVOT (
    MAX(note) FOR note_num IN (' + @colsNums + ')
) AS p
ORDER BY itemid;
';

EXEC sp_executesql @query;

-- (optional) clean up
DROP TABLE #numbered;
