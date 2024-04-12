program untitled;
const N = 2; //10 
	VALOR_ALTO = 999;
type
	informacionDetalle = record
		codLocalidad:integer;
		codCepa:integer;
		casosActivos:integer;
		casosNuevos:integer;
		casosRecuperados:integer;
		casosFallecidos:integer;
	end;
	
	str = string[20];
	informacionMaestro = record	
		codLocalidad:integer;
		localidad:str;
		codCepa:integer;
		nombreCepa:str;
		casosActivos:integer;
		casosNuevos:integer;
		casosRecuperados:integer;
		casosFallecidos:integer;
	end;
	
	
	archDetalle = file of informacionDetalle;
	archMaestro = file of informacionMaestro;
	vDetalles = array [0..N] of archDetalle;
	vRegistros = array [0..N] of informacionDetalle;
	
	
procedure informarLocalidades (var maestro:archMaestro);
var
	info:informacionMaestro;
	codActual:integer;
	cant,activos:integer;
begin
	cant:=0;
	reset(maestro);
	while (not EOF(maestro)) do begin
		read(maestro,info);
		codActual:= info.codLocalidad;
		activos:=0;
		while (codActual = info.codLocalidad) do begin
			activos:= activos + info.casosActivos;
			read(maestro,info);
		end;
		seek(maestro,filepos(maestro)-1);
		if (info.casosActivos > 50) then
			cant:= cant + 1;
	end;
	close(maestro);
	writeln('La cantidad de localidades con más de 50 casos activos es: ',cant);
end;

procedure actualizarMaestro(var v:vDetalles; var maestro:archMaestro);
	procedure leer (var arch:archDetalle; var dato:informacionDetalle);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else begin
			dato.codLocalidad := VALOR_ALTO;
			dato.codCepa := VALOR_ALTO;
		end;
	end;
	procedure minimo (var v:vDetalles; var vReg:vRegistros; var min:informacionDetalle);
	var
		i:integer;
		indiceMin:integer;
	begin
		min.codLocalidad:= VALOR_ALTO; min.codCepa:= VALOR_ALTO;
		for i:= 0 to N do begin
			if (vReg[i].codLocalidad <= min.codLocalidad) and (vReg[i].codCepa <= min.codCepa)then begin
				min := vReg[i]; //Actualizo minimo
				indiceMin:=i;
			end;
		end;
		leer(v[indiceMin],vReg[indiceMin]); //cargo vReg con el siguiente registro del detalle minimo
	end;
var
	min:informacionDetalle;
	vReg:vRegistros;
	rMaestro:informacionMaestro;
	cepaActual,codActual:integer;
	i:integer;
begin
	for i:= 0 to N do begin
		reset(v[i]);
		leer(v[i],vReg[i]); //Cargo el vReg con los primeros registros de v
	end;
	reset(maestro);
	minimo(v,vReg,min); //Veo cual de los registros de vReg es el minimo
	while (min.codLocalidad <> 999) and (min.codCepa <> 999) do begin 
		read(maestro,rMaestro);
		while (rMaestro.codLocalidad <> min.codLocalidad) and (rMaestro.codCepa <> min.codCepa) do 
			read(maestro,rMaestro);
		codActual := min.codLocalidad; //Actualizo codLocalidad
		cepaActual := min.codCepa; //Actualizo codCepa
		writeln(codActual,' ',cepaActual);
		while (codActual = min.codLocalidad) and (cepaActual = min.codCepa) do begin
			writeln(min.casosFallecidos,' ',min.casosRecuperados,' ',min.casosActivos);
			rMaestro.casosFallecidos := rMaestro.casosFallecidos + min.casosFallecidos;
			rMaestro.casosRecuperados := rMaestro.casosRecuperados + min.casosRecuperados;
			rMaestro.casosActivos := min.casosActivos;
			rMaestro.casosNuevos := min.casosNuevos;
			minimo(v,vReg,min);
		end;
		seek(maestro,filepos(maestro)-1);
		write(maestro,rMaestro);
	end;
	close(maestro);
	for i:= 0 to N do begin
		close(v[i]);
	end;
end;

procedure menu (var vDet:vDetalles; var maestro:archMaestro);
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Cargar detalles');
		writeln('3-Imprimir maestro');
		writeln('4-Imprimir detalles');
		writeln('5-Actualizar maestro');
		writeln('6-Informar localidades');
		writeln('0-Finalizar');
		readln(op);
	end;
	procedure cargarMaestro (var arch:archMaestro);
	var
		info:informacionMaestro;
	begin
		rewrite(arch);
		with info do begin
			write('CODIGO LOCALIDAD: ');readln(codLocalidad);
			while (codLocalidad <> 0) do begin
				write('CODIGO CEPA: ');readln(codCepa);
				{write('LOCALIDAD: ');readln(localidad);
				write('NOMBRE CEPA: ');readln(nombreCepa);
				write('CASOS ACTIVOS: ');readln(casosActivos);
				write('CASOS NUEVOS: ');readln(casosNuevos);
				write('CASOS RECUPERADOS: ');readln(casosRecuperados);
				write('CASOS FALLECIDOS: ');readln(casosFallecidos);}
				
				nombreCepa:= 'CEPITA'; localidad:='DENGUE';
				casosActivos := 0;
				casosNuevos := 0;
				casosRecuperados := 0;
				casosFallecidos := 0;
				
				write(arch,info);
				writeln();
				write('CODIGO LOCALIDAD: ');readln(codLocalidad);
			end;
		end;
		close(arch);
	end;
	procedure cargarDetalle (var arch:archDetalle);
	var
		info:informacionDetalle;
	begin
		with info do begin
			write('CODIGO LOCALIDAD: ');readln(codLocalidad);
			while (codLocalidad <> 0) do begin
				write('CODIGO CEPA: ');readln(codCepa);
				write('CASOS ACTIVOS: ');readln(casosActivos);
				write('CASOS NUEVOS: ');readln(casosNuevos);
				write('CASOS RECUPERADOS: ');readln(casosRecuperados);
				write('CASOS FALLECIDOS: ');readln(casosFallecidos);
				write(arch,info);
				writeln();
				write('CODIGO LOCALIDAD: ');readln(codLocalidad);
			end;
		end;
	end;
	procedure cargarDetalles(var v:vDetalles);
	var
		i:integer;
	begin
		for i:= 0 to N do begin
			writeln('-----DETALLE ',i,' ------');
			rewrite(v[i]);
			cargarDetalle(v[i]);
			close(v[i]);
		end;
	end;
	
	procedure imprimirMaestro (var arch:archMaestro);
	var
		info:informacionMaestro;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,info);
			writeln('CODIGO LOCALIDAD: ',info.codLocalidad);
			writeln('CODIGO CEPA: ',info.codCepa);
			writeln('LOCALIDAD: ',info.localidad);
			writeln('NOMBRE CEPA: ',info.nombreCepa);
			writeln('CASOS ACTIVOS: ',info.casosActivos);
			writeln('CASOS NUEVOS: ',info.casosNuevos);
			writeln('CASOS RECUPERADOS: ',info.casosRecuperados);
			writeln('CASOS FALLECIDOS: ',info.casosFallecidos);
			writeln;
		end;
		close(arch);
	end;
	procedure imprimirDetalle(var arch:archDetalle);
	var
		info:informacionDetalle;
	begin
		while (not EOF(arch)) do begin
			read(arch,info);
			writeln('CODIGO LOCALIDAD: ',info.codLocalidad);
			writeln('CODIGO CEPA: ',info.codCepa);
			writeln('CASOS ACTIVOS: ',info.casosActivos);
			writeln('CASOS NUEVOS: ',info.casosNuevos);
			writeln('CASOS RECUPERADOS: ',info.casosRecuperados);
			writeln('CASOS FALLECIDOS: ',info.casosFallecidos);
			writeln();
		end;
	end;
	procedure imprimirDetalles(var v:vDetalles);
	var
		i:integer;
	begin
		for i:= 0 to N do begin
			writeln('-----DETALLE ',i,' ------');
			reset(v[i]);
			imprimirDetalle(v[i]);
			close(v[i]);
		end;
	end;
var
	op:integer;
begin
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of 
			1:cargarMaestro(maestro);
			2:cargarDetalles(vDet);
			3:imprimirMaestro(maestro);
			4:imprimirDetalles(vDet);
			5:actualizarMaestro(vDet,maestro);
			6:informarLocalidades(maestro);
			else writeln('OPCION INCORRECTA');
		end;
		mostrarOpciones(op);
	end;
	
end;

var
	vDet:vDetalles;
	maestro:archMaestro;
BEGIN
	assign(vDet[0],'detalle0Ej07');
	assign(vDet[1],'detalle1Ej07');
	assign(vDet[2],'detalle2Ej07');
	assign(maestro,'maestroEj07');
	menu(vDet,maestro);
END.

