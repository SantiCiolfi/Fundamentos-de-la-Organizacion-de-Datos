program untitled;
const VALOR_ALTO = 'ZZZZ';
type
	str = string[20];
	provincia = record
		nombre:str;
		alfabetizados:integer;
		encuestados:integer;
	end;
	
	agencia = record
		provincia:str;
		codigoLocalidad:integer;
		alfabetizados:integer;
		encuestados:integer;
	end;
	
	archDetalle = file of agencia;
	archMaestro = file of provincia;
	
procedure actualizarMaestro (var maestro:archMaestro; var det1,det2:archDetalle);
	procedure leer (var arch:archDetalle; var dato:agencia);
	begin
		if (not EOF(arch)) then	read(arch,dato)
		else dato.provincia := VALOR_ALTO;
	end;
	
	procedure minimo (var r1,r2:agencia; var min:agencia; var det1,det2:archDetalle);
	begin
		if (r1.provincia <= r2.provincia) then begin
			min := r1;
			leer(det1,r1);
		end
		else begin 
			min := r2;
			leer(det2,r2);
		end;
	end;
var
	rMae:provincia;
	min:agencia;
	r1,r2:agencia;
	provActual:str;
begin
	reset(det1);
	reset(det2);
	reset(maestro);
	
	leer(det1,r1);
	leer(det2,r2);
	minimo(r1,r2,min,det1,det2);
	while (min.provincia <> VALOR_ALTO) do begin
		read(maestro,rMae);
		
		while (rMae.nombre <> min.provincia) do 
			read(maestro,rMae);
			
		provActual := rMae.nombre;
		while (min.provincia <> VALOR_ALTO) and (provActual = min.provincia)do begin
			rMae.alfabetizados := rMae.alfabetizados + min.alfabetizados;
			rMae.encuestados := rMae.encuestados + min.encuestados;
			minimo(r1,r2,min,det1,det2);
		end;
		
		seek(maestro,filepos(maestro)-1);
		write(maestro,rMae);
	end;
	
	close(det1);
	close(det2);
	close(maestro);
end;


procedure menu (var maestro:archMaestro; var det1,det2:archDetalle);
	procedure cargarArchivoMaestro (var arch:archMaestro);
	var
		p:provincia;
	begin	
		with p do begin
			rewrite(arch);
			write('NOMBRE: ');readln(nombre);
			while (nombre <> '') do begin
				write('ALFABETIZADOS: ');readln(alfabetizados);
				write('ENCUESTADOS: ');readln(encuestados);
				write(arch,p);
				writeln();
				write('NOMBRE: ');readln(nombre);
			end;
			close(arch);
		end;
	end;

	procedure cargarDetalle1 (var arch:archDetalle);
	var	
		a:agencia;
	begin
		with a do begin
			rewrite(arch);
			write('NOMBRE: ');readln(provincia);
			while (provincia <> '') do begin
				write('CODIGO LOCALIDAD: ');readln(codigoLocalidad);
				write('ALFABETIZADOS: ');readln(alfabetizados);
				write('ENCUESTADOS: ');readln(encuestados);
				write(arch,a);
				writeln();
				write('NOMBRE: ');readln(provincia);
			end;
			close(arch);
		end;
	end;
	procedure cargarDetalle2 (var arch:archDetalle);
	var	
		a:agencia;
	begin
		with a do begin
			rewrite(arch);
			write('NOMBRE: ');readln(provincia);
			while (provincia <> '') do begin
				write('CODIGO LOCALIDAD: ');readln(codigoLocalidad);
				write('ALFABETIZADOS: ');readln(alfabetizados);
				write('ENCUESTADOS: ');readln(encuestados);
				write(arch,a);
				writeln();
				write('NOMBRE: ');readln(provincia);
			end;
			close(arch);
		end;
	end;
	
	procedure mostrarOpciones (var op:integer);
	begin
		writeln('1-Cargar maestro');
		writeln('2-Cargar detalle1');
		writeln('3-Cargar detalle2');
		writeln('4-Imprimir maestro');
		writeln('5-Imprimir detalle1');
		writeln('6-Imprimir detalle2');
		writeln('7-Actualizar maestro');
		writeln('0-Finalizar');
		write('OPCION ELEGIDA-------> ');readln(op);
	end;
	procedure imprimirMaestro(var arch:archMaestro);
	var
		p:provincia;
	begin
		reset(arch);
		with p do begin
			while (not EOF(arch)) do begin
				read(arch,p);
				writeln('NOMBRE: ',nombre);
				writeln('ALFABETIZADOS: ',alfabetizados);
				writeln('ENCUESTADOS: ',encuestados);
				writeln();
			end;
		end;
		close(arch);
	end;
	procedure imprimirDetalle1(var arch:archDetalle);
	var
		a:agencia;
	begin
		reset(arch);
		with a do begin
			while (not EOF(arch)) do begin
				read(arch,a);
				writeln('CODIGO: ',codigoLocalidad);
				writeln('NOMBRE: ',provincia);
				writeln('ALFABETIZADOS: ',alfabetizados);
				writeln('ENCUESTADOS: ',encuestados);
			
				writeln();
			end;
		end;
		close(arch);
	end;
	procedure imprimirDetalle2(var arch:archDetalle);
	var
		a:agencia;
	begin
		reset(arch);
		with a do begin
			while (not EOF(arch)) do begin
				read(arch,a);
				writeln('CODIGO: ',codigoLocalidad);
				writeln('NOMBRE: ',provincia);
				writeln('ALFABETIZADOS: ',alfabetizados);
				writeln('ENCUESTADOS: ',encuestados);
			
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
			2: cargarDetalle1(det1);
			3: cargarDetalle2(det2);
			4: imprimirMaestro(maestro);
			5: imprimirDetalle1(det1);
			6: imprimirDetalle2(det2);
			7: actualizarMaestro(maestro,det1,det2);
			else writeln('Opcion incorrecta!');
		end;
		mostrarOpciones(op);
	end;	
end;

var
	det1,det2:archDetalle;
	maestro:archMaestro;
BEGIN
	assign(det1,'detalleAgencia1');
	assign(det2,'detalleAgencia2');
	assign(maestro,'maestroProvincia');
	menu(maestro,det1,det2);
	
END.

