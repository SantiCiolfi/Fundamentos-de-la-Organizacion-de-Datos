program untitled;
type	
	str = string[20];
	venta = record
		codCliente:integer;
		nombreYapellido:str;
		anio:integer;
		mes:integer;
		dia:integer;
		monto:real;
	end;
	
	archMaestro = file of venta;
	
procedure cargarMaestro (var arch:archMaestro);
var
	v:venta;
begin
	rewrite(arch);
	with v do begin
		write('CODIGO CLIENTE: ');readln(codCliente);
		while (codCliente <> 0) do begin
			write('NOMBRE Y APELLIDO: ');readln(nombreYapellido);
			write('ANIO: ');readln(anio);
			write('MES: ');readln(mes);
			write('DIA: ');readln(dia);
			write('MONTO: ');readln(monto);
			write(arch,v);
			writeln();
			write('CODIGO CLIENTE: ');readln(codCliente);
		end;
	end;
	close(arch);
end;	

procedure imprimirMaestro (var arch:archMaestro);
var
	info:venta;
begin
	reset(arch);
	while (not EOF(arch)) do begin
		read(arch,info);
		writeln('CODIGO CLIENTE: ',info.codCliente);
		writeln('NOMBRE Y APELLIDO: ',info.nombreYapellido);
		writeln('ANIO: ',info.anio);
		writeln('MES: ',info.mes);
		writeln('DIA: ',info.dia);
		writeln('MONTO: ',info.monto:2:0);
		writeln;
	end;
	close(arch);
end;

procedure procesarMaestro (var maestro:archMaestro);
	procedure leer (var arch:archMaestro; var dato:venta);
	begin
		if (not EOF(arch)) then read(arch,dato)
		else dato.codCliente := 9999;
	end;
var
	reg:venta;
	totalEmpresa:real;
	totalClienteMes:real;
	totalClienteAnio:real;
	codActual:integer;
	anioActual:integer;
	mesActual:integer;
begin
	reset(maestro);
	totalEmpresa:=0;
	leer(maestro,reg);
	while (reg.codCliente <> 9999) do begin
		codActual := reg.codCliente;
		while (codActual = reg.codCliente) do begin
			anioActual := reg.anio;
			totalClienteAnio:=0;
			while (codActual = reg.codCliente)  and (anioActual = reg.anio) do begin
				mesActual := reg.mes;
				totalClienteMes:=0;
				while (codActual = reg.codCliente) and (anioActual = reg.anio) and (mesActual = reg.mes) do begin
					if (reg.monto <> 0) then
						totalClienteMes:= totalClienteMes + reg.monto;
					leer(maestro,reg);
				end;
				writeln('El total del cliente ',codActual,' en el MES ', mesActual ,' es: ',totalClienteMes:0:0);
				totalClienteAnio := totalClienteAnio + totalClienteMes;
			end;
			writeln('El total del cliente ',codActual,' en el ANIO ', anioActual ,' es: ',totalClienteAnio:0:0);
			totalEmpresa:= totalEmpresa + totalClienteAnio;
		end;
	end;
	writeln('Total de la empresa: ',totalEmpresa:0:0);
	close(maestro);
end;
var
	maestro:archMaestro;
	rta:str;
BEGIN
	assign(maestro,'maestroEJ8');
	write('Queres reescribir el MAESTRO? ');read(rta);
	if (rta = 'SI') then 
		cargarMaestro(maestro);
	imprimirMaestro(maestro);
	procesarMaestro(maestro);
	
END.

