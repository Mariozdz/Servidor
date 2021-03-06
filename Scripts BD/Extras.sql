
create or replace function fn_login(Pid in varchar2, Ppassword in varchar2) return number as
Vcant number;
begin
	select count(*)
	into Vcant
	from AUser
	where ID = Pid and Password = Ppassword ;
	
  if Vcant > 0 then
	return (1);
  else 
	return (-1);
  end if;
end fn_login;
/

CREATE OR REPLACE FUNCTION fn_login_get(Pid in varchar2, Ppassword in varchar2)
RETURN SYS_REFCURSOR
AS
    login_cursor SYS_REFCURSOR;
BEGIN
    OPEN login_cursor FOR
        SELECT ID, Password, Name, Surnames, Latitud, Longitud, Cellphone FROM AUser where ID = Pid and Password = Ppassword;
RETURN login_cursor;
CLOSE login_cursor;
END;
/


create or replace view rep_country as 
select p.ID, p.TypePlaneId, T.Model, T.Brand, T.NumberRow, T.NumberColums 
from Plane p, TypePlane T
where p.TypePlaneId = T.ID;


CREATE OR REPLACE FUNCTION fn_get_planeandtype
RETURN SYS_REFCURSOR
AS
    get_cursor SYS_REFCURSOR;
BEGIN
    OPEN get_cursor FOR
        SELECT * from rep_country;
RETURN get_cursor;
CLOSE get_cursor;
END;
/

create or replace view rep_flight as 
select f.ID, f.PlaneId, f.Outbound, s.Stime,f.OutboundDate,  to_char(s.Sdate,'hh24:mi') Sdate,to_char(f.ArriveTime,'hh24:mi') arrivetime, r.Duration,r.price,r.Discount, c1.name origen, c2.name destino, (t.NumberRow * t.NumberColums) cantidadasientos, f.isreturned
from Flight f, Schedule s, Route r, Country c1, Country c2, Plane p, TypePlane t
where f.outbound = s.ID and s.RouteId = r.ID and r.OrigenId = c1.ID and r.DestinoId = c2.ID and f.PlaneId = p.ID and p.TypePlaneId = t.ID;


CREATE OR REPLACE FUNCTION fn_get_completeflight
RETURN SYS_REFCURSOR
AS
    get_cursor SYS_REFCURSOR;
BEGIN
    OPEN get_cursor FOR
        SELECT * from rep_flight;
RETURN get_cursor;
CLOSE get_cursor;
END;
/


create or replace function fn_cantida_espacios(Pid in number) return number as
Vcant number;
begin
	select sum(Tickets)
	into Vcant
	from Purchase
	where FlightId =  pid or ReturnFlightId = pid;
	return Vcant;
  
end fn_cantida_espacios;
/


create or replace view rep_schedule as 
select s.ID,to_char(s.Sdate,'hh24:mi') Sdate, s.Stime,s.RouteId, r.Duration,r.price,r.Discount, c1.name origen, c2.name destino
from Schedule s, Route r, Country c1, Country c2
where s.RouteId = r.ID and r.OrigenId = c1.ID and r.DestinoId = c2.ID;


CREATE OR REPLACE FUNCTION fn_schedule
RETURN SYS_REFCURSOR
AS
    get_cursor SYS_REFCURSOR;
BEGIN
    OPEN get_cursor FOR
        SELECT * from rep_schedule;
RETURN get_cursor;
CLOSE get_cursor;
END;
/

CREATE OR REPLACE FUNCTION fn_getbyuser_purchase(Pid in varchar2)
RETURN SYS_REFCURSOR
AS
    purchase_cursor SYS_REFCURSOR;
BEGIN
    OPEN purchase_cursor FOR
        SELECT ID ,FlightId, UserId, TotalPrice, Tickets, ReturnFlightId FROM Purchase where UserId = Pid;
RETURN purchase_cursor;
CLOSE purchase_cursor;
END;
/

CREATE OR REPLACE FUNCTION fn_getbypurchase_ticket(Pid in number)
RETURN SYS_REFCURSOR
AS
    ticket_cursor SYS_REFCURSOR;
BEGIN
    OPEN ticket_cursor FOR
        SELECT ID, Scolum, Srow, PurchaseId, IsReturn FROM Ticket where PurchaseId = Pid;
RETURN ticket_cursor;
CLOSE ticket_cursor;
END;
/

CREATE OR REPLACE FUNCTION fn_getbypurchase_ticket(Pid in number)
RETURN SYS_REFCURSOR
AS
    ticket_cursor SYS_REFCURSOR;
BEGIN
    OPEN ticket_cursor FOR
        SELECT ID, Scolum, Srow, PurchaseId, IsReturn FROM Ticket where PurchaseId = Pid;
RETURN ticket_cursor;
CLOSE ticket_cursor;
END;
/

create or replace view rep_campos as 
select t.Scolum ccolumn, t.Srow rrow, f.ID flightid
from Ticket t, Purchase p, Flight f 
where t.isreturn = 0 and t.PurchaseId = p.ID and p.FlightId = f.ID or t.isreturn = 1 and t.PurchaseId = p.ID and p.ReturnFlightId = f.ID;

CREATE OR REPLACE FUNCTION fn_campos_ocupados(Pid in number)
RETURN SYS_REFCURSOR
AS
    get_cursor SYS_REFCURSOR;
BEGIN
    OPEN get_cursor FOR
        SELECT * from rep_campos where flightId = Pid;
RETURN get_cursor;
CLOSE get_cursor;
END;
/


create or replace function fn_total_purchase(Pid number) return number as
Vcant number;
begin
	select sum(TotalPrice)
	into Vcant
	from Purchase
	where extract(MONTH from PurchaseDate) = Pid;
	
  if Vcant > 0 then
	return Vcant;
  else 
	return (0);
  end if;
end fn_total_purchase;
/

create or replace function fn_total_anno return float as
Vcant float;
begin
	select sum(TotalPrice)
	into Vcant
	from Purchase
	where PurchaseDate  > ADD_MONTHS(SYSDATE,-12);
	
  if Vcant > 0 then
	return Vcant;
  else 
	return (0);
  end if;
end fn_total_anno;
/



create or replace view rep_five as 
select r.ID, sum(p.Tickets) total
from Purchase p, Flight f, Schedule s, Route r 
where p.FlightId = f.ID and f.Outbound = s.ID and s.RouteId = r.ID or p.ReturnFlightId = f.ID and f.Outbound = s.ID and s.RouteId = r.ID group by r.ID order by total desc;




create or replace view rep_flight_users as 
select unique u.ID userid, u.Name, u.Surnames, f.ID flightid
from AUser u, Purchase p, Flight f 
where p.userid = u.ID and p.FlightId = f.ID or p.userid = u.ID and p.ReturnFlightId = f.ID;

CREATE OR REPLACE FUNCTION fn_flight_users(Pid in number)
RETURN SYS_REFCURSOR
AS
    get_cursor SYS_REFCURSOR;
BEGIN
    OPEN get_cursor FOR
        SELECT * from rep_flight_users where FlightId = Pid;
RETURN get_cursor;
CLOSE get_cursor;
END;
/



CREATE OR REPLACE FUNCTION fn_get_five
RETURN SYS_REFCURSOR
AS
    five_cursor SYS_REFCURSOR;
BEGIN
    OPEN five_cursor FOR
        SELECT r.ID routeId, r.total total, c.Name origin, c2.Name destination, p.OrigenId 
		from rep_five r, Country c,Country c2, Route p 
		where rownum < 6 
		and r.ID = p.ID 
		and p.OrigenId = c.ID 
		and p.DestinoId = c2.ID;
RETURN five_cursor;
CLOSE five_cursor;
END;
/



