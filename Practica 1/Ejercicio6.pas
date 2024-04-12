{
6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0. 
}

program ejercicio6;

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
		writeln('Datos exportados');
	end;
	
	procedure aniadirCel (var celulares:arch_cels);
	var
		cel:celular;
	begin
		reset(celulares);
		seek(celulares, fileSize(celulares));
		write('ingrese nombre del celular (si ingresa fin se acaba la carga): ');
		readln(cel.nombre);
		while(cel.nombre <> 'fin')do
		begin
			write('ingrese codigo: ');
			readln(cel.codigo);
			write('ingrese precio: ');
			readln(cel.precio);
			write('ingrese marca: ');
			readln(cel.marca);
			cel.marca := ' ' + cel.marca;
			write('ingrese stock minimo: ');
			readln(cel.stockMin);
			write('ingrese stock disponible: ');
			readln(cel.stockDis);
			write('ingrese descripcion: ');
			readln(cel.descripcion);
			cel.descripcion := ' ' + cel.descripcion;
			
			write(celulares, cel);
			
			writeln('------------------------------------------------------------------------------------------------------------------------');
			write('ingrese nombre del celular (si ingresa fin se acaba la carga): ');
			readln(cel.nombre);
		end;
		close(celulares);
	end;
	
	procedure modificarCel (var celulares:arch_cels);
	var
		cel:celular;
		codigo:integer;
		encontre:boolean;
	begin
		encontre:=false;
		write('ingrese el codigo del celular a modificar su stock: ');
		readln(codigo);
		reset(celulares);
		while(not EOF(celulares) and(not encontre))do
		begin
			read(celulares, cel);
			if(cel.codigo = codigo)then
			begin
				write('stock actual: ', cel.stockDis, ', ingrese el nuevo stock: ');
				readln(cel.stockDis);
				seek(celulares, filePos(celulares) - 1);
				write(celulares, cel);
				encontre:=true;
			end;
		end;
		close(celulares);
	end;
	
	procedure exportarCelSinStock (var celulares:arch_cels);
	var
		sinStock:text;
		cel:celular;
	begin
		assign(sinStock, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 1\sinStock.txt');
		reset(celulares);
		rewrite(sinStock);
		while(not EOF(celulares))do
		begin
			read(celulares, cel);
			if(cel.stockDis = 0)then
			begin
				writeln(sinStock,cel.codigo,' ',cel.precio:0:4,cel.marca);
				writeln(sinStock,cel.stockMin,' ',cel.stockDis,cel.descripcion);
				writeln(sinStock,cel.nombre);
			end;
		end;
		close(sinStock);
		close(celulares);
		writeln('Datos exportados');
	end;
	
var
	opc : integer;
begin
	opc:=0;
	while(opc <> 8)do
	begin
		writeln();
		writeln('1) crear archivo .dat decelulares');
		writeln('2) listar celulares por debajo de su stock minimo');
		writeln('3) listar celulares que contengan una cadena dada');
		writeln('4) exportar a un archivo txt los celulares');
		writeln('5) añadir celulares por teclado');
		writeln('6) modificar el stock de un celular');
		writeln('7) exportar celulares sin stock a un txt');
		writeln('8) cerrar el programa');
		readln(opc);
		writeln();
		case opc of
			1: crearArchivo(celulares,texto);
			2:listarDebajoStock(celulares);
			3:listarCadenaDada(celulares);
			4:exportarATxt(celulares);
			5:aniadirCel(celulares);
			6:modificarCel(celulares); //con codigo
			7:exportarCelSinStock(celulares);
			8:writeln('cerrando programa...');
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

