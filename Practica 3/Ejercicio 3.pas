{
3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
* 
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
* 
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
* 
	i. Dar de alta una novela leyendo la información desde teclado. Para
	esta operación, en caso de ser posible, deberá recuperarse el
	espacio libre. Es decir, si en el campo correspondiente al código de
	novela del registro cabecera hay un valor negativo, por ejemplo -5,
	se debe leer el registro en la posición 5, copiarlo en la posición 0
	(actualizar la lista de espacio libre) y grabar el nuevo registro en la
	posición 5. Con el valor 0 (cero) en el registro cabecera se indica
	que no hay espacio libre.
	* 
	ii. Modificar los datos de una novela leyendo la información desde
	teclado. El código de novela no puede ser modificado.
	* 
	iii. Eliminar una novela cuyo código es ingresado por teclado. Por
	ejemplo, si se da de baja un registro en la posición 8, en el campo
	código de novela del registro cabecera deberá figurar -8, y en el
	registro en la posición 8 debe copiarse el antiguo registro cabecera.
* 
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
* 
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.
}


program ejercicio3;
const
	VA=9999;
type
	novela=record
		cod:integer;
		genero:string;
		nombre:string;
		duracion:integer;
		director:string;
		precio:real;
	end;
	
	archMae=file of novela;

procedure menu(var mae:archMae);

	procedure cargarMaestro(var arch:archMae);
	var
		info:novela;
	begin	
		with info do begin
			rewrite(arch);
			info.cod:=0;
			write(arch,info);
			write('CODIGO: ');readln(cod);
			while (cod <> 0) do begin
				write('GENERO: ');readln(genero);
				write('NOMBRE: ');readln(nombre);
				write('DURACION: ');readln(duracion);
				write('DIRECTOR: ');readln(director);
				write('PRECIO: ');readln(precio);
				write(arch,info);
				writeln();
				write('CODIGO: ');readln(cod);
			end;
			close(arch);
		end;
	end;
	
	procedure imprimirMaestro(var arch:archMae);
	var
		info:novela;
	begin
		reset(arch);
		with info do begin
			while (not EOF(arch)) do begin
				read(arch,info);
				writeln('CODIGO: ', cod);
				writeln('GENERO: ', genero);
				writeln('NOMBRE: ', nombre);
				writeln('DURACION: ', duracion);
				writeln('DIRECTOR: ', director);
				writeln('PRECIO: ', precio:0:2);
				writeln();
			end;
		end;
		close(arch);
	end;
	
	procedure darDeAltaNovela(var mae:archMae);
	var
		reg:novela;
		aux:novela;
		nueN:novela;
	begin
		write('CODIGO: ');readln(nueN.cod);
		write('GENERO: ');readln(nueN.genero);
		write('NOMBRE: ');readln(nueN.nombre);
		write('DURACION: ');readln(nueN.duracion);
		write('DIRECTOR: ');readln(nueN.director);
		write('PRECIO: ');readln(nueN.precio);
		reset(mae);
		read(mae,reg);
		if(reg.cod = 0) then begin
			seek(mae,filesize(mae));
			write(mae, nueN);
		end
		else begin
			seek(mae,(-1*reg.cod)); //me ubico en el ultimo registro borrado
			read(mae, aux); //cargo el ultimo registro borrado en aux
			seek(mae, filePos(mae)-1); //retrocedo hasta el registro borrado
			write(mae, nueN); //escribo en el registro borrado la nueva info
			seek(mae, 0);//voy a la posicion iniciar
			write(mae, aux); //actualizo la cabecera de la lista con aux
		end;
		close(mae);
	end;
	
	procedure darDeBajaNovela (var mae:archMae);
		
		procedure leer(var mae:archMae; var regMae:novela);
		begin
			if(not EOF(mae))then begin
				read(mae,regMae);
			end
			else
				regMae.cod:=VA;
		end;
	
	var
		posNegativa:integer;
		cabe:novela;
		codigoNovela:integer;
		reg:novela;
		pos:integer;
	begin
		reset(mae);
		write('ingrese el codigo a eliminar: ');readln(codigoNovela);
		leer(mae, reg);
		while (reg.cod <> codigoNovela)  and (reg.cod <> VA) do begin
			leer(mae, reg);
		end;
		if(reg.cod<>VA)then begin
			pos:=filePos(mae)-1; //obtengo la posicion
			posNegativa:=pos * -1; //obtengo la posicion negativa
			reg.cod:=posNegativa;
			seek(mae, 0); //voy a la cabecera
			read(mae, cabe); //tomo el registro de la cabecera
			seek(mae, 0); //vuelvo a la cabecera
			write(mae, reg);//actualizo la cabecera
			seek(mae,pos); //me posiciono en el registro a eliminar
			write(mae, cabe); //cargo lo que tenia la cabecera
		end; 
		close(mae);
	end;
	
var
	op:integer;
begin
	op:=VA;
	while(op <> 0)do begin
		writeln('1) cargar maestro');
		writeln('2) imprimir maestro');
		writeln('3) dar de alta novela');
		writeln('4) dar de baja novela');
		writeln('5) modificar datos de una novela');
		writeln('6) listar novelas');
		write('ingrese una opcion: '); readln(op);
		writeln('-----------------------------------------------------------------------------');
		case op of
			1:cargarMaestro(mae);
			2:imprimirMaestro(mae);
			3:darDeAltaNovela(mae);
			4:darDeBajaNovela(mae);
		end;
	end;
end;	

var 
	mae:archMae;
BEGIN
	assign(mae, 'Novelas.dat');
	menu(mae);
END.

