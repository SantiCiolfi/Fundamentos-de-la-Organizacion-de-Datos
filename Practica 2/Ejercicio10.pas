{
Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado. Presentar en pantalla un listado con el
siguiente formato:
 Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____

Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.
}


program ejercicio10;

const
	VA=999;
	cat=15;
type
	categorias = 1..cat;
	empleado = record
		dep:integer; //chequear tipos pero no afecta
		division:integer;
		num:integer;
		categoria:categorias;
		cantHorasExtras:integer;
	end;
	
	archMaestro = file of empleado;
	
	vector = array [1..cat] of real;
	
procedure cargarVector(var v:vector);
var
	i:integer;
	num:integer;
	valor:real;
	archivo:text;
begin
	assign(archivo,'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 2\ValorDeLaHora.txt');
	reset(archivo);
	for i:=1 to cat do
	begin
		readln(archivo,num, valor);
		v[num]:=valor;
	end;
	close(archivo);
end;

procedure menu (var archivo:archMaestro; v:vector);
	
	procedure cargarMaestro (var arch:archMaestro);
	var
		e:empleado;
	begin
		rewrite(arch);
		with e do begin
			write('DEPARTAMENTO: ');readln(dep);
			while (dep <> 0) do begin
				write('DIVISION: ');readln(division);
				write('NUMERO DE EMPLEADO: ');readln(num);
				write('CATEGORIA:  ');readln(categoria);
				write('CANTIDAD DE HORAS EXTRAS:  ');readln(cantHorasExtras);
				write(arch,e);
				writeln();
				write('DEPARTAMENTO: ');readln(dep);
			end;
		end;
		close(arch);
	end;	
	
	procedure imprimirMaestro (var arch:archMaestro);
	var
		e:empleado;
	begin
		reset(arch);
		with e do begin
			while (not EOF(arch)) do begin
				read(arch,e);
				writeln('DEPARTAMENTO: ',dep);
				writeln('DIVISION: ',division);
				writeln('NUMERO DE EMPLEADO: ',num);
				writeln('CATEGORIA: ',categoria);
				writeln('CANTIDAD DE HORAS EXTRAS: ', cantHorasExtras);
				writeln;
			end;
		end;
		close(arch);
	end;
	
	procedure procesarMaestro (var maestro:archMaestro; v:vector);
	
		procedure leer (var arch:archMaestro; var dato:empleado);
		begin
			if (not EOF(arch)) then read(arch,dato)
			else dato.dep := VA;
		end;
		
	var
		reg:empleado;
		depActual:integer;
		divActual:integer;
		numActual:integer;
		horasDep:integer;
		montoDep:real;
		horasDiv:integer;
		montoDiv:real;
		horas:integer;
		monto:real;
		categoria:integer;
	begin
		reset(maestro);
		leer(maestro,reg);
		while (reg.dep <> VA) do begin
			depActual := reg.dep;
			horasDep:=0;
			montoDep:=0;
			writeln('Departamento: ', depActual);
			while (depActual = reg.dep) do begin
				divActual := reg.division;
				writeln('Division: ', divActual);
				horasDiv:=0;
				montoDiv:=0;
				while (depActual = reg.dep)  and (divActual = reg.division) do begin
					numActual:=reg.num;
					horas:=0;
					monto:=0;
					categoria:=reg.categoria;
					writeln('Numero De Empleado: ', reg.num);
					while(depActual = reg.dep)  and (divActual = reg.division) and (numActual = reg.num)do begin
						horas:=horas + reg.cantHorasExtras;
						leer(maestro,reg);
					end;
					monto:=horas * v[categoria];
					writeln('Total de Horas: ', horas);
					writeln('Importe a Cobrar: ', monto:0:0);
					writeln();
					montoDiv:=montoDiv + monto;
					horasDiv:=horasDiv + horas;
				end;
				horasDep:=horasDep + horasDiv;
				montoDep:= montoDep + montoDiv;
				writeln('Total de horas division: ', horasDiv);
				writeln('Monto total division: ', montoDiv:0:0);
				writeln();
			end;
			writeln('Total horas departamento: ', horasDep);
			writeln('Monto total departamento: ', montoDep:0:0);
			writeln();
		end;
		close(maestro);
	end;
	
var
	opc:integer;
begin
	opc:=0;
	while (opc <> 4)do
	begin
		writeln('1) Cargar maestro');
		writeln('2) Imprimir maestro');
		writeln('3) Procesar maestro');
		writeln('4) Cerrar programa');
		write('Ingrese una opcion: ');
		readln(opc);
		writeln();
		case opc of
			1: cargarMaestro(archivo);
			2:imprimirMaestro(archivo);
			3:procesarMaestro(archivo, v);
			4:writeln('Cerrando programa...');
			else
				writeln('Opcion incorrecta');
		end;
		writeln('----------------------------------------------------');
	end;
end;	
var 
	maestro:archMaestro;
	v:vector;
BEGIN
	cargarVector(v);
	assign(maestro, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 2\HorasExtrasEmpleados.dat');
	menu(maestro,v);
END.

