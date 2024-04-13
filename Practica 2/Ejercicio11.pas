{
La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web
de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día,
idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
por los siguientes criterios: año, mes, día e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
Año : ---
	Mes:-- 1
		día:-- 1
			idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
			--------
			idusuario N Tiempo total de acceso en el dia 1 mes 1
		Tiempo total acceso dia 1 mes 1
	-------------
	día N
			idUsuario 1 Tiempo Total de acceso en el dia N mes 1
			--------
			idusuario N Tiempo total de acceso en el dia N mes 1
		Tiempo total acceso dia N mes 1
	Total tiempo de acceso mes 1
	------
	Mes 12
	día 1
			idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
			--------
			idusuario N Tiempo total de acceso en el dia 1 mes 12
		Tiempo total acceso dia 1 mes 12
	-------------
	día N
			idUsuario 1 Tiempo Total de acceso en el dia N mes 12
			--------
			idusuario N Tiempo total de acceso en el dia N mes 12
		Tiempo total acceso dia N mes 12
	Total tiempo de acceso mes 12
Total tiempo de acceso año
Se deberá tener en cuenta las siguientes aclaraciones:
	● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.
	● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año no encontrado”.
	● Debe definir las estructuras de datos necesarias.
	● El recorrido del archivo debe realizarse una única vez procesando sólo la información necesaria.
}


program ejercicio11;

const
	VA=999;
	
type
	meses = 1..12;
	dias= 1..31;
	acceso=record
		anio:integer;
		mes:meses;
		dia:dias;
		id:integer;
		tiempo:integer;
	end;
	
	arch_maestro = file of acceso;
	
procedure menu (var archivo:arch_maestro);
	
	procedure cargarMaestro (var arch:arch_maestro);
	var
		a:acceso;
	begin
		rewrite(arch);
		with a do begin
			write('ANIO: ');readln(anio);
			while (anio <> 0) do begin
				write('MES: ');readln(mes);
				write('DIA: ');readln(dia);
				write('ID: ');readln(id);
				write('TIEMPO DE ACCESO: ');readln(tiempo);
				write(arch,a);
				writeln();
				write('ANIO: ');readln(anio);
			end;
		end;
		close(arch);
	end;	
	
	procedure imprimirMaestro (var arch:arch_maestro);
	var
		a:acceso;
	begin
		reset(arch);
		with a do begin
			while (not EOF(arch)) do begin
				read(arch,a);
				writeln('ANIO: ',anio);
				writeln('MES: ',mes);
				writeln('DIA: ',dia);
				writeln('ID: ',id);
				writeln('TIEMPO DE ACCESO: ',tiempo);
				writeln;
			end;
		end;
		close(arch);
	end;
	
	procedure procesarMaestro (var maestro:arch_maestro);
	
		procedure leer (var arch:arch_maestro; var dato:acceso);
		begin
			if (not EOF(arch)) then read(arch,dato)
			else dato.anio := VA;
		end;
		
	var
		reg:acceso;
		anio:integer;
		anioActual:integer;
		mesActual:integer;
		diaActual:integer;
		idActual:integer;
		tiempoUser:integer;
		tiempoDia:integer;
		tiempoMes:integer;
		tiempoAnio:integer;
	begin
		write('Ingrese el anio a procesar: '); readln(anio);
		reset(maestro);
		tiempoAnio:=0;
		leer(maestro,reg);
		while(reg.anio <> anio) and(reg.anio <> VA)do begin
			leer(maestro,reg);
		end;
		if(reg.anio = VA)then
			writeln('anio no encontrado')
		else begin
			anioActual := reg.anio;
			writeln('Anio: ', anioActual);
		end;
		while (reg.anio <> VA) and (anioActual = reg.anio) do begin //si cambia de año o se acaba el archivo corta
			tiempoMes:=0;
			mesActual:=reg.mes;
			writeln('Mes: ', mesActual);
			while (mesActual=reg.mes) and (anioActual = reg.anio) do begin //corta por mes o año distintos;
				tiempoDia:=0;
				diaActual:=reg.dia;
				writeln('Dia: ', diaActual);
				while (mesActual=reg.mes) and (anioActual = reg.anio) and (diaActual = reg.dia) do begin //corta por dia, mes o año
					tiempoUser:=0;
					idActual:=reg.id;
						writeln('Id: ', idActual);
					while (mesActual=reg.mes) and (anioActual = reg.anio) and (diaActual = reg.dia) and (idActual = reg.id) do begin //corta por id, dia, mes o año
						tiempoUser := tiempoUser + reg.tiempo;
						leer(maestro,reg);
					end;
					writeln('Tiempo Total de acceso en el dia ', diaActual, ' mes ', mesActual, ' del USUARIO: ', tiempoUser);
					tiempoDia := tiempoDia + tiempoUser;
				end;
				writeln('Tiempo Total de acceso en el DIA ', diaActual, ' mes ', mesActual, ': ', tiempoDia);
				tiempoMes := tiempoMes + tiempoDia;
			end;
			writeln('Tiempo Total de acceso en el  MES ', mesActual, ': ', tiempoMes);
			tiempoAnio := tiempoAnio + tiempoMes;
		end;
		writeln('Tiempo Total de acceso en el  ANIO :' ,tiempoAnio);
		close(maestro);
	end;
	
var
	opc:integer;
begin
	opc:=0;
	while (opc <> 4)do
	begin
		writeln('1) Cargar maestro');
		writeln('2) Imprimir maestro');
		writeln('3) Procesar maestro');
		writeln('4) Cerrar programa');
		write('Ingrese una opcion: ');
		readln(opc);
		writeln();
		case opc of
			1: cargarMaestro(archivo);
			2:imprimirMaestro(archivo);
			3:procesarMaestro(archivo);
			4:writeln('Cerrando programa...');
			else
				writeln('Opcion incorrecta');
		end;
		writeln('----------------------------------------------------');
	end;
end;
	
var
	maestro:arch_maestro;
BEGIN
	assign(maestro, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 2\RegistroDeAccesos');
	menu(maestro);
END.

