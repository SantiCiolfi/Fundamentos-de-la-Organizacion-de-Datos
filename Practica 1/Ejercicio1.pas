program Ejercicio1;

var 
	arch_int: file of integer;
	i:integer;
	name:string[255];
	ruta:string[255];
BEGIN
	ruta:= 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 1\';
	writeln('ingrese un nombre para el archivo: ');
	read(name);
	ruta:= ruta + name; 
	assign (arch_int, ruta);
	rewrite(arch_int);
	writeln('ingrese un numero (30000 detiene el sistema): ');
	read(i);
	while(i <> 30000) do
	begin
		writeln('ingrese un numero (30000 detiene el sistema): ');
		read(i);
		write(arch_int, i);
	end;
	close(arch_int);
END.

