{
 Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
mismo (información guardada acerca de los movimientos que ocurren en el server) que se
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.

a. Realice el procedimiento necesario para actualizar la información del log en un
día particular. Defina las estructuras de datos que utilice su procedimiento.
b. Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:

nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados

Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema. Considere la implementación de esta opción de las siguientes maneras:
i- Como un procedimiento separado del punto a).
ii- En el mismo procedimiento de actualización del punto a). Qué cambios
se requieren en el procedimiento del punto a) para realizar el informe en
el mismo recorrido?
   
}


program ejercicio12;

const
	VA=999;

type
	log = record
		numUser:integer;
		nombreUser:string;
		nombre:string;
		apellido:string;
		cantMensEnv:integer;
	end;
	
	regDetalle = record
		numUser:integer;
		cuentaDes:string;
		cuerpoMens:string;
	end;
	
	archMaestro = file of log;
	archDet=file of regDetalle;
	
procedure menu(var mae:archMaestro; var det:archDet);

	procedure cargarDetalle (var arch:archDet); //los campos cuenta destino y cuerpo del mensaje no son necesarios
	var
		info:regDetalle;
	begin
		rewrite(arch);
		with info do begin
			write('NUMERO DE USUARIO: ');readln(numUser);
			while (numUser <> 0) do begin
				//write('CUENTA DESTINO: ');readln(cuentaDes);
				//write('CUERPO MENSAJE: ');readln(cuerpoMens);
				write(arch,info);
				writeln();
				write('NUMERO DE USUARIO: ');readln(numUser);
			end;
		end;
		close(arch);
	end;
	
	procedure cargarMaestro (var arch:archMaestro); //los campos nombre de usuario, nombre  y apellido no son necesarios
	var
		info:log;
	begin
		rewrite(arch);
		with info do begin
			write('NUMERO DE USUARIO: ');readln(numUser);
			while (numUser <> 0) do begin
				//write('NOMBRE USER: ');readln(nombreUser);
				//write('NOMBRE: ');readln(nombre);
				//write('APELLIDO: ');readln(apellido);
				write('CANTIDAD DE MENSAJES ENVIADOS: ');readln(cantMensEnv);
				write(arch,info);
				writeln();
				write('NUMERO DE USUARIO: ');readln(numUser);
			end;
		end;
		close(arch);
	end;
	
	procedure imprimirMaestro (var arch:archMaestro);
	var
		info:log;
	begin
		reset(arch);
		with info do begin
			while (not EOF(arch)) do begin
				read(arch,info);
				writeln('NUMERO DE USUARIO: ',numUser);
				//writeln('NOMBRE DE USUARIO: ',nombreUser);
				//writeln('NOMBRE: ',nombre);
				//writeln('APELLIDO: ',apellido);
				writeln('CANTIDAD DE MENSAJES ENVIADOS: ',cantMensEnv);
				writeln;
			end;
		end;
		close(arch);
	end;
	
	procedure imprimirDetalle(var arch:archDet);
	var
		info:regDetalle;
	begin
		reset(arch);
		with info do begin
			while (not EOF(arch)) do begin
				read(arch,info);
				writeln('NUMERO DE USUARIO: ',numUser);
				//writeln('CUENTA DESTINO: ',cuentaDes);
				//writeln('CUERPO DEL MENSAJE: ',cuerpoMens);
				writeln;
			end;
		end;
		close(arch);
	end;
	
	procedure actualizarMaestro(var det:archDet; var mae:archMaestro);
		
		procedure leer (var arch:archDet; var dato:regDetalle);
		begin
			if (not EOF(arch)) then read(arch,dato)
			else begin
				dato.numUser := VA;
			end;
		end;
		
	var
		regDet:regDetalle;
		regMae:log;
		numActual:integer;
	begin
		reset(det);
		reset(mae);
		leer(det,regDet);
		while (regDet.numUser <> VA) do begin
		read(mae, regMae);
			while(regMae.numUser <> regDet.numUser)do begin //se puede hacer el informe agregando un if y si el detalle y el maestro todavia no coinciden se informe ese usuario
				read(mae, regMae); 
			end;
			numActual:=regDet.numUser;
			while (regDet.numUser = numActual) do begin
			regMae.cantMensEnv := regMae.cantMensEnv + 1;
				leer(det, regDet);
			end;
			seek(mae, filePos(mae)-1);
			write(mae, regMae); // luego se informarian los que fueron actualizados y el listado seguiria quedando en orden y con los datos actualizados
		end;
		close(det);
		close(mae);
	end;
	
	procedure generarInforme (var mae:archMaestro);
	var
		archivo:text;
		regMae:log;
	begin
		assign(archivo, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 2\InformeMails.txt');
		rewrite(archivo);
		reset(mae);
		while (not EOF(mae)) do begin
			read(mae, regMae);
			writeln(archivo, regMae.numUser, ' ', regMae.cantMensEnv);
		end;
		close(archivo);
		close(mae);
	end;
var
	opc:integer;
begin
	opc:=VA;
	while (opc <> 0) do begin
		writeln('1-Cargar maestro');
		writeln('2-Cargar detalles');
		writeln('3-Imprimir maestro');
		writeln('4-Imprimir detalles');
		writeln('5-Actualizar maestro');
		writeln('6-Generar informe');
		writeln('0-Finalizar');
		write('Ingrese una opcion: ');
		readln(opc);
		writeln();
		case opc of 
			1:cargarMaestro(mae);
			2:cargarDetalle(det);
			3:imprimirMaestro(mae);
			4:imprimirDetalle(det);
			5:actualizarMaestro(det,mae);
			6:generarInforme(mae);
			0:writeln('cerrando programa...');
			else writeln('OPCION INCORRECTA');
		end;
		writeln('-----------------------------------------------------------------------------------------');
	end;
end;
	
var
	maestro:archMaestro;
	det:archDet;
BEGIN
	assign(maestro, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 2\LogMail.dat');
	assign(det, 'C:\Users\Usuario\Desktop\Facultad\licenciatura en sistemas\Segundo anio\Primer Semestre\FOD\Practica 2\DetalleMails.dat');
	menu(maestro, det);
END.
