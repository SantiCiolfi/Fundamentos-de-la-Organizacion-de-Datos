{
Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}


program ejercicio13;

const
	VA=999;
	n=2;
	VAst='ZZZZ';

type

	vuelo = record
		destino:string;
		fecha:integer;
		horaS:integer;
		asientosDisp:integer;
	end;
	
	regDetalle = record
		destino:string;
		fecha:integer;
		horaS:integer;
		asientosC:integer;
	end;
	
	archMaestro = file of vuelo;
	archDet = file of regDetalle;
	vectorRegistros = array [1..n] of regDetalle;
	vector = array [1..n] of archDet;
	
	lista = ^nodo;
	nodo = record
		dato:vuelo;
		sig:lista;
	end;
	
procedure menu (var mae:archMaestro; var v:vector; var l:lista);

	procedure cargarMaestro (var arch:archMaestro);
	var
		info:vuelo;
	begin
		rewrite(arch);
		with info do begin
			write('DESTINO: ');readln(destino);
			while (destino <> '') do begin
				write('FECHA: ');readln(fecha);
				write('HORA DE SALIDA: ');readln(horaS);
				write('CANTIAD DE ASIENTOS DISPONIBLES: ');readln(asientosDisp);
				write(arch,info);
				writeln();
				write('DESTINO: ');readln(destino);
			end;
		end;
		close(arch);
	end;
	procedure cargarDetalle (var arch:archDet);
	var
		info:regDetalle;
	begin
		with info do begin
			write('DESTINO: ');readln(destino);
			while (destino <> '') do begin
				write('FECHA: ');readln(fecha);
				write('HORA DE SALIDA: ');readln(horaS);
				write('CANTIAD DE ASIENTOS COMPRADOS: ');readln(asientosC);
				write(arch,info);
				writeln();
				write('DESTINO: ');readln(destino);
			end;
		end;
	end;
	procedure cargarDetalles(var v:vector);
	var
		i:integer;
	begin
		for i:= 1 to N do begin
			writeln('-----DETALLE ',i,' ------');
			rewrite(v[i]);
			cargarDetalle(v[i]);
			close(v[i]);
		end;
	end;
	
	procedure imprimirMaestro (var arch:archMaestro);
	var
		info:vuelo;
	begin
		reset(arch);
		with info do begin
			while (not EOF(arch)) do begin
				read(arch,info);
				writeln('DESTINO: ',destino);
				writeln('FECHA: ',fecha);
				writeln('HORA DE SALIDA: ',horaS);
				writeln('CANTIDAD DE ASIENTOS DISPONIBLES: ',asientosDisp);
				writeln;
			end;
		end;
		close(arch);
	end;
	procedure imprimirDetalle(var arch:archDet);
	var
		info:regDetalle;
	begin
		with info do begin
			while (not EOF(arch)) do begin
				read(arch,info);
				writeln('DESTINO: ',destino);
				writeln('FECHA: ',fecha);
				writeln('HORA DE SALIDA: ',horaS);
				writeln('CANTIDAD DE ASIENTOS COMPRADOS: ',asientosC);
				writeln();
			end;
		end;
	end;
	procedure imprimirDetalles(var v:vector);
	var
		i:integer;
	begin
		for i:= 1 to n do begin
			writeln('-----DETALLE ',i,' ------');
			reset(v[i]);
			imprimirDetalle(v[i]);
			close(v[i]);
		end;
	end;
	
	procedure actualizarMaestro(var v:vector; var mae:archMaestro; var l:lista);
	
		procedure leer (var det:archDet; var d:regDetalle);
		begin
			if (not EOF(det)) then begin
				read(det, d);
			end
			else
				d.destino:=VAst;
		end;
		
		procedure minimo (var v:vector; var vDet:vectorRegistros; var min:regDetalle);
		var
			i:integer;
			indiceMin:integer;
		begin
			min.destino:=VAst;
			min.fecha:=VA;
			min.horaS:=VA;
			for i:=1 to n do begin
				if(vDet[i].destino < min.destino)then begin //si el destino actual es menor al anterior, actualizo
					indiceMin:=i;
					min:=vDet[i];
				end
				else
					if(vDet[i].destino = min.destino) then //sino, si son iguales pregunto por la fecha
						if(vDet[i].fecha < min.fecha)then begin //si la fecha es menor a la anterior, actualizo
							indiceMin:=i;
							min:=vDet[i];
						end
						else
							if(vDet[i].fecha = min.fecha)then //sino, si son iguales pregunto por la hora de salida
								if(vDet[i].horaS < min.horaS) then begin//si la hora de salida es menor a la anterior, actualizo
									indiceMin:=i;
									min:=vDet[i];
								end;
			end;
			leer(v[indiceMin], vDet[indiceMin])
		end;
		
		procedure agregar (var l:lista; item:vuelo);
		var
			nue:lista;
		begin
			new(nue);
			nue^.dato:=item;
			nue^.sig:=l;
			l:=nue;
		end;
		
	var
		destinoActual:string;
		fechaActual:integer;
		horaActual:integer;
		regMae:vuelo;
		i:integer;
		vDet:vectorRegistros;
		min:regDetalle;
		cantidadMinimaAsientos:integer;
	begin
		write('ingrese la cantidad minima de asientos disponibles por vuelo: '); readln(cantidadMinimaAsientos);
		for i:=1 to n do begin
			reset(v[i]);
			leer(v[i], vDet[i]);
		end;
		reset(mae);
		minimo(v, vDet, min);
		while (min.destino <> VAst) do begin
			read(mae, regMae);
			while (regMae .destino <> min.destino) and (regMae.fecha <> min.fecha) and (regMae.horaS <> min.horaS) do begin
				if(regMae.asientosDisp < cantidadMinimaAsientos)then
					agregar(l, regMae);
				read(mae, regMae);
			end;
			destinoActual:=min.destino;
			fechaActual:=min.fecha;
			horaActual:=min.horaS;
			while (destinoActual = min.destino) and (fechaActual = min.fecha) and (horaActual = min.horaS) do begin
				regMae.asientosDisp:=regMae.asientosDisp - min.asientosC;
				minimo(v, vDet, min);
			end;
			if(regMae.asientosDisp < cantidadMinimaAsientos)then
				agregar(l, regMae);
			seek(mae, filePos(mae)-1);
			write(mae, regMae);
		end;
		for i:=1 to n do begin
			close(v[i])
		end;
		while(not EOF(mae)) do begin
			read(mae, regMae);
			if(regMae.asientosDisp < cantidadMinimaAsientos)then
				agregar(l, regMae);
		end;
		close(mae);
	end;
	
	procedure imprimirLista(l:lista);
	var
		i:integer;
	begin
		i:=1;
		while(l <> nil)do begin
			writeln('elemento: ',i);
			writeln(l^.dato.destino, ' ', l^.dato.fecha, ' ', l^.dato.horaS);
			l:=l^.sig;
			i:=i+1;
		end;
	end;
	
var
	opc:integer;
begin
	opc:=VA;
	while (opc <> 0) do begin
		writeln('1-Cargar maestro');
		writeln('2-Cargar detalles');
		writeln('3-Imprimir maestro');
		writeln('4-Imprimir detalles');
		writeln('5-Actualizar maestro');
		writeln('6-Imprimir lista');
		writeln('0-Finalizar');
		write('Ingrese una opcion: ');
		readln(opc);
		writeln();
		case opc of 
			1:cargarMaestro(mae);
			2:cargarDetalles(v);
			3:imprimirMaestro(mae);
			4:imprimirDetalles(v);
			5:actualizarMaestro(v,mae, l);
			6:imprimirLista(l);
			0:writeln('cerrando programa...');
			else writeln('OPCION INCORRECTA');
		end;
		writeln('-----------------------------------------------------------------------------------------');
	end;
end;
	
var
	maestro:archMaestro;
	v:vector;
	l:lista;
BEGIN
	l:=nil;
	assign(v[1], 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 2\DetalleVuelos1.dat');
	assign(v[2], 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 2\DetalleVuelos2.dat');
	assign(maestro, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 2\Vuelos.dat');
	menu(maestro, v, l);
END.
