

%% INGRESO DE INFORMACION PARA EL PROBLEMA

 clear; clc; close all;             % limpiar vars y pantalla, luego cerrar figuras

display('Ingresar las cargas y sus ubicaciones sobre la viga dejando un espacio entre cada valor')
display('Se asume como positivas a las cargas en sentido contrario a la gravedad')

tit = 'CODIGO MATLAB PREG 7';
prompt = {'Longitud de la Viga (m)','Ubicación Xi de cada fuerza Pi (i=1..n) [m]',...
    'Fuerza Pi [kN] (Positivo es en contra de gravedad)', ...
    'Distancia "a" (del extremo izquierdo hasta el apoyo izquierdo) [m]', ...
    'Distancia "b" (desde el extremo derecho hasta el apoyo derecho [m]'};

def = {'18', '1 5 9', '63 -69 -12','2.1','1.2'};
resp = inputdlg(prompt,tit,[1 45],def);
L=1000*sscanf(resp{1},'%f');        
X=1000*sscanf(resp{2},'%f');        
P=sscanf(resp{3},'%f')*10^3;        

a=1000*sscanf(resp{4},'%f');        
b=1000*sscanf(resp{5},'%f');        


 Ay = 0;
 By = 0;
%***********************************************************************


%% CÁLCULOS PRELIMINARES
n=size(X,1);                        %Número de cargas en el sistema
Xr=L-X;                             %Longitud complementaria a la ubicación de cada carga
 
% Creación de vectores
Ra=zeros(n+2,1);                      
Rb=zeros(n+2,1);                      
%**************************************************************************



 for i=0:n-1;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    By = -(X(i+1)-a)*P(i+1)+By;            
    Ay = -(L-X(i+1)-b)*P(i+1)+Ay;           
 end
 
 
 By = By /(L-a-b);
 Ay = Ay /(L-a-b);

 %%
 %% 
 
  X(n+2) = L-b; 
 P(n+2) = By; 
 Xr(n+2)=L-X(n+2);
 
 X(n+1) = a;
 P(n+1) = Ay;
 Xr(n+1)=L-X(n+1);

n = n+2;
%**************************************************************************
 
%% Cálculo de reacciones en A y B para cada carga independiente
 
for t=1:n;
    Rb(t)=-X(t)*P(t)/L;             %Reacción en B.
    Ra(t)=-Xr(t)*P(t)/L;            %Reaccion en A.
end

 
%**************************************************************************
 
%% Creación de vectores para almacenar respuestas para las gráficas
 
% Se discretizará la viga para su análisis y respuesta
 
Xgraf=0:1:L;                        %Posición en X para cada punto graficado
igraf=length(Xgraf);                %Discretizando de la viga
VgrafP=zeros(1, igraf);             %Fuerza cortante por Cargas Puntuales para la gráfica
MgrafP=zeros(1, igraf);             %Momento flector para la gráfica por P
 


% Cada elemento de estos vector fila corresponde a cada punto de la discretización
%**************************************************************************
%% Fuerza Cortante V
%(sentido positivo hacia abajo)
%Aporte de las cargas puntuales P
for i=1:n
    Vizq=Ra(i);                     %Fuerza cortante a la izquierda de la carga
    Vder=Ra(i)+P(i);                %Fuerza cortante a la derecha de la carga
    for j=1:X(i)
        VgrafP(j)=VgrafP(j)+Vizq;   %%%puedo hacerle como si fuera cero?
%Suma de todas las fuerzas cortantes generadas a la izquierda de las cargas aplicadas y almacenadas en Vgraf
    end
    for j=X(i)+1:L+1 
        VgrafP(j)=VgrafP(j)+Vder;   
%Suma de todas las fuerzas cortantes generadas a la derecha de las cargas aplicadas y almacenadas en Vgraf
    end  
    
end
 
RA =sum(Ra);                        %Reacción total en el apoyo A [N]
RB= sum(Rb);                        %Reacción total en el apoyo B [N]


% Gráfica de la Fuerza Cortante [kN]



figure('Color','white'); %%almacenara a las dos graficas, mediante subplots
s(1) = subplot(2,1,1);
s(2) = subplot(2,1,2); 


stem(s(1),Xgraf/1000,VgrafP/1000,'Fill','blue','MarkerEdgeColor',...
    'blue','MarkerSize',4,'Marker','.')
axis(s(1),[-inf,L/1000,-inf,inf])
title(s(1),'DFC en la viga')
xlabel(s(1),'Distancia [m]')                 % etiqueta eje x
ylabel(s(1),'Fuerza Cortante V [kN]')       % etiqueta eje y
%**************************************************************************


%% Momento Flector M
%(valor positivo cuando genere tensiones debajo de la viga) 
%Aporte de las cargas puntuales P 
for i=1:n
    for j=1:X(i)
        Mizq=Ra(i)*Xgraf(j);        % Función del momento flector por la izquierda
        MgrafP(j)=MgrafP(j)+Mizq;   % Acumula momentos para cada carga
        %Suma de todos los momentos flectores generadas a la izquierda de las cargas aplicadas y almacenadas en Mgraf
    end  
    for j=X(i)+1:L+1
        Mder=Rb(i)*(L-Xgraf(j));    % Función del momento flector por la derecha
        MgrafP(j)=MgrafP(j)+Mder;   % Acumula momentos para cada carga
        %Suma de todos los momentos flectores generadas a la derecha de las cargas aplicadas y almacenadas en Mgraf                                            
    end
end 
Mgraf=MgrafP/1000;                  %Conversión de kN-m
[Mmax, LocationJ] = max(Mgraf(:));  %Extracción del valor máximo
Mmax;                               %Momento Flector máximo de la viga
Xmax=Xgraf(LocationJ)/1000;         %Ubicación del Momento Flector máximo 



% Gráfica del Momento Flector [kN-m]


stem(s(2),Xgraf/1000,-Mgraf/1000,'Fill','black','MarkerEdgeColor','black','MarkerSize',4,'Marker','.')
axis(s(2),[-inf,L/1000,-inf,inf])
title(s(2),'DMF en la Viga')
xlabel(s(2),'Distancia, [m]')            %eje x
ylabel(s(2),'Momento Flector [kN-m]')    %eje y 
%**********************************************************************
%FIN DEL ANALISIS DE VIGA
%**********************************************************************
%%NOTA: usé como base el codigo de ejemplo que esta en paideia