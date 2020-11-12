%% Declaración de las localizaciones de la poblacion inicial
                                
size = 500;         % Tamaño de la matriz, entre mas grande mas tarda
rhoIni = 0.2;       % porcentaje de poblacion inicial
np0=20;             % numero de pacientes zero distribuidos al azar
tvirus=28;          % tiempo que el paciente puede contagiar a los demas
pcontagio=0.125;    % Probabilidad de contagiarse con un solo individuo
nmuerte=2;          % probabilidad de muerte (debe ser entre un valor entre 0 y 10)
diasevolucion=365;  % numero de dias transcurridos en la matriz

% inicializamos la poblacion inicial
individuos = zeros(size);   % matriz de individuos(matriz de ceros)
tinfectado= zeros(size);    % matriz del tiempo de infección de los individuos
ni=0;   % contador


for i=1:size    % para 1 hasta valor size
    for j=1:size    % para 1 hasta valor size
        if rand< rhoIni    % si un número aleatorio es menor que el porcentaje de población inicial entonces
            individuos(i,j)=1; % va llenando la matriz individuos con 1 en las posiciones resultantes
            ni=ni+1;   % se aumenta en 1 el contador
        end    % fin si
    end     % fin for j
end     % fin for i


for j=1:np0     % para 1 hasta el número de pacientes zero distribuidos al azar
    % paciente cero
    i0=round(rand*size);    % genera numeros aleatorios de 0 a tamaño size y los redondea a su número mas proximo
    j0=round(rand*size);    % genera numeros aleatorios de 0 a tamaño size y los redondea a su número mas proximo
    individuos(i0,j0)=2;    % posiciona a los individuos sanos en la matriz individuos con los numeros aleatorios generados
    tinfectado(i0,j0)=1;    % posciona a los individuos infectados en la matriz de infectados con los numeros aleatorios generados
end     % fin for


%% Simulation por un año esto es 365 dias
dia=0;  % inicio del primer dia del año
while dia < diasevolucion % mientras dia sea menor a los 365 dias
    dia = dia + 1;  % aumentamos el dia en 1
    for i=1:size     % para 1 hasta tamaño size renglon
        for j=1:size   % para 1 hasta tamaño size columna
            % posicion individuo(su valor) es mayor que 0 y posicionindividuo(su valor) es menor a 4
            if (individuos(i,j) > 0 )&&(individuos(i,j) < 4)  % si hay un individuo sano o infectado lo muevo
                dx = round(rand*3.0-1.5);   % Genera 1, 0 o -1
                dy = round(rand*3.0-1.5);   % Genera 1, 0 o -1
                % revisa las fronteras para que no salga de la matriz
                % cadea vez que llegue a la frontera se vuelve 0 la celda
                if (i+dx>size)  % si i mas valor dx es mayor que valor size entonces
                    dx=0;   % asigna 0 a dx
                end     % fin si
                if (i+dx<1) % si i mas el valor dx es menor que 1
                    dx=0;   % asigna 1 a dx
                end     % fin si
                if (j+dy>size)  % si j mas dy son mayores que valor size entonces
                    dy=0;   % asigna 0 a dy
                end     %fin si
                if (j+dy<1)     %si j mas dy son menores que 1 entonces
                    dy=0;   % asigna 0 a dy;
                end % fin si
                
                
                in=round(i+dx);     % redondeo de la suma de i mas dx eje x
                jn=round(j+dy);     % redondeo de la suma de j mas dy eje y
                                
                % movimiento del individuo y el movimiento del tiempo de infeccion en el tiempo
                if individuos(in,jn)==0     % si la celda nueva en la matriz individuos esta vacia entonces
                    individuos(in,jn)=individuos(i,j);  % mueve individuo i,j a la nueva posicion individuo in,jn
                    tinfectado(in,jn)=tinfectado(i,j);  % se mueve su tiempo de infeccion tambien
                    individuos(i,j)=0;  % la posicion anterior del individuo se vuelve 0
                    tinfectado(i,j)=0;  % la posicion anterior del tiempo del infectado se vuelve 0 
                    if individuos(in,jn)==2     % si la celda nueva de la matriz individuos es igual a 2 entonces
                        tinfectado(in,jn)= tinfectado(in,jn)+1;     % se suma 1 al valor del tiempo del infectado
                        if tinfectado(in,jn)>tvirus     % si el valor del tiempo de infeccion del individuo es mayor que el tiempo de infeccion entonces
                            tinfectado(in,jn)=0;    % el tiempo de infeccion del individuo es igual a 0
                            pmuerte = round(rand*100);   %probabilidad de muerte del individuo infectado
                            if pmuerte <= nmuerte     % si la probabilidad de muerte es menor o igual a 2 entonce
                                individuos(in,jn)=4;    % el individuo se vuelve 4 (muerte)
                                %individuos(iin,jjn) = individuos(in,ij);
                            else
                                individuos(in,jn)=3;    % el individuo se vuelve inmune
                            end
                        end     %fin si
                    end     %fin si
                    
                    % revisamos el numero de vecinos infectados
                    if individuos(in,jn)==1
                        nvi=0;
                        vxi=-1;
                        vxf=1;
                        vyi=-1;
                        vyf=1;
                        if in==size
                            vxf=0;
                        end
                        if in==1
                            vxi=0;
                        end
                        if jn==size
                            vyf=0;
                        end
                        if jn==1
                            vyi=0;
                        end
                        
                        for ki=vxi:vxf
                            for kj=vyi:vyf
                                ink=round(in+ki);
                                jnk=round(jn+kj);
                                if individuos(ink,jnk)== 2
                                    nvi=nvi+1;
                                end
                            end
                        end
                        %calculamos probabilidad de contagio
                        if rand < nvi*pcontagio
                            individuos(in,jn)=2;
                            tinfectado(in,jn)=1;
                        end
                    end
                end
            end
        end
    end
    
    infectados=0;
    sanos=0;
    muertos=0;
    inmunes=0;
    for i=1:size
        for j=1:size
            if individuos(i,j)==1
                sanos=sanos+1;
            end
            if individuos(i,j)==2
                infectados=infectados+1;
            end
            if individuos(i,j)==3
                inmunes=inmunes+1;
            end
            if individuos(i,j)==4
                muertos=muertos+1;
            end
        end
    end
    %disp(dia);
    %disp(sanos);
    %disp(infectados);
    %disp(fallecidos);
    imagesc(individuos);    % dibuja el proceso
    drawnow;    % dibuja la matriz en pantalla
    temp=[dia, sanos, infectados, inmunes, muertos];    % formato de impresion de datos
    dlmwrite('tabla_virus.dat',temp ,'-append');  % nombra la tabla de datos 
end