program untitled;
type
	str = string[20];
	producto = record
		codigo:integer;
		nombre:str;
		precio:real;
		stockActual:integer;
		stockMinimo:integer;
	end;
	
	archMaestro = file of producto;
	
	venta = record
		codigo:integer;
		unidadesVendidas:integer;
	end;
	
	archDetalle = file of venta;
	
procedure actualizarMaestro (var maestro:archMaestro; var detalle:archDetalle);
	procedure leer (var arch:archDetalle; var dato:venta);
	begin
		if (not EOF(arch)) then
			read(arch,dato)
		else
			dato.codigo := 9999;
	end;
var
	p:producto;
	v:venta;
	codActual:integer;
begin
	reset(maestro);
	reset(detalle);
	while (not EOF(detalle)) do begin
		read(maestro,p);	//leo maestro
		leer(detalle,v);	//si no llegue al final del detalle --> leo 
		while (v.codigo <> p.codigo) do begin //mientras sean distintos ---> avanzo
			read(maestro,p);
		end;
		//encontre iguales 
		codActual := p.codigo; // podria ser tmb del detalle pq son iguales	
		while (v.codigo <> 9999) and (codActual = v.codigo) do begin
			p.stockActual:= p.stockActual - v.unidadesVendidas; //descuento las ventas del stock dispo
			leer(detalle,v);	//leo el siguiente 
		end;
		if (not EOF(detalle)) then //si no llegue al final del detalle 
			seek(detalle,filepos(detalle)-1);	//acomodo el puntero en la pos anterior 
		seek(maestro,filepos(maestro)-1);	//acomodo el puntero en la pos anterior
		write(maestro,p);	//escribo sobre el registro correspondiente 
	end;
	close(detalle);
	close(maestro);
end;

procedure listarATexto (var maestro:archMaestro; var archivoTexto:Text);
var
	p:producto;
begin
	rewrite(archivoTexto);
	reset(maestro);
	while (not EOF(maestro)) do begin
		read(maestro,p);
		if (p.stockActual < p.stockMinimo) then writeln(archivoTexto,p.codigo,' ',p.precio:2:0,' ',p.nombre);
	end;
	close(maestro);
	close(archivoTexto);
end;
	
procedure menu (var maestro:archMaestro; var detalle:archDetalle; var archivoTexto:Text);
	procedure cargarArchivoMaestro (var arch:archMaestro);
	var
		p:producto;
	begin	
		with p do begin
			rewrite(arch);
			write('CODIGO: ');readln(codigo);
			while (codigo <> 0) do begin
				write('NOMBRE: ');readln(nombre);
				write('PRECIO: ');readln(precio);
				write('STOCK ACTUAL: ');readln(stockActual);
				write('STOCK MINIMO: ');readln(stockMinimo);
				write(arch,p);
				writeln();
				write('CODIGO: ');readln(codigo);
			end;
			close(arch);
		end;
	end;

	procedure cargarDetalle (var arch:archDetalle);
	var	
		v:venta;
	begin
		with v do begin
			rewrite(arch);
			write('CODIGO: ');readln(codigo);
			while (codigo <> 0) do begin
				write('UNIDADES VENDIDAS: ');readln(unidadesVendidas);
				write(arch,v);
				writeln();
				write('CODIGO: ');readln(codigo);
			end;
			close(arch);
		end;
	end;
	
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Cargar detalle');
		writeln('3-Imprimir maestro');
		writeln('4-Imprimir detalle');
		writeln('5-Actualizar maestro');
		writeln('6-Listar a texto');
		writeln('0-Finalizar');
		write('OPCION ELEGIDA-------> ');readln(op);
	end;
	procedure imprimirMaestro(var arch:archMaestro);
	var
		p:producto;
	begin
		reset(arch);
		with p do begin
			while (not EOF(arch)) do begin
				read(arch,p);
				writeln('CODIGO: ',codigo);
				writeln('NOMBRE: ',nombre);
				writeln('PRECIO: ',precio);
				writeln('STOCK MINIMO: ',stockMinimo);
				writeln('STOCK ACTUAL: ',stockActual);
				writeln();
			end;
		end;
		close(arch);
	end;
	procedure imprimirDetalle(var arch:archDetalle);
	var
		v:venta;
	begin
		reset(arch);
		with v do begin
			while (not EOF(arch)) do begin
				read(arch,v);
				writeln('CODIGO: ',codigo);
				writeln('UNIDADES VENDIDAS: ',unidadesVendidas);
			
				writeln();
			end;
		end;
		close(arch);
	end;
	
var
	op:integer;
begin
	mostrarOpciones(op);
	while (op <> 0) do begin
		case op of
			1: cargarArchivoMaestro(maestro);
			2: cargarDetalle(detalle);
			3: imprimirMaestro(maestro);
			4: imprimirDetalle(detalle);
			5: actualizarMaestro(maestro,detalle);
			6: listarATexto(maestro,archivoTexto);
			else writeln('Opcion incorrecta!');
		end;
		mostrarOpciones(op);

	end;	
end;

var
	maestro:archMaestro;
	detalle:archDetalle;
	archivoTexto:Text;
BEGIN
	assign(maestro,'maestroProductos');
	assign(detalle,'detalleVentas');
	assign(archivoTexto,'stock_minimo.txt');
	menu(maestro,detalle,archivoTexto);
	
	
END.

