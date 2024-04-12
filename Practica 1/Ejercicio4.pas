program Ejercicio4;

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

procedure menu(var archivo: arch_empleados);

	procedure cargarEmpleados (var archivo: arch_empleados);
	var
		e:empleado;
		aux:empleado;
		numClonado:boolean;
		i:integer;
	begin
		write('ingrese un apellido (con "fin" se termina): ');
		readln(e.apellido);
		while (e.apellido <> 'fin') do
		begin
			numClonado:=false;
			write('ingrese un numero de empleado: ');
			readln(e.numEmpleado);
			reset(archivo);
			for i:=0 to fileSize(archivo) - 1 do
			begin
				read(archivo,aux);
				if(aux.numEmpleado = e.numEmpleado)then
					numClonado := true;
			end;
			if(not numClonado)then
			begin
				write('ingrese un nombre: ');
				readln(e.nombre);
				write('ingrese una edad: ');
				readln(e.edad);
				write('ingrese un dni: ');
				readln(e.dni);
				write(archivo, e);
			end
			else
				writeln('numero de empleado ingresado ya registrado, intente otro numero de empleado');
			writeln();
			write('ingrese un apellido (con "fin" se termina): ');
			readln(e.apellido);
		end;
	end;

	procedure modificarEdad (var archivo: arch_empleados);
	var
		e:empleado;
		encontre:boolean;
		numero:integer;
		edad:integer;
	begin
		encontre:=	false;
		write('Ingrese el numero de empleado al que se le modificara la edad: ');
		readln(numero);
		while (not EOF(archivo))and (not encontre) do
		begin
			read(archivo, e);
			if(e.numEmpleado = numero )then
			begin
				encontre:= true;
				writeln('se encontro al empleado: ');
				write('numero de empleado: ', e.numEmpleado);
				write('|  apellido: ', e.apellido);
				write('|  nombre: ', e.nombre);
				write('| edad: ', e.edad);
				writeln('| dni: ', e.dni);
				write('ingrese la nueva edad del empleado: ');
				readln(edad);
				e.edad:=edad;
				seek(archivo, filePos(archivo) - 1);
				write(archivo, e);
				writeln();
			end;
		end;
	end;
	
	procedure exportarATexto(var archivo:arch_empleados);
	var
		arch_txt: file of string;
		e:empleado;
		st:string;
		edad:string;
		num:string;
		dni:string[20];
		i:integer;
	begin
		assign(arch_txt, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 1\todos_empleados.txt' );
		rewrite(arch_txt);
		for i:=0 to fileSize(archivo)-1 do
		begin
			read(archivo, e);
			 Str(e.numEmpleado,num);
			 Str( e.edad, edad);
			 Str(e.dni, dni);
			st:='| numero de empleado: '  + num +  ' | apellido: ' + e.apellido + ' | nombre: ' + e.nombre + ' | edad: ' + edad + ' | dni: '  + dni + '| --';
			write(arch_txt, st);
		end;
	end;
	procedure empleadosSinDni(var archivo:arch_empleados);
	var
		arch_txt: file of string;
		e:empleado;
		st:string;
		edad:string;
		num:string;
		dni:string;
		i:integer;
	begin
		assign(arch_txt, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 1\faltaDNIEmpleado.txt' );
		rewrite(arch_txt);
		for i:=0 to fileSize(archivo)-1 do
		begin
			read(archivo, e);
			if(e.dni = 00) then
			begin
				Str(e.numEmpleado,num);
				 Str( e.edad, edad);
				 Str(e.dni, dni);
				st:='| numero de empleado: '  + num +  ' | apellido: ' + e.apellido + ' | nombre: ' + e.nombre + ' | edad: ' + edad + ' | dni: '  + dni + '| --';
				write(arch_txt, st);
			end;
		end;
	end;
var
	opcion:integer;
begin
	opcion:=99;
	while(opcion <> 5) do
	begin
		writeln('------------------MENU------------------');
		writeln('1) anadir 1 o mas empleados (numero de empleado unico)');
		writeln('2) modificar edad de un empleado');
		writeln('3) exportar empleados a archivo de texto');
		writeln('4) exportar empleados sin dni');
		writeln('5) salir');
		readln(opcion);
		reset(archivo);
		case opcion of
			1: cargarEmpleados(archivo);
			2: modificarEdad(archivo);
			3: exportarATexto(archivo);
			4: empleadosSinDni(archivo);
			5: writeln('Cerrando el programa...')
		else
			writeln('opcion invalida');
		end;
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
	menu(empleados);
end.
