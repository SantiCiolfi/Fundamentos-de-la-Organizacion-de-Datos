program untitled;
const
	VALOR_ALTO = 999;
type	
	str = string[20];
	empleado = record
		cod:integer;
		nombre:str;
		monto:real;
	end;
	
	archivo = file of empleado;
	

procedure cargarArchivo (var arch:archivo);
var
	e:empleado;
begin
	rewrite(arch);
	with e do begin
		write('CODIGO: ');readln(cod);
		while (cod <> 0) do begin
			write('NOMBRE: ');readln(nombre);
			write('MONTO: ');readln(monto);
			write(arch,e);
			writeln;
			write('CODIGO: ');readln(cod);	
		end;
	end;
	close(arch);
end; 

procedure imprimirArchivo (var arch:archivo);
var
	e:empleado;
begin
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,e);
		writeln('CODIGO: ',e.cod);
		writeln('NOMBRE: ',e.nombre);
		writeln('MONTO: ',e.monto:0:0);
		writeln;
	end;
	close(arch);
end;

procedure compactar (var arch:archivo;var archComprimido:archivo);
	procedure leer (var arch:archivo; var dato:empleado);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.cod := VALOR_ALTO;
	end;
var
	eActual:empleado;
	e:empleado;
	total:real;
begin
	rewrite(archComprimido);
	reset(arch);
	leer(arch,e);
	while (e.cod <> VALOR_ALTO) do begin
		eActual:=e;
		total:=0;
		while (eActual.cod = e.cod) do begin
			total := total + e.monto;
			leer(arch,e);
		end;
		eActual.monto := total;
		write(archComprimido,eActual);
	end;
	close(arch);
	close(archComprimido);
end;

var
	arch:archivo;
	archComprimido:archivo;
	rta:str;
BEGIN
	assign(arch,'archivoEJ1');
	assign(archComprimido,'archivoComprimidoEJ1');
	
	write('QUERES CARGAR ARCH? ');readln(rta);
	if (rta = 'SI') then begin
		cargarArchivo(arch);
	end;
	imprimirArchivo(arch);
	compactar(arch,archComprimido);
	imprimirArchivo(archComprimido);
	
END.

