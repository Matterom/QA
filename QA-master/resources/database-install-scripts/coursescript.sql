/* DRAFT DATED 4/14/2019
*/

Create Table if not exists Rooms (
    room_key varchar(5) NOT NULL,
    LoginGroup int NOT NULL,
    active_connections int DEFAULT 0,
    Primary Key (room_key),
    Foreign Key (LoginGroup) REFERENCES qaproject.Courses(course_id)
);

/* Trigger which sets the Key value for newly created room */
DELIMITER ^^
CREATE TRIGGER IF NOT EXISTS qaproject.room_key_generator_bi
BEFORE INSERT ON Rooms FOR EACH ROW 
BEGIN
	declare rnd_str varchar(5);
    declare rdy int;
    set rdy = 0;
/* The following section sets the course key to a random string of
*  8 characters, (A-Z, 1-9) if it has not */
if isnull(NEW.) THEN
    while (not rdy) do
        set rnd_str := lpad(conv(floor(rand()*pow(36,5)), 10, 36), 5, 0);
            if not exists (select * from Rooms where room_key = rnd_str) then
                set NEW.room_key := rnd_str;
                set rdy = 1;
            end if;
    end while;
    
end if;

END^^
DELIMITER ;

CREATE TABLE IF NOT EXISTS RoomConnections (
    session_id      int         NOT NULL,
    id              int         NOT NULL,
    room_key        varchar(5)  NOT NULL,
    connectTime     TIMESTAMP   NOT NULL,
    exitTime        TIMESTAMP   
);

/* To create a room connection, call "Insert into RoomConnections
*    (session_id, id, room_key) Value (?, ?, ?)" All other fields
*    will auto-fill.
*/
DELIMITER ^^;
Create TRIGGER IF NOT EXISTS qaproject.room_connect_bi
BEFORE INSERT ON qaproject.RoomConnections
BEGIN

    set New.connectTime = NOW();
    -- Increment the active connections on room connection
    update Rooms 
        set active_connections = active_connections +1
        where room_key = new.room_key;
END^^

/* To leave a room, call an update on the current roomConnection
*  with endTime set to now()
*/
Create TRIGGER IF NOT EXISTS qaproject.room_connect_bu
BEFORE UPDATE ON qaproject.RoomConnections
BEGIN
    if (NEW.exitTime != NULL) THEN
        -- Increment the active connections on room connection
        update Rooms 
            set active_connections = active_connections - 1
            where room_key = new.room_key;
    end if;
END ^^

DELIMITER ;
