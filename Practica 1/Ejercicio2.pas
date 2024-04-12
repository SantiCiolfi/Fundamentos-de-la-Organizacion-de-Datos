program Ejercicio2;

var
	arch_int: file of integer;
	prom:real;
	aux:integer;
	cant:integer;
	name:string[255];
BEGIN
	cant:=0;
	prom:=0;
	write('ingrese el nombre del archivo a procesar: ');
	readln(name);
	assign(arch_int, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 1\' + name);
	reset(arch_int);
	while (not EOF(arch_int))do
	begin
		read(arch_int, aux);
		if(aux > 1500) then
			cant:= cant + 1;
		prom:= prom + aux;
	end;
	prom:=prom / fileSize(arch_int);
	writeln('cantidad total de numeros: ', fileSize(arch_int));
	writeln('cantidad de numeros mayores a 1500: ', cant);
	writeln('promedio: ', prom:2:2);
	close(arch_int);
END.

