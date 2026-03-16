-- 1. Busqué el reporte del crimen en la fecha y ciudad indicadas.
-- Descubrí que -- Descubrí que: Hay dos testigos. El primero vive en la última casa 
-- de Northwestern Dr. El segundo se llama Annabel y vive en Franklin Ave.
SELECT * FROM crime_scene_report 
WHERE date = 20180115 AND city = 'SQL City' AND type = 'murder';

-- 2. Busqué al primer testigo que vive en la última casa de Northwestern Dr.
-- Descubrí que: Se llama Morty Schapiro, ID 14887
SELECT * FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;

-- 3. Busqué al segundo testigo que se llama Annabel y vive en Franklin Ave.
-- Descubrí que: Se llama Annabel Miller, ID 16371
SELECT * FROM person
WHERE address_street_name = 'Franklin Ave' AND name LIKE 'Annabel%';

-- Entrevista del testigo 1
-- Dijo: Escuché un disparo y luego vi a un hombre salir corriendo. 
-- Llevaba una bolsa del gimnasio "Get Fit Now". El número de socio en la bolsa comenzaba con "48Z". Solo los socios Gold tienen esas bolsas. El hombre se subió a un coche con una matrícula que incluía "H42W".
SELECT * 
FROM interview 
WHERE person_id = 14887;

-- Entrevista del testigo 2
-- Dijo: Presencié el asesinato y reconocí al asesino del gimnasio donde entrenaba la semana pasada, el 9 de enero.
SELECT * 
FROM interview 
WHERE person_id = 16371;

-- 5. Busqué miembros Gold del gimnasio cuyo ID empiece con 48Z.
-- Descubrí que: Hay 2 sospechosos posibles:
-- - Joe Germuska (person_id: 28819, gym_id: 48Z7A)
-- - Jeremy Bowers (person_id: 67318, gym_id: 48Z55)
SELECT * 
FROM get_fit_now_member 
WHERE id LIKE '48Z%' 
AND membership_status = 'gold';

-- 6. Verifiqué quién con ID 48Z estuvo en el gimnasio el 9 de enero.
-- Descubrí que: AMBOS sospechosos estuvieron ese día:
-- - 48Z7A (Joe Germuska): 16:00-17:30
-- - 48Z55 (Jeremy Bowers): 15:30-17:00
SELECT * 
FROM get_fit_now_check_in 
WHERE check_in_date = 20180109 
AND (membership_id = '48Z7A' OR membership_id = '48Z55');

-- 7. Busqué licencias de conducir con placa que contenga H42W.
-- Descubrí que: Hay 3 personas con placas similares:
-- - ID 183779: Mujer, 21 años, Toyota Prius (H42W0X)
-- - ID 423327: Hombre, 30 años, Chevrolet Spark LS (0H42W2)  
-- - ID 664760: Hombre, 21 años, Nissan Altima (4H42WR)
SELECT * 
FROM drivers_license 
WHERE plate_number LIKE '%H42W%';

-- 8. Crucé la información de los sospechosos del gimnasio con las licencias.
-- Descubrí que: ¡JEREMY BOWERS es el asesino!
-- - Person ID: 67318
-- - License ID: 423327
-- - Placa: 0H42W2
-- - Auto: Chevrolet Spark LS
-- Cumple TODAS las condiciones: miembro Gold 48Z, estuvo el 9 de enero, placa H42W
SELECT 
    p.id AS person_id,
    p.name,
    p.license_id,
    dl.plate_number,
    dl.car_make,
    dl.car_model
FROM person p
JOIN drivers_license dl ON p.license_id = dl.id
WHERE p.id IN (28819, 67318);

-- 9. VERIFICACIÓN FINAL: Confirmé que Jeremy Bowers es el asesino.
INSERT INTO solution VALUES (1, 'Jeremy Bowers');
SELECT value FROM solution;