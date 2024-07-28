--2.
PRAGMA table_info(calls);
PRAGMA table_info(call_statuses);
PRAGMA table_info(counters);
PRAGMA table_info(demo);
PRAGMA table_info(jobs);
PRAGMA table_info(languages);
PRAGMA table_info(permissions);
PRAGMA table_info(queues);
PRAGMA table_info(roles);
PRAGMA table_info(role_has_permissions);
PRAGMA table_info(services);
PRAGMA table_info(sqlite_sequence);
PRAGMA table_info(users);

PRAGMA foreign_key_list(calls);
PRAGMA foreign_key_list(call_statuses);
PRAGMA foreign_key_list(counters);
PRAGMA foreign_key_list(demo);
PRAGMA foreign_key_list(jobs);
PRAGMA foreign_key_list(languages);
PRAGMA foreign_key_list(permissions);
PRAGMA foreign_key_list(queues);
PRAGMA foreign_key_list(roles);
PRAGMA foreign_key_list(role_has_permissions);
PRAGMA foreign_key_list(services);
PRAGMA foreign_key_list(sqlite_sequence);
PRAGMA foreign_key_list(users);

-- 3. Counter Summary
SELECT 
    counter_id,
    COUNT(*) AS called,
    SUM(served_time) AS serving,
    SUM(waiting_time) AS served,  
    SUM(CASE WHEN call_status_id = 2 THEN 1 ELSE 0 END) AS noshow

 FROM 
    calls
 WHERE 
    DATE(created_at) = '2024-02-14'
 GROUP BY 
    counter_id;

--4. Service Summary

SELECT 
    c.service_id,
    s.letter,
    COUNT(*) AS visitor,
	SUM(c.served_time) AS queued,
    COUNT(*) AS called,
    SUM(CASE WHEN c.call_status_id = 1 THEN 1 ELSE 0 END) AS served,

    SUM(c.served_time) AS serving,
    SUM(CASE WHEN c.call_status_id = 2 THEN 1 ELSE 0 END) AS noshow,
    SUM(c.turn_around_time) AS total_turn_around_time
FROM 
    calls c
INNER JOIN 
    services s ON c.service_id = s.id
WHERE 
    DATE(c.created_at) = '2024-02-14'
GROUP BY 
    c.service_id;

--5  Service x Counter Summary.
SELECT 
	c.service_id,
    s.letter,
    c.counter_id,
	COUNT(*) AS visitor,

    
    SUM(c.served_time) AS total_served_time,
    SUM(c.waiting_time) AS Waiting,
    SUM(c.served_time) AS serving,
    SUM(CASE WHEN c.call_status_id = 1 THEN 1 ELSE 0 END) AS served,
   SUM(CASE WHEN c.call_status_id = 2 THEN 1 ELSE 0 END) AS noshow

FROM 
    calls c
INNER JOIN 
    services s ON c.service_id = s.id
WHERE 
    DATE(c.created_at) = '2024-02-14'
GROUP BY 
    c.counter_id, c.service_id, s.letter
ORDER BY 
    c.service_id;
    
-- 6. Agent Summary
SELECT 
    c.service_id,
    u.name,
    s.letter,
    c.counter_id,
    COUNT(*) AS visitor,
    SUM(c.served_time) AS queued,
    SUM(c.waiting_time) AS Waiting,
    SUM(c.served_time) AS serving,
    SUM(CASE WHEN c.call_status_id = 1 THEN 1 ELSE 0 END) AS served,
    SUM(CASE WHEN c.call_status_id = 2 THEN 1 ELSE 0 END) AS noshow

FROM 
    calls c
INNER JOIN 
    services s ON c.service_id = s.id
INNER JOIN 
    users u ON c.user_id = u.id
WHERE 
    DATE(c.created_at) = '2024-02-14'
GROUP BY 
    c.counter_id, c.service_id, s.letter, u.id, u.name
ORDER BY 
    u.name;
    
    SELECT * FROM queues;


