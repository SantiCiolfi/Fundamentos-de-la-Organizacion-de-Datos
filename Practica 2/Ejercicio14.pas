{
Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua, # viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.
Para la actualización del archivo maestro, se debe proceder de la siguiente manera:
● Al valor de viviendas sin luz se le resta el valor recibido en el detalle.
● Idem para viviendas sin agua, sin gas y sin sanitarios.
● A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).
}


program ejercicio14;

const
	n=3;
	VA = 999;

type
	regMaestro = record
		codP:integer;
		nomP:string;
		codL:integer;
		nomL:string;
		sinL:integer;
		sinG:integer;
		deC:integer;
		sinA:integer;
		sinS:integer;
	end;
	
	regDetalle = record
		codP:integer;
		codL:integer;
		conL:integer;
		construidas:integer;
		conA:integer;
		conG:integer;
		san:integer;
	end;
	
	archDet = file of regDetalle;
	archMae = file of regMaestro;
	
	vDetalles =  array[1..n] of archDet;
	vReg = array[1..n]of regDetalle;
	
procedure menu(var mae:archMae; var v:vDetalles);

	procedure cargarMaestro (var arch:archMae);
	var
		info:regMaestro;
	begin
		rewrite(arch);
		with info do begin
			write('CODIGO DE PROVINCIA: ');readln(codP);
			while (codP <> 0) do begin
				write('CODIGO DE LOCALIDAD: ');readln(codL);
				write('VIVIENDAS SIN LUZ: ');readln(sinL);
				write('VIVIENDAS SIN GAS: ');readln(sinG);
				write('VIVIENDAS DE CHAPA: ');readln(deC);
				write('VIVIENDAS SIN AGUA: ');readln(sinA);
				write('VIVIENDAS SIN SANITARIOS: ');readln(sinS);
				write(arch,info);
				writeln();
				write('CODIGO DE PROVINCIA: ');readln(codP);
			end;
		end;
		close(arch);
	end;
	procedure cargarDetalle (var arch:archDet);
	var
		info:regDetalle;
	begin
		with info do begin
			write('CODIGO DE PROVINCIA: ');readln(codP);
			while (codP <> 0) do begin
				write('CODIGO DE LOCALIDAD: ');readln(codL);
				write('VIVIENDAS CON LUZ: ');readln(conL);
				write('VIVIENDAS CON GAS: ');readln(conG);
				write('VIVIENDAS CONSTRUIDAS: ');readln(construidas);
				write('VIVIENDAS CON AGUA: ');readln(conA);
				write('SANITARIOS ENTREGADOS: ');readln(san);
				write(arch,info);
				writeln();
				write('CODIGO DE PROVINCIA: ');readln(codP);
			end;
		end;
	end;
	procedure cargarDetalles(var v:vDetalles);
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
	
	procedure imprimirMaestro (var arch:archMae);
	var
		info:regMaestro;
	begin
		reset(arch);
		with info do begin
			while (not EOF(arch)) do begin
				read(arch,info);
				writeln('CODIGO DE PROVINCIA: ',codP);
				writeln('CODIGO DE LOCALIDAD: ',codL);
				writeln('VIVIENDAS SIN LUZ: ',sinL);
				writeln('VIVIENDAS SIN GAS: ',sinG);
				writeln('VIVIENDAS DE CHAPA: ',deC);
				writeln('VIVIENDAS SIN AGUA: ',sinA);
				writeln('VIVIENDAS SIN SANITARIO: ',sinS);
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
				writeln('CODIGO DE PROVINCIA: ',codP);
				writeln('CODIGO DE LOCALIDAD: ',codL);
				writeln('VIVIENDAS CON LUZ: ',conL);
				writeln('VIVIENDAS CON GAS: ',conG);
				writeln('VIVIENDAS CONSTRUIDAS: ',construidas);
				writeln('VIVIENDAS CON AGUA: ',conA);
				writeln('SANITARIO ENTREGADOS: ',san);
				writeln();
			end;
		end;
	end;
	procedure imprimirDetalles(var v:vDetalles);
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

	procedure actualizarMaestro(var v:vDetalles; var mae:archMae);
	
		procedure leer (var det:archDet; var d:regDetalle);
		begin
			if (not EOF(det)) then begin
				read(det, d);
			end
			else
				d.codP:=VA;
		end;
		
		procedure minimo (var v:vDetalles; var vDet:vReg; var min:regDetalle);
		var
			i:integer;
			indiceMin:integer;
		begin
			min.codP:=VA;
			min.codL:=VA;
			for i:=1 to n do begin
				if(vDet[i].codP < min.codP)then begin
					indiceMin:=i;
					min:=vDet[i];
				end
				else
					if(vDet[i].codP = min.codP) then
						if(vDet[i].codL < min.codL)then begin
							indiceMin:=i;
							min:=vDet[i];
						end
			end;
			leer(v[indiceMin], vDet[indiceMin])
		end;
		
		procedure generarInforme (reg:regMaestro; var info:text);
		begin
			writeln(info, reg.codP, ' ', reg.codL, ' ', reg.deC);
		end;
		
	var
		provActual:integer;
		locActual:integer;
		i:integer;
		regMae:regMaestro;
		vDet:vReg;
		min:regDetalle;
		informe:text;
	begin
		assign(informe, 'informeONG.txt');
		rewrite(informe);
		for i:=1 to n do begin
			reset(v[i]);
			leer(v[i],vDet[i]);
		end;
		reset(mae);
		minimo(v, vDet, min);
		while (min.codP <> VA) do begin
			read(mae, regMae);
			while(regMae.codP <> min.codP) and (regMae.codL <> min.codL) do begin
				if(regMae.deC = 0)then
					generarInforme(regMae, informe);
				read(mae, regMae);
			end;
			provActual:=min.codP;
			locActual:=min.codL;
			while (provActual = min.codP) and (locActual = min.codL) do begin
				regMae.sinL:=regMae.sinL - min.conL;
				regMae.sinG:=regMae.sinG - min.conG;
				regMae.sinA:=regMae.sinA - min.conA;
				regMae.sinS:=regMae.sinS - min.san;
				regMae.deC:=regMae.deC - min.construidas;
				minimo(v, vDet, min);
			end;
			if(regMae.deC = 0)then
				generarInforme(regMae, informe);
			seek(mae, filepos(mae)-1);
			write(mae,regMae);
		end;
		for i:=1 to n do begin
			close(v[i])
		end;
		while(not EOF(mae)) do begin
			read(mae, regMae);
			if(regMae.deC = 0)then
				generarInforme(regMae, informe);
		end;
		close(informe);
		close(mae);
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
		writeln('0-Finalizar');
		write('Ingrese una opcion: ');
		readln(opc);
		writeln();
		case opc of 
			1:cargarMaestro(mae);
			2:cargarDetalles(v);
			3:imprimirMaestro(mae);
			4:imprimirDetalles(v);
			5:actualizarMaestro(v,mae);
			0:writeln('cerrando programa...');
			else writeln('OPCION INCORRECTA');
		end;
		writeln('-----------------------------------------------------------------------------------------');
	end;
end;
	
var
	mae:archMae;
	v:vDetalles;
BEGIN
	assign(v[1], 'ONGdet1.dat');
	assign(v[2], 'ONGdet2.dat');
	assign(v[3], 'ONGdet3.dat');
	assign(mae, 'ONG.dat');
	menu(mae, v);
END.

