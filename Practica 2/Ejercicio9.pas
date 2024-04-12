{
 Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
}


program ejercicio9;

const
	VA=999;

type
	mesa = record
		codP:integer;
		codL:integer;
		num:integer;
		cantV:integer;
	end;
	arch_maestro = file of mesa;

procedure menu (var archivo:arch_maestro);
	
	procedure cargarMaestro (var arch:arch_maestro);
	var
		m:mesa;
	begin
		rewrite(arch);
		with m do begin
			write('CODIGO DE PROVINCIA: ');readln(codP);
			while (codP <> 0) do begin
				write('CODIGO DE LOCALIDAD: ');readln(codL);
				write('NUMERO DE MESA: ');readln(num);
				write('CANTIDAD DE VOTOS: ');readln(cantV);
				write(arch,m);
				writeln();
				write('CODIGO DE PROVINCIA: ');readln(codP);
			end;
		end;
		close(arch);
	end;	
	
	procedure imprimirMaestro (var arch:arch_maestro);
	var
		m:mesa;
	begin
		reset(arch);
		with m do begin
			while (not EOF(arch)) do begin
				read(arch,m);
				writeln('CODIGO DE PROVINCIA: ',codP);
				writeln('CODIGO DE LOCALICAD: ',codL);
				writeln('NUMERO DE MESA: ',num);
				writeln('CANTIDAD DE VOTOS: ',cantV);
				writeln;
			end;
		end;
		close(arch);
	end;
	
	procedure procesarMaestro (var maestro:arch_maestro);
	
		procedure leer (var arch:arch_maestro; var dato:mesa);
		begin
			if (not EOF(arch)) then read(arch,dato)
			else dato.codP := VA;
		end;
		
	var
		reg:mesa;
		ProvinciaActual:integer;
		LocalidadActual:integer;
		VotosTotal:integer;
		VotosProvincia:integer;
		VotosLocalidad:integer;
	begin
		reset(maestro);
		VotosTotal:=0;
		leer(maestro,reg);
		while (reg.codP <> VA) do begin
			ProvinciaActual := reg.codP;
			VotosProvincia:=0;
			writeln('Codigo de provincia: ', ProvinciaActual);
			while (ProvinciaActual = reg.codP) do begin
				LocalidadActual := reg.codL;
				writeln('Codigo de localidad: ', LocalidadActual);
				VotosLocalidad:=0;
				while (ProvinciaActual = reg.codP)  and (LocalidadActual = reg.codL) do begin
					VotosLocalidad:=VotosLocalidad + reg.cantV;
					leer(maestro,reg);
				end;
				writeln('Total de votos: ', VotosLocalidad);
				writeln();
				VotosProvincia:=VotosProvincia + VotosLocalidad;
			end;
			writeln('Total de votos provincia: ', VotosProvincia);
			writeln();
			VotosTotal:=VotosTotal + VotosProvincia;
		end;
		writeln('Total general de votos: ',VotosTotal);
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
			3:procesarMaestro(archivo);
			4:writeln('Cerrando programa...');
			else
				writeln('Opcion incorrecta');
		end;
		writeln('----------------------------------------------------');
	end;
end;

var
	archivo:arch_maestro;
BEGIN
	assign(archivo, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 2\mesasElectorales.dat');
	menu(archivo);
END.

