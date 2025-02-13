MERGE (
    u:User {global_entity_id: 'e25a09aa-919f-11eb-ac2b-ee9477001436-1617140144', 
    announcement_indoctestproject: 7, 
    path: 'users',  
    role: $ROLE,
    name: $ROLE, 
    last_name: $ROLE, 
    first_name: $ROLE, 
    email: $EMAIL, 
    username: $ROLE, 
    status: 'active'}) 
ON CREATE
  SET 
    u.time_lastmodified = toString(datetime()),
    u.last_login = toString(datetime())
  
RETURN u;