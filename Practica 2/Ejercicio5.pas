program ejercicio;
const VALOR_ALTO = 999;
	N = 3;
type
	str = string[20];
	productoMaestro = record
		codigo:integer;
		nombre:str;
		descripcion:str;
		stockDisponible:integer;
		stockMinimo:integer;
		precio:real
	end;
	
	productoDetalle = record
		codigo:integer;
		cantVendida:integer;
	end;
	
	archDetalle = file of productoDetalle;
	archMaestro = file of productoMaestro;
	
	vDetalles = array [0..N] of archDetalle;
	vRegistros = array [0..N] of productoDetalle;


procedure actualizarMaestro (var v:vDetalles; var maestro:archMaestro; var archivoTexto:Text);
	procedure leer (var arch:archDetalle; var dato:productoDetalle);
	begin
		if (not EOF(arch)) then 	
			read(arch,dato)
		else
			dato.codigo := VALOR_ALTO;
	end;
	procedure minimo (var v:vDetalles; var vReg:vRegistros; var min:productoDetalle);
	var
		i:integer;
		indiceMin:integer;
	begin
		min.codigo := VALOR_ALTO;
		for i:=0 to N do begin
			if (vReg[i].codigo <= min.codigo) then begin
				min.codigo := vReg[i].codigo;
				min.cantVendida:= vReg[i].cantVendida;
				indiceMin:=i;
			end;
		end;
		leer(v[indiceMin],vReg[indiceMin]);	
	end;
	procedure exportarATexto (rMaestro:productoMaestro; var archivoTexto:Text);
	begin
		writeln(archivoTexto,rMaestro.codigo,' ',rMaestro.precio:0:0,' ',rMaestro.stockDisponible,' ',rMaestro.stockMinimo,' ',rMaestro.nombre);
	end;
	
var
	i,codActual:integer;
	vReg:vRegistros;
	min:productoDetalle;
	rMaestro:productoMaestro;
begin
	rewrite(archivoTexto);
	for i:= 0 to N do begin
		reset(v[i]);
		leer(v[i],vReg[i]);
	end;
	reset(maestro);
	minimo(v,vReg,min);
	while (min.codigo <> VALOR_ALTO) do begin
		read(maestro,rMaestro);
		while (min.codigo <> rMaestro.codigo) do 
			read(maestro,rMaestro);
		codActual := rMaestro.codigo;
		while (min.codigo <> VALOR_ALTO) and (codActual = min.codigo) do begin
			rMaestro.stockDisponible := rMaestro.stockDisponible - min.cantVendida;
			minimo(v,vReg,min);
		end;
		if (rMaestro.stockDisponible < rMaestro.stockMinimo) then
			exportarATexto(rMaestro,archivoTexto);
		seek(maestro,filepos(maestro)-1);
		write(maestro,rMaestro);
	end;
	close(maestro);
	for i:= 0 to N do begin
		close(v[i]);
	end;
	close(archivoTexto);
end;

procedure menu (var vDet:vDetalles; var maestro: archMaestro; var archivoTexto:Text);
	
	procedure cargarDetalles (var v:vDetalles);
		procedure cargarDetalle (var arch:archDetalle);
		var
			p:productoDetalle;
		begin
			rewrite(arch);
			with p do begin
				write('CODIGO: ');readln(codigo);
				while (codigo <> 0) do begin
					write('CANTIDAD VENDIDA: ');readln(cantVendida);
					write(arch,p);
					write('CODIGO: ');readln(codigo);
				end;
			end;	
			close(arch)
		end;
	var
		i:integer;
	begin
		for i:= 0 to N do begin
			writeln('---- CARGA DET',i,' -----');
			cargarDetalle(v[i]);
		end;
	end;


	procedure imprimirOpciones (var op:integer);
	begin
		writeln('1-Cargar detalles');
		writeln('2-Cargar maestro');
		writeln('3-Imprimir detalles');
		writeln('4-Imprimir maestro');
		writeln('5-Actualizar maestro');
		writeln('0-Finalizar');
		write('OPCION ELEGIDA: -----> ');
		readln(op);
	end;
	procedure cargarArchivoMaestro (var arch:archMaestro);
	var
		p:productoMaestro;
	begin	
		with p do begin
			rewrite(arch);
			write('NOMBRE: ');readln(nombre);
			while (nombre <> '') do begin
				write('CODIGO: ');readln(codigo);
				write('DESCRIPCION: ');readln(descripcion);
				write('STOCK DISPONIBLE: ');readln(stockDisponible);
				write('STOCK MINIMO: ');readln(stockMinimo);
				write('PRECIO: ');readln(precio);
				write(arch,p);
				writeln();
				write('NOMBRE: ');readln(nombre);
			end;
			close(arch);
		end;
	end;
	procedure imprimirMaestro(var arch:archMaestro);
	var
		p:productoMaestro;
	begin
		reset(arch);
		with p do begin
			while (not EOF(arch)) do begin
				read(arch,p);
				writeln('CODIGO: ',codigo);
				writeln('NOMBRE: ',nombre);
				writeln('STOCK DISPONIBLE: ',stockDisponible);
				writeln('STOCK MINIMO: ',stockMinimo);
				writeln('PRECIO: ',precio:0:0);
				writeln();
			end;
		end;
		close(arch);
	end;
	procedure imprimirDetalles(var v:vDetalles);
		procedure imprimirDatos(dato:productoDetalle);
		begin
			with dato do begin
				writeln('CODIGO: ',codigo);
				writeln('CANTIDAD VENDIDA: ',cantVendida);
				writeln();
			end;
		end;
	var
		p:productoDetalle;
		i:integer;
	begin	
		for i:= 0 to N do begin
				
			reset(v[i]);
			if (EOF(v[i])) then writeln('EOAREA');
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
			1:	cargarDetalles(vDet);
			2:	cargarArchivoMaestro(maestro);
			3:	imprimirDetalles(vDet);
			4:	imprimirMaestro(maestro);
			5:	actualizarMaestro(vDet,maestro,archivoTexto);
			else writeln('BURRINI APRETA BIEN');
		end;
		imprimirOpciones(op);
	end;
end;

//FALTA MENU, CARGAR DETALLE, CARGAR MAESTRO

var
	vDet:vDetalles;
	maestro:archMaestro;
	archivoTexto:Text;
BEGIN 
	//CONSULTAR: COMO REALIZAR EL FOR..ASSIGN N ARCHIVOS
	assign(maestro,'maestroProductosEJ5');
	assign(vDet[0],'detalleEJ1');
	assign(vDet[1],'detalleEJ2');
	assign(vDet[2],'detalleEJ3');
	assign(vDet[3],'detalleEJ4');
	assign(archivoTexto,'archivoTextoEJ05.txt');
	menu(vDet,maestro,archivoTexto);
END.

