순위  시도  시군구 도시발전지수  kfc건수   맥도날드    버거킹     롯데리아
1   서울시 서초구     4.5         3       4         5         6
2   서울시 강남구     4.3
3   부산시 해운대구    4.1

서울시 서초구 kfc     6
서울시 서초구 맥도날드  5

SELECT *
FROM fastfood;

SELECT  sido, sigungu, gb 
FROM fastfood
WHERE gb = '롯데리아'
AND sigungu = '강릉시'
ORDER BY sido, sigungu, gb;

SELECT  sido, sigungu, gb , COUNT(*) cnt
FROM fastfood 
WHERE gb = '롯데리아'
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;


SELECT  sido, sigungu, gb , COUNT(*) cnt
FROM fastfood 
WHERE gb = 'KFC'
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;


SELECT  sido, sigungu, gb , COUNT(*) cnt
FROM fastfood 
WHERE gb = '맥도날드'
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;

SELECT  sido, sigungu, gb , COUNT(*) cnt
FROM fastfood 
WHERE gb = '맥도날드'
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;


--------------
SELECT  a.sido, a.sigungu , a.cnt, b.cnt, a,cnt/b.cnt di
(SELECT 
COUNT(*) cnt
FROM fastfood 
WHERE gb IN ( '버거킹', 'KFC', '버거킹' )
GROUP BY sido, sigungu
ORDER BY sido, sigungu a;

(SELECT  sido, sigungu , COUNT(*) cnt
FROM fastfood 
WHERE gb = '롯데리아'
GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu;
-------------------

SELECT  sido, sigungu, gb , COUNT(*) cnt
FROM fastfood 
WHERE gb = '버거킹'
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;




SELECT  sido, sigungu, d.gb, d.COUNT(*), f.gb, f.COUNT(*)
FROM fastfood f, fastfood d
WHERE f.sido = d.sido 
AND d.gb = '맥도날드'
OR f.gb = '롯데리아'
GROUP BY sido, sigungu;

SELECT  f.sido, f.sigungu, d.gb, f.gb
FROM fastfood f, fastfood d
WHERE f.sido = d.sido (SELECT gb
                        FROM fastfood
                        WHERE gb IN ('맥도날드', '롯데리아'));


AND d.gb = '맥도날드'
OR f.gb = '롯데리아'
GROUP BY sido, sigungu;

SELECT gb, sido, sigungu
FROM fastfood
WHERE SIDO = '대전광역시'
    AND sigungu = '중구';
    
    
SELECT a.sido, a.sigungu, a.cnt, b.cnt, ROUND(a.cnt/b.cnt, 2) di
FROM
(SELECT sido, sigungu, COUNT(*) cnt
 FROM fastfood
 WHERE gb IN ( 'KFC', '맥도날드', '버거킹')
 GROUP BY sido, sigungu) a,

(SELECT sido, sigungu, COUNT(*) cnt
 FROM fastfood
 WHERE gb = '롯데리아'
 GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY di DESC;

 kfc 건수, 롯데리아 건수, 버거킹 건수, 맥도날드 건수
 
SELECT sido, sigungu, 
ROUND(NVL(SUM(DECODE(gb, 'KFC', cnt)), 0)  +
NVL(SUM(DECODE(gb, '버거킹', cnt)), 0)  +
NVL(SUM(DECODE(gb, '맥도날드', cnt)), 0)  / 
NVL(SUM(DECODE(gb, '롯데리아', cnt)), 1)) di
FROM 
(SELECT sido, sigungu, gb, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('KFC', '롯데리아', '버거킹', '맥도날드')
GROUP BY sido, sigungu, gb)
GROUP BY sido, sigungu
ORDER BY di DESC;



SELECT *
FROM tax;

도시발전지수 1 - 세금 1위
도시발전지수 2 - 세금 2위
도시발전지수 3 - 세금 3위

SELECT sido , sigungu, ROUND(sal/people) p_sal
FROM tax
ORDER BY p_sal DESC;








