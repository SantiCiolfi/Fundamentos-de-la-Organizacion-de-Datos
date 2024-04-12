program Ejercicio3;

type
	empleado=record
		numEmpleado:integer;
		apellido:string[10]; //"FIN" para cortar
		nombre:string[10];
		edad:integer;
		dni:integer;
	end;

	arch_empleados = file of empleado;
	
procedure listarEmpleadosNomApe (var archivo: arch_empleados);
var
	e:empleado;
	nombre:string;
	apellido:string;
begin
	writeln('listado de empleados con nombre o apellido determinados: ');
	writeln();
	write('ingrese el nombre a buscar: ');
	readln(nombre);
	write('ingrese el apellido a buscar: ');
	readln(apellido);
	while (not EOF(archivo))do
	begin
		read(archivo, e);
		if(e.nombre = nombre) or (e.apellido = apellido) then
		begin
			writeln('numero de empleado: ', e.numEmpleado);
			writeln('apellido: ', e.apellido);
			writeln('nombre: ', e.nombre);
			writeln('edad: ', e.edad);
			writeln('dni: ', e.dni);
			writeln();
		end;
	end;
end;

procedure listarEmpleadosMay70 (var archivo: arch_empleados);
var
	e:empleado;
begin
	writeln('empleados proximos a jubilarse: ');

	while (not EOF(archivo))do
	begin
		read(archivo, e);
		if(e.edad > 70)then
		begin
			write('numero de empleado: ', e.numEmpleado);
			write('|  apellido: ', e.apellido);
			write('|  nombre: ', e.nombre);
			write('| edad: ', e.edad);
			writeln('| dni: ', e.dni);
			writeln();
		end;
	end;
end;

procedure listarEmpleados (var archivo: arch_empleados);
var
	e:empleado;
begin
	writeln('listado de empleados: ');
	while (not EOF(archivo))do
	begin
		read(archivo, e);
		write('numero de empleado: ', e.numEmpleado);
		write('|  apellido: ', e.apellido);
		write('|  nombre: ', e.nombre);
		write('| edad: ', e.edad);
		writeln('| dni: ', e.dni);
		writeln();
	end;
end;

procedure cargarEmpleados (var archivo: arch_empleados);
var
	e:empleado;
begin
	write('ingrese un apellido (con "fin" se termina): ');
	readln(e.apellido);
	while (e.apellido <> 'fin') do
	begin
		write('ingrese un nombre: ');
		readln(e.nombre);
		write('ingrese un numero de empleado: ');
		readln(e.numEmpleado);
		write('ingrese un edad: ');
		readln(e.edad);
		write('ingrese un dni: ');
		readln(e.dni);
		write(archivo, e);
		writeln();
		write('ingrese un apellido (con "fin" se termina): ');
		readln(e.apellido);
	end;
end;

var
	empleados: arch_empleados;
	name:string[255];
BEGIN
	write('ingrese el nombre del archivo : ');
	readln(name);
	writeln();
	assign(empleados, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 1\' + name);
	rewrite(empleados);
	cargarEmpleados(empleados);
	reset(empleados);
	listarEmpleadosNomApe(empleados);
	reset(empleados);
	listarEmpleados(empleados);
	reset(empleados);
	listarEmpleadosMay70(empleados);
	close(empleados);
	readln();
end.
