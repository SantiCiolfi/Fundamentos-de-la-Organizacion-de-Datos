{
2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.
}


program ejercicio2;
const
	VA=9999;
type
	str = string[20];
	asistente=record
		num:integer;
		apellido:str;
		nombre:str;
		email:str;
		telefono:integer;
		dni:integer;
	end;
	
	archMae=file of asistente;
	
procedure menu(var mae:archMae);

	procedure cargarMaestro(var arch:archMae);
	var
		info:asistente;
	begin	
		with info do begin
			rewrite(arch);
			write('NUMERO DE ASISTENTE: ');readln(num);
			while (num <> 0) do begin
				write('APELLIDO: ');readln(apellido);
				write('NOMBRE: ');readln(nombre);
				write('EMAIL: ');readln(email);
				write('TELEFONO: ');readln(telefono);
				write('DNI: ');readln(dni);
				write(arch,info);
				writeln();
				write('NUMERO DE ASISTENTE: ');readln(num);
			end;
			close(arch);
		end;
	end;
	
	procedure imprimirMaestro(var arch:archMae);
	var
		info:asistente;
	begin
		reset(arch);
		with info do begin
			while (not EOF(arch)) do begin
				read(arch,info);
				writeln('NUMERO DE ASISTENTE: ', num);
				writeln('APELLIDO: ', apellido);
				writeln('NOMBRE: ', nombre);
				writeln('EMAIL: ', email);
				writeln('TELEFONO: ', telefono);
				writeln('DNI: ', dni);
				writeln();
			end;
		end;
		close(arch);
	end;
	
	procedure eliminarAsistentes(var mae:archMae);
	
		procedure leer(var mae:archMae; var regMae:asistente);
		begin
			if(not EOF(mae))then begin
				read(mae,regMae);
			end
			else
				regMae.num:=VA;
		end;
	
	var
		reg:asistente;
	begin
		reset(mae);
		leer(mae, reg);
		while(reg.num <> VA) do begin
			if(reg.num < 1000)then begin
				reg.apellido:= '*' + reg.apellido;
				seek(mae,filePos(mae)-1);
				write(mae,reg);
			end;
			leer(mae, reg);
		end;
		close(mae);
	end;
	
var
	op:integer;
begin
	op:=VA;
	while(op <> 0)do begin
		writeln('1) cargar maestro');
		writeln('2) imprimir maestro');
		writeln('3) eliminar asistentes');
		write('ingrese una opcion: '); readln(op);
		writeln('-----------------------------------------------------------------------------');
		case op of
			1:cargarMaestro(mae);
			2:imprimirMaestro(mae);
			3:eliminarAsistentes(mae);
		end;
	end;
end;
	
VAR
	mae:archMae;
BEGIN
	assign(mae,'Asistentes.dat');
	menu(mae);
END.

