%% INGRESO DE DATA

clc; clear; close all;             % limpia pantalla, variables, y cierra figuras 
display('Ingresar las ubicaciones y el valor de las cargas correspondientes dejando un espacio.')
display('El valor MINIMO de N es 4 y debe ser par')
tit = 'Calculadora de Peso de Armaduras';
prompt = {'Long. Puente (m)','Altura maxima del puente [m]',...
    'Numero de divisiones de la plataforma inferior del puente', ...
    'Tipo de Armadura: 1 Pratt, 2 Howe','Ingrese densidad del material [kg/m3]', ...
    'Ingrese area transversal de las barras [m2]'};
def = {'100', '50', '6','1','100','200'};
answe = inputdlg(prompt,tit,[1 50],def);
L=1000*sscanf(answe{1},'%f');       
H=1000*sscanf(answe{2},'%f');   
N=sscanf(answe{3},'%f');    
tipo = sscanf(answe{4},'%f');
densidad = sscanf(answe{5},'%f');
area = sscanf(answe{6},'%f');
                                    
%***********************************************************************


%% CÁLCULOS

e = N*0.5;


if tipo == 1
    
    %% Si es pratt
    display('Se eligio armadura tipo Pratt')
   
    
    total = H + L + 2*sqrt((0.5*L)^2+(H)^2);
    acum1 = 0;
    acum2 = 0;
    
    for i=1:(e-1)
        acum1 = acum1 + i;
        acum2 = acum2 + sqrt((L/N)^2+((i+1)*H/e)^2);
    end
    
    acum1 = acum1 * 2 * H / e;
    
    acum2 = acum2 *2;
    
    total = total + acum1 + acum2;
    
    
else
    
    %%Si es howe
    
    
        display('Se eligio armadura tipo Howe')
    %%%%%%%%%5display('Se ha elegido la armadura tipo Howe')
    
    %%total = e*H + L + 2*sqrt((0.5*L)^2+(H)^2);
    total = H + L + 2*sqrt((0.5*L)^2+(H)^2);
    acum1 = 0;
    acum2 = 0;
    
    for i=1:(e-1)
        acum1 = acum1 + i;
        acum2 = acum2 + sqrt((L/N)^2+(i*H/e)^2);
    end
    
    acum1 = (acum1 * H * 2) / e;
    
    acum2 = acum2 *2;
    
    total = total + acum1 + acum2;
    
end

pesototal = 9.81*densidad * area * total;

display('El peso total es: ')
display(pesototal);


