{
4. Dada la siguiente estructura:
type
	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	
	tArchFlores = file of reg_flor;
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
* 
a. Implemente el siguiente módulo:
Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente
procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
* 
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.
}


program ejercicio4;
const
	VA=9999;
type
	regFlor = record
		nombre: String[45];
		codigo:integer;
	end;
	archMae = file of regFlor;
	
procedure menu(var mae:archMae);

	procedure cargarMaestro(var arch:archMae);
	var
		info:regFlor;
	begin	
		with info do begin
			rewrite(arch);
			info.codigo:=0;
			write(arch,info);
			write('CODIGO: ');readln(codigo);
			while (codigo <> 0) do begin
				write('NOMBRE: ');readln(nombre);
				write(arch,info);
				writeln();
				write('CODIGO: ');readln(codigo);
			end;
			close(arch);
		end;
	end;
	
	procedure imprimirMaestro(var arch:archMae);
	var
		info:regFlor;
	begin
		reset(arch);
		with info do begin
			while (not EOF(arch)) do begin
				read(arch,info);
				writeln('CODIGO: ', codigo);
				writeln('NOMBRE: ', nombre);
				writeln();
			end;
		end;
		close(arch);
	end;
	
	procedure darDeAltaFlor(var mae:archMae);
	var
		reg:regFlor;
		aux:regFlor;
		nueN:regFlor;
	begin
		write('CODIGO: ');readln(nueN.codigo);
		write('NOMBRE: ');readln(nueN.nombre);
		reset(mae);
		read(mae,reg);
		if(reg.codigo = 0) then begin
			seek(mae,filesize(mae));
			write(mae, nueN);
		end
		else begin
			seek(mae,(-1*reg.codigo)); //me ubico en el ultimo registro borrado
			read(mae, aux); //cargo el ultimo registro borrado en aux
			seek(mae, filePos(mae)-1); //retrocedo hasta el registro borrado
			write(mae, nueN); //escribo en el registro borrado la nueva info
			seek(mae, 0);//voy a la posicion iniciar
			write(mae, aux); //actualizo la cabecera de la lista con aux
		end;
		close(mae);
	end;
	
	procedure darDeBajaFlor (var mae:archMae);
		
		procedure leer(var mae:archMae; var regMae:regFlor);
		begin
			if(not EOF(mae))then begin
				read(mae,regMae);
			end
			else
				regMae.codigo:=VA;
		end;
	
	var
		posNegativa:integer;
		cabe:regFlor;
		codigoAEliminar:integer;
		reg:regFlor;
		pos:integer;
	begin
		reset(mae);
		write('ingrese el codigo a eliminar: ');readln(codigoAEliminar);
		leer(mae, reg);
		while (reg.codigo <> codigoAEliminar)  and (reg.codigo <> VA) do begin
			leer(mae, reg);
		end;
		if(reg.codigo<>VA)then begin
			pos:=filePos(mae)-1; //obtengo la posicion
			posNegativa:=pos * -1; //obtengo la posicion negativa
			reg.codigo:=posNegativa;
			seek(mae, 0); //voy a la cabecera
			read(mae, cabe); //tomo el registro de la cabecera
			seek(mae, 0); //vuelvo a la cabecera
			write(mae, reg);//actualizo la cabecera
			seek(mae,pos); //me posiciono en el registro a eliminar
			write(mae, cabe); //cargo lo que tenia la cabecera
		end; 
		close(mae);
	end;
	
	procedure listarFlores(var mae:archMae);
	var
		archivo:text;
		reg:regFlor;
	begin
		assign(archivo,'ListadoFlores.txt');
		rewrite(archivo);
		reset(mae);
		while (not EOF(mae)) do begin
			read(mae, reg);
			if(reg.codigo > 0)then begin
				writeln(archivo, reg.codigo, ' ', reg.nombre);
			end;
		end;
		close(mae);
		close(archivo);
	end;
	
var
	op:integer;
begin
	op:=VA;
	while(op <> 0)do begin
		writeln('1) cargar maestro');
		writeln('2) imprimir maestro');
		writeln('3) dar de alta Flor');
		writeln('4) dar de baja Flor');
		writeln('5) listar flores');
		write('ingrese una opcion: '); readln(op);
		writeln('-----------------------------------------------------------------------------');
		case op of
			1:cargarMaestro(mae);
			2:imprimirMaestro(mae);
			3:darDeAltaFlor(mae);
			4:darDeBajaFlor(mae);
			5:listarFlores(mae);
		end;
	end;
end;
	
var
	mae:archMae;
BEGIN
	assign(mae, 'Flores.dat');
	menu(mae);
END.

