{
 7. Realizar un programa que permita:
a) Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela.
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado
}


program ejercicio7;

type
	novela = record
		nombre:string[100]; //segunda linea
		codigo:integer; //primera linea
		precio:real;
		genero:string[20];
	end;

	arch_nov = file of novela;
	arch_novTxt = text;
	
procedure menu (var novelas : arch_nov;var novTexto:arch_novTxt);

	procedure crearArchivo (var novelas : arch_nov;var novTexto:arch_novTxt);
	var
		n:novela;
	begin
		rewrite(novelas);
		reset(novTexto);
		while(not EOF(novTexto))do
		begin
			readln(novTexto, n.codigo, n.precio, n.genero);
			readln(novTexto, n.nombre);
			write(novelas, n);
		end;
		close(novelas);
		close(novTexto);
		writeln('Carga exitosa');
	end;
	
	
	procedure agregarNovela(var novelas : arch_nov);
	var
		n:novela;
	begin
		reset(novelas);
		seek(novelas, fileSize(novelas));
		write('ingrese un nombre (fin para terminar): ');
		readln(n.nombre);
		while(n.nombre <> 'fin')do
		begin
			write('ingrese un codigo: ');
			readln(n.codigo);
			write('ingrese un precio: ');
			readln(n.precio);
			write('ingrese un genero: ');
			readln(n.genero);
			
			write(novelas, n);
			
			writeln();
			writeln('------------------------------------------------------------------------------------------------------------------------');
			writeln();
			write('ingrese un nombre (fin para terminar): ');
			readln(n.nombre);
		end;
		close(novelas);
		writeln('Novela agregada con exito');
	end;
	
	procedure modificarNovela(var novelas : arch_nov);
	var
		n:novela;
		encontre:boolean;
		c:integer;
	begin
		encontre:=false;
		write('ingrese un codigo de novela a modificar: ');
		readln(c);
		reset(novelas);
		while(not EOF(novelas) and (not encontre))do
		begin
			read(novelas, n);
			
			if(c = n.codigo)then
			begin
				writeln('datos actuales: | nombre:', n.nombre , ' | codigo: ' , n.codigo , ' | precio: ' , n.precio:0:3 , ' | genero:' + n.genero);
			
				write('ingrese un nombre: ');
				readln(n.nombre);
				write('ingrese un codigo: ');
				readln(n.codigo);
				write('ingrese un precio: ');
				readln(n.precio);
				write('ingrese un genero: ');
				readln(n.genero);
				
				seek(novelas, filePos(novelas) - 1);
				write(novelas, n);
				
				encontre:=true;
			end;
		end;
		close(novelas);
		writeln('Modificacion exitosa');
	end;

var
	opc:integer;
begin
	opc:=0;
	while(opc <> 4)do
	begin
		writeln('1) Crear archivo a partir de TXT');
		writeln('2) Agregar novela');
		writeln('3) Modificar novela');
		writeln('4) salir del programa');
		readln(opc);
		case opc of
			1: crearArchivo(novelas, novTexto);
			2:agregarNovela(novelas);
			3:modificarNovela(novelas);
			4:writeln('saliendo del programa...');
		else
			writeln('Opcion incorrecta');
		end;
	end;
end;
	
var
	novelas : arch_nov;
	novTexto:arch_novTxt;
	name:string[20];
BEGIN
	write('ingrese el nombre del archivo: ');
	readln(name);
	assign(novelas,'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 1\' + name);
	assign(novTexto,'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 1\novelas.txt');
	menu(novelas, novTexto);
END.

