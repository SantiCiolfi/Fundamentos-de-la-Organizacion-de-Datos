program untitled;
const 
	N = 4;
	CODIGO_ALTO = 999;
	FECHA_ALTA = 999;
type
	informacionDetalle = record
		codigo:integer;
		fecha:integer;
		tiempo:integer;
	end;
	
	informacionMaestro = record
		codigo:integer;
		fecha:integer;
		tiempoTotal:integer;
	end;
	
	
	archDetalle = file of informacionDetalle;
	archMaestro = file of informacionMaestro;
	
	vRegistros = array [0..N] of informacionDetalle;
	vDetalles = array [0..N] of archDetalle;

procedure cargarDetalles (var v:vDetalles);
var
	i:Integer;
	info:informacionDetalle;
begin
	for i:= 0 to N do begin
		rewrite(v[i]);
		writeln('------DETALLE ',i,' ------');
		with info do begin
			write('Codigo usuario: ');readln(codigo);
			while (codigo <> 0) do begin
				write('Fecha: ');readln(fecha);
				write('Tiempo: ');readln(tiempo);
				write(v[i],info);
				write('Codigo usuario: ');readln(codigo);
			end;
		end;
		close(v[i]);
	end;
end;

procedure leer (var arch:archDetalle; var dato:informacionDetalle);
begin
	if (not EOF(arch)) then	read(arch,dato)
	else begin
		dato.codigo := CODIGO_ALTO;
		dato.fecha := FECHA_ALTA;
	end;
end;

procedure minimo (var v:vDetalles; var vReg:vRegistros; var min:informacionDetalle);
var
	i:integer;
	indiceMin:integer;
begin
	min.codigo := CODIGO_ALTO;
	min.fecha := FECHA_ALTA;
	for i:= 0 to N do begin
		if (vReg[i].codigo <= min.codigo) and (vReg[i].fecha <= min.fecha) then begin
			min := vReg[i];
			indiceMin:= i;
		end;	
	end;
	leer(v[indiceMin],vReg[indiceMin]);
end;	

procedure cargarMaestro (var v:vDetalles; var maestro:archMaestro);
var
	regMaestro:informacionMaestro;
	min:informacionDetalle;
	codActual,fechaActual:integer;
	vReg:vRegistros;
	i:integer;
	acumHoras:integer;
begin
		for i:= 0 to N do begin
		reset(v[i]);
		leer(v[i],vReg[i]);
	end;
	rewrite(maestro);
	minimo(v,vReg,min);
	while (min.codigo <> 999) and (min.fecha <> 999) do begin 
		acumHoras:=0;
		regMaestro.codigo := min.codigo;
		regMaestro.fecha := min.fecha;
		codActual := min.codigo;
		fechaActual := min.fecha;
		while (codActual = min.codigo) and (fechaActual = min.fecha) do begin
			acumHoras := acumHoras + min.tiempo;
			minimo(v,vReg,min);
		end;
		regMaestro.tiempoTotal := acumHoras;
		write(maestro,regMaestro);
		writeln('CODIGO: ');
	end;
	for i:= 0 to N do begin
		close(v[i]);
	end;
	close(maestro);
end;

procedure menu (var vDet:vDetalles; var maestro:archMaestro);
	procedure imprimirOpciones (var op:integer);
	begin
		writeln('1-Cargar detalles');
		writeln('2-Imprimir detalles');
		writeln('3-Imprimir maestro');
		writeln('4-Cargar maestro');
		writeln('0-Finalizar');
		write('OPCION ELEGIDA: -----> ');
		readln(op);
	end;
	procedure imprimirMaestro(var arch:archMaestro);
	var
		p:informacionMaestro;
	begin
		reset(arch);
		with p do begin
			while (not EOF(arch)) do begin
				read(arch,p);
				writeln('CODIGO: ',codigo);
				writeln('FECHA: ',fecha);
				writeln('TOTAL HORAS: ',tiempoTotal);
				writeln();
			end;
		end;
		close(arch);
	end;
	
	procedure imprimirDetalles(var v:vDetalles);
		procedure imprimirDatos(dato:informacionDetalle);
		begin
			with dato do begin
				writeln('CODIGO: ',codigo);
				writeln('FECHA: ',fecha);
				writeln('CANTIDAD VENDIDA: ',tiempo);
				writeln();
			end;
		end;
	var
		p:informacionDetalle;
		i:integer;
	begin	
		for i:= 0 to N do begin	
			reset(v[i]);
			while (not EOF(v[i])) do begin
				writeln('------DET',i,' -----');
				read(v[i],p);
				imprimirDatos(p);
			end;
			close(v[i]);
		end;
	end;
var 	
	op:integer;
begin
	imprimirOpciones(op);
	while (op <> 0) do begin
		case op of 
			1:cargarDetalles(vDet);
			2:imprimirDetalles(vDet);
			3:imprimirMaestro(maestro);
			4:cargarMaestro(vDet,maestro);
			else writeln('OPA');
		end;
		imprimirOpciones(op);
	end;
end;

var
	vDet:vDetalles;
	maestro:archMaestro;
BEGIN
	assign(vDet[0],'detalle0EJ6');
	assign(vDet[1],'detalle1EJ6');
	assign(vDet[2],'detalle2EJ6');
	assign(vDet[3],'detalle3EJ6');
	assign(vDet[4],'detalle4EJ6');
	assign(maestro,'maestroEJ6');
	menu(vDet,maestro);
	
END.

