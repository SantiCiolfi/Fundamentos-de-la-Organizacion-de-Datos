{
5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:

a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.

b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.

c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.

d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.
}
program ejercicio5;

type
	celular = record
		codigo:integer;
		nombre:string;
		descripcion:string;
		marca:string;
		precio:real;
		stockMin:integer;
		stockDis:integer;
	end;
	
	arch_cels = file of celular;
	arch_txt = text;

procedure menu(var celulares:arch_cels; var texto:arch_txt);

	procedure crearArchivo(var celulares:arch_cels; var texto:arch_txt);
	var
		cel:celular;
	begin
		rewrite(celulares);
		reset(texto);
		while (not eof(texto)) do 
		begin
			readLn(texto,cel.codigo,cel.precio,cel.marca);
			readln(texto,cel.stockMin,cel.stockDis,cel.descripcion);
			readln(texto,cel.nombre);
			
			write(celulares, cel);
        	end;
        	close(celulares);
        	close(texto);
	end;
	
	procedure listarDebajoStock(var celulares:arch_cels);
	var
		cel:celular;
	begin
		reset(celulares);
		while (not EOF(celulares)) do
		begin
			read(celulares, cel);
			if(cel.stockDis < cel.stockMin)then
			begin
				writeln('codigo: ', cel.codigo);
				writeln('nombre: ', cel.nombre);
				writeln('marca: ' ,cel.marca);
				writeln('stock minimo: ', cel.stockMin);
				writeln('stock disponible: ', cel.stockDis);
				writeln('descripcion: ', cel.descripcion);
				writeln('precio: ', cel.precio:0:4);
			end;
		end;
		close(celulares)
	end;
	
	procedure listarCadenaDada(var celulares:arch_cels);
	var
		cadena:string;
		cel:celular;
	begin
		write('ingrese una cadena a buscar entre los celulares: ');
		readln(cadena);
		reset(celulares);
		while(not EOF(celulares))do
		begin
			read(celulares, cel);
			if(cel.descripcion = ' ' + cadena)then
			begin
				writeln('codigo: ', cel.codigo);
				writeln('nombre: ', cel.nombre);
				writeln('marca: ' ,cel.marca);
				writeln('stock minimo: ', cel.stockMin);
				writeln('stock disponible: ', cel.stockDis);
				writeln('descripcion: ', cel.descripcion);
				writeln('precio: ', cel.precio:0:4);
			end;
		end;
		close(celulares);
	end;
	
	procedure exportarATxt(var celulares:arch_cels);
	var
		txt:text;
		cel:celular;
	begin
		assign(txt, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 1\CelularesExportados.txt');
		reset(celulares);
		rewrite(txt);
		while (not EOF(celulares))do
		begin
			read(celulares, cel);
			writeln(txt,cel.codigo,' ',cel.precio:0:4,cel.marca);
			writeln(txt,cel.stockMin,' ',cel.stockDis,cel.descripcion);
			writeln(txt,cel.nombre);
		end;
		close(txt);
		close(celulares);
	end;
	
var
	opc : integer;
begin
	opc:=0;
	while(opc <> 5)do
	begin
		writeln();
		writeln('1) crear archivo .dat decelulares');
		writeln('2) listar celulares por debajo de su stock minimo');
		writeln('3) listar celulares que contengan una cadena dada');
		writeln('4) exportar a un archivo txt los celulares');
		writeln('5) cerrar el programa');
		readln(opc);
		writeln();
		case opc of
			1: crearArchivo(celulares,texto);
			2:listarDebajoStock(celulares);
			3:listarCadenaDada(celulares);
			4:exportarATxt(celulares);
			5:writeln('cerrando programa...');
		else
			writeln('Opción no válida');
		end;
	end;
end;

var
	celulares:arch_cels;
	texto:arch_txt;
	name:string;
BEGIN
	writeln('ingrese el nombre del archivo: ');
	read(name);
	assign(celulares,'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 1\' + name + '.dat');
	assign(texto, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 1\Celulares.txt');
	menu(celulares, texto);
END.

