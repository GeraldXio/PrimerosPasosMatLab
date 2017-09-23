

%% INGRESO DE INFORMACION PARA EL PROBLEMA

 clear; clc; close all;             % limpiar vars y pantalla, luego cerrar figuras

display('Ingresar las cargas y sus ubicaciones sobre la viga dejando un espacio entre cada valor')
display('Se asume como positivas a las cargas en sentido contrario a la gravedad')

tit = 'CODIGO MATLAB PREG 7';
prompt = {'Longitud de la Viga (m)','Ubicaci�n Xi de cada fuerza Pi (i=1..n) [m]',...
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


%% C�LCULOS PRELIMINARES
n=size(X,1);                        %N�mero de cargas en el sistema
Xr=L-X;                             %Longitud complementaria a la ubicaci�n de cada carga
 
% Creaci�n de vectores
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
 
%% C�lculo de reacciones en A y B para cada carga independiente
 
for t=1:n;
    Rb(t)=-X(t)*P(t)/L;             %Reacci�n en B.
    Ra(t)=-Xr(t)*P(t)/L;            %Reaccion en A.
end

 
%**************************************************************************
 
%% Creaci�n de vectores para almacenar respuestas para las gr�ficas
 
% Se discretizar� la viga para su an�lisis y respuesta
 
Xgraf=0:1:L;                        %Posici�n en X para cada punto graficado
igraf=length(Xgraf);                %Discretizando de la viga
VgrafP=zeros(1, igraf);             %Fuerza cortante por Cargas Puntuales para la gr�fica
MgrafP=zeros(1, igraf);             %Momento flector para la gr�fica por P
 


% Cada elemento de estos vector fila corresponde a cada punto de la discretizaci�n
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
 
RA =sum(Ra);                        %Reacci�n total en el apoyo A [N]
RB= sum(Rb);                        %Reacci�n total en el apoyo B [N]


% Gr�fica de la Fuerza Cortante [kN]



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
        Mizq=Ra(i)*Xgraf(j);        % Funci�n del momento flector por la izquierda
        MgrafP(j)=MgrafP(j)+Mizq;   % Acumula momentos para cada carga
        %Suma de todos los momentos flectores generadas a la izquierda de las cargas aplicadas y almacenadas en Mgraf
    end  
    for j=X(i)+1:L+1
        Mder=Rb(i)*(L-Xgraf(j));    % Funci�n del momento flector por la derecha
        MgrafP(j)=MgrafP(j)+Mder;   % Acumula momentos para cada carga
        %Suma de todos los momentos flectores generadas a la derecha de las cargas aplicadas y almacenadas en Mgraf                                            
    end
end 
Mgraf=MgrafP/1000;                  %Conversi�n de kN-m
[Mmax, LocationJ] = max(Mgraf(:));  %Extracci�n del valor m�ximo
Mmax;                               %Momento Flector m�ximo de la viga
Xmax=Xgraf(LocationJ)/1000;         %Ubicaci�n del Momento Flector m�ximo 



% Gr�fica del Momento Flector [kN-m]


stem(s(2),Xgraf/1000,-Mgraf/1000,'Fill','black','MarkerEdgeColor','black','MarkerSize',4,'Marker','.')
axis(s(2),[-inf,L/1000,-inf,inf])
title(s(2),'DMF en la Viga')
xlabel(s(2),'Distancia, [m]')            %eje x
ylabel(s(2),'Momento Flector [kN-m]')    %eje y 
%**********************************************************************
%FIN DEL ANALISIS DE VIGA
%**********************************************************************
%%NOTA: us� como base el codigo de ejemplo que esta en paideia