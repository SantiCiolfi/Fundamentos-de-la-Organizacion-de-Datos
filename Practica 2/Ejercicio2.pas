program untitled;

type
	str = string[20];
	alumno = record
		nombre:str;
		apellido:str;
		codigo:integer;
		cursadas:integer;
		finales:integer;
	end;
	
	alumnoDetalle = record
		codigo:integer;
		aprobo:str;
	end;
	
	archMaestro = file of alumno;
	archDetalle = file of alumnoDetalle;

procedure cargarArchivoMaestro (var arch:archMaestro);
var
	a:alumno;
begin	
	with a do begin
		rewrite(arch);
		write('CODIGO: ');readln(codigo);
		while (a.codigo <> 0) do begin
			write('NOMBRE: ');readln(nombre);
			write('APELLIDO: ');readln(apellido);
			write('CURSADAS: ');readln(cursadas);
			write('FINALES: ');readln(finales);
			write(arch,a);
			writeln();
			write('CODIGO: ');readln(codigo);
		end;
		close(arch);
	end;
end;

procedure cargarDetalle (var arch:archDetalle);
var	
	a:alumnoDetalle;
begin
	with a do begin
		rewrite(arch);
		write('CODIGO: ');readln(codigo);
		while (a.codigo <> 0) do begin
			write('¿QUE APROBO?: ');readln(aprobo);
			write(arch,a);
			writeln();
			write('CODIGO: ');readln(codigo);
		end;
		close(arch);
	end;
end;

//PROBAR
procedure actualizarMaestro(var maestro:archMaestro; var detalle:archDetalle);
	procedure leer(	var archivo: archDetalle; var dato:alumnoDetalle);
	begin
		if (not(EOF(archivo))) then 
			read (archivo, dato)
		else 
			dato.codigo := 9999;
	end;

var
	aDetalle:alumnoDetalle;
	aMaestro:alumno;
	codActual:integer;
begin
	reset(maestro);
	reset(detalle);
	while (not EOF(detalle)) do begin
		read(maestro,aMaestro);
		leer(detalle,aDetalle);
		while (aMaestro.codigo <> aDetalle.codigo) do begin
			read(maestro,aMaestro);
		end;	
		codActual := aMaestro.codigo;
		while (aDetalle.codigo <> 9999) and (codActual = aDetalle.codigo) do begin
			if (aDetalle.aprobo = 'final') then aMaestro.finales := aMaestro.finales + 1
			else aMaestro.cursadas := aMaestro.cursadas + 1;
			leer(detalle,aDetalle); 
		end;
		if (not EOF(detalle)) then
			seek(detalle,filepos(detalle) - 1);
		seek(maestro,filepos(maestro)-1);
		write(maestro,aMaestro);
	end;
	close(maestro);
	close(detalle);
end;

procedure listarATexto (var maestro:archMaestro; var archivoTexto:Text);
var
	a:alumno;
begin
	rewrite(archivoTexto);
	reset(maestro);
	while (not EOF(maestro)) do begin
		read(maestro,a);
		if (a.finales > a.cursadas) then 
			writeln(archivoTexto,a.codigo,' ',a.cursadas,' ',a.finales,' ',a.nombre);
	end;
	close(maestro);
	close(archivoTexto);
end;
	
procedure menu (var maestro:archMaestro; var detalle:archDetalle; var archivoTexto:Text);
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Cargar detalle');
		writeln('3-Imprimir maestro');
		writeln('4-Imprimir detalle');
		writeln('5-Actualizar maestro');
		writeln('6-Listar a texto');
		writeln('0-Finalizar');
		readln(op);
	end;
	procedure imprimirMaestro(var arch:archMaestro);
	var
		a:alumno;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,a);
			writeln('CODIGO: ',a.codigo);
			writeln('NOMBRE: ',a.nombre);
			writeln('APELLIDO: ',a.apellido);
			writeln('CURSADAS: ',a.cursadas);
			writeln('FINALES: ',a.finales);
			writeln();
		end;
		close(arch);
	end;
	procedure imprimirDetalle(var arch:archDetalle);
	var
		a:alumnoDetalle;
	begin
		reset(arch);
		while (not EOF(arch)) do begin
			read(arch,a);
			writeln('CODIGO: ',a.codigo);
			writeln('¿Que aprobo?: ',a.aprobo);
			writeln();
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
	assign(maestro,'alumnosMaestro');
	assign(detalle,'alumnosDetalle');
	assign(archivoTexto,'alumnosTextoEj2.txt');
	menu(maestro,detalle,archivoTexto);
	
END.

