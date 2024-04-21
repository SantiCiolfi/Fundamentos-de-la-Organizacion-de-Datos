{
6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
 ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.
}


program untitled;

const
	VA=9999;

type
	
	prenda=record
		cod:integer;
		des:string;
		colores:string;
		tipo:string;
		stock:integer; //valor de baja
		precio:real;
	end;
	
	regDetalle=record
		cod:integer;
	end;
	
	archMae=file of prenda;
	archDet=file of regDetalle;
	archAux=file of prenda;
	
procedure menu(var mae:archMae; var det:archDet; var aux:archAux);

	procedure cargarMaestro(var arch:archMae);
	var
		info:prenda;
	begin	
		with info do begin
			rewrite(arch);
			write('CODIGO: ');readln(cod);
			while (cod <> 0) do begin
				write('STOCK: ');readln(stock);
				write(arch,info);
				writeln();
				write('CODIGO: ');readln(cod);
			end;
			close(arch);
		end;
	end;
	
	procedure imprimirMaestro(var arch:archMae);
	var
		info:prenda;
	begin
		reset(arch);
		with info do begin
			while (not EOF(arch)) do begin
				read(arch,info);
				writeln('CODIGO: ', cod);
				writeln('STOCK: ', stock);
				writeln();
			end;
		end;
		close(arch);
	end;
	
	procedure cargarDetalle(var arch:archDet);
	var
		info:regDetalle;
	begin	
		with info do begin
			rewrite(arch);
			write('CODIGO: ');readln(cod);
			while (cod <> 0) do begin
				write(arch,info);
				writeln();
				write('CODIGO: ');readln(cod);
			end;
			close(arch);
		end;
	end;
	
	procedure imprimirDetalle(var arch:archDet);
	var
		info:regDetalle;
	begin
		reset(arch);
		with info do begin
			while (not EOF(arch)) do begin
				read(arch,info);
				writeln('CODIGO: ', cod);
				writeln();
			end;
		end;
		close(arch);
	end;
	
	procedure actualizarMaestro(var mae:archMae; var det:archDet);
	
		procedure leerDet(var det:archDet; var reg:regDetalle);
		begin
			if(not EOF(det))then begin
				read(det,reg);
			end
			else
				reg.cod:=VA;
		end;
		
		procedure leerMae(var det:archMae; var reg:prenda);
		begin
			if(not EOF(mae))then begin
				read(mae,reg);
			end
			else
				reg.cod:=VA;
		end;
	
	var
		regMae:prenda;
		regDet:regDetalle;
	begin
		reset(mae);
		leerMae(mae,regMae); //leo el primero
		while(regMae.cod <> VA) do begin
			reset(det); //lo reseteo por cada posicion del maestro
			leerDet(det, regDet); //leo el primero
			while(regDet.cod <> VA)do begin
				if(regMae.cod = regDet.cod)then begin
					regMae.stock:=regMae.stock*-1;
					seek(mae, filepos(mae)-1);
					write(mae, regMae);
					break;
				end;
				leerDet(det, regDet); //leo cuando termine la verificacion del registro anterior
			end;
			leerMae(mae,regMae); //leo cuando encuentre o termine el detalle
			close(det); //tengo que cerrar el detalle en cada ciclo
		end;
		close(mae); //cierro por ultimo el maestro
	end;
	
	procedure clonarMaestro(var mae:archMae; var aux:archAux);
	var
		reg:prenda;
	begin
		assign(aux, 'prendaAux');
		reset(mae);
		rewrite(aux);
		while(not EOF(mae))do begin
			read(mae, reg);
			if(reg.stock >  0)then begin
				write(aux, reg);
			end;
		end;
		close(aux);
		close(mae);
		Erase(mae); // Borrar el archivo maestro original
		rename(aux, 'prenda');
	end;
	
var
	op:integer;
begin
	op:=VA;
	while(op <> 0)do begin
		writeln('1) cargar maestro');
		writeln('2) imprimir maestro');
		writeln('3) cargar detalle');
		writeln('4) imprimir detalle');
		writeln('5) actualizar maestro');
		writeln('6) clonar maestro');
		write('ingrese una opcion: '); readln(op);
		writeln('-----------------------------------------------------------------------------');
		case op of
			1:cargarMaestro(mae);
			2:imprimirMaestro(mae);
			3:cargarDetalle(det);
			4:imprimirDetalle(det);
			5:actualizarMaestro(mae,det);
			6:clonarMaestro(mae, aux);
		end;
	end;
end;
	
var
	mae:archMae;
	det:archDet;
	aux:archAux;
BEGIN
	assign(mae, 'prenda');
	assign(det, 'prendaDetalle');
	menu(mae, det, aux);
END.

