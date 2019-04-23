/*
    The purpose of this script is to connect to the existing database
    and create tables for Courses, Course_Attendees, and  

*/

CREATE TABLE IF NOT EXISTS qaproject.Courses(
    course_id     int   NOT NULL AUTO_INCREMENT,
    course_name   varchar(62) NOT NULL,
    course_subject varchar(5),
    course_number int,
    course_instructor varchar(62) NOT NULL,
    PRIMARY KEY(course_id),
    CONSTRAINT fk_username FOREIGN KEY (course_instructor) 
        REFERENCES accounts(username)
);

/* List of attendees certified for a given course. Attendees can not be saved
*  in the AttendanceRecords unless they have a record here. */
CREATE TABLE IF NOT EXISTS qaproject.attendees(
    attendee_id int(7) NOT NULL,
    course_id   int NOT NULL,
    PRIMARY KEY (attendee_id, course_id),
    CONSTRAINT fk_course_id_from_attendees FOREIGN KEY (course_id)
        REFERENCES Courses(course_id)
);

/* Insert using "Values (<course_id>, NULL, NULL)"
*  session_date and attendance_key are created by
*  trigger "date_key_generator_bi" */
CREATE TABLE IF NOT EXISTS qaproject.AttendanceKeys(
    course_id int NOT NULL,
    session_date date NOT NULL,
    attendance_key varchar(5) NOT NULL,
    PRIMARY KEY(course_id, session_date),
    CONSTRAINT fk_course_id_from_keys FOREIGN KEY (course_id)
        REFERENCES Courses(course_id)
);

/* Trigger which sets the Key and Date value for new AttendanceKeys */
DELIMITER ^^
CREATE TRIGGER IF NOT EXISTS qaproject.date_key_generator_bi
BEFORE INSERT ON AttendanceKeys FOR EACH ROW 
BEGIN
	declare rnd_str varchar(5);
    declare rdy int;
    set rdy = 0;
/* The following section sets the course key to a random string of
*  8 characters, (A-Z, 1-9) if it has not */
if isnull(NEW.attendance_key) THEN
    while (not rdy) do
        set rnd_str := lpad(conv(floor(rand()*pow(36,5)), 10, 36), 5, 0);
            if not exists (select * from AttendanceKeys where attendance_key = rnd_str) then
                set NEW.attendance_key := rnd_str;
                set rdy = 1;
            end if;
    end while;
    
    /* Sets the class date to the current date when a key is created */
    set NEW.session_date = current_date(); 
end if;

END^^
DELIMITER ;

# Index on attendance keys for quick lookup
CREATE INDEX IF NOT EXISTS qaproject.idx_attendance_keys on qaproject.AttendanceKeys(attendance_key);

/* AttendanceRecords log each instance of an attendee being marked present for
*  a given session of a course. Each session is indicated by attendance_key */
CREATE TABLE IF NOT EXISTS qaproject.AttendanceRecords(
    attendee_id int NOT NULL,
    attendance_key varchar(8) NOT NULL,
    Constraint pk_attendancerecords PRIMARY KEY(attendee_id, attendance_key),
    Constraint fk_att_records_attendee FOREIGN KEY (attendee_id)
        REFERENCES qaproject.attendees(attendee_id),
    CONSTRAINT fk_att_records_course_key FOREIGN KEY (attendance_key)
        REFERENCES qaproject.AttendanceKeys (attendance_key)
);
