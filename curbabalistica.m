function curbabalistica(bataia_data)
% Selectori pentru grafice:
Gv=0; % componentele vitezei ca functii de timp
Gc=0; % legile de miscare
Gt=0; % traiectoria (curba balistica)
Gd=1; % reprezentarea dinamica
% Parametrii fizici:
g=9.80665; % acceleratia gravitationala terestra standard [N/kg]
m=1.2; % masa proiectilului [kg]
G=m*g; % greutatea proiectilului
% Conditii initiale:
v0=500; % viteza initiala [m/s]
alpha0=1; % unghiul de lansare [grade]
% Valori plauzibile ale coeficientilor de frecare fluida:
r1=G/2/v0; % coeficientul termenului liniar al fortei de frecare
r2=G/2/v0^2; % coeficientul termenului patratic
% Definirea intervalului de timp de interes
if(bataia_data > 14050)
disp("Se depaseste bataia maxima . Alegeti o valoare mai mica de 14050.")
return;
end
N=1500;
i=N;
vx=zeros(1,N); vy=vx; % prealocare pentru componentele vitezei
x=zeros(1,N); y=x; % prealocare pentru coordonate
while (bataia_data-x(i)>3)
afis=["Se aproximeaza noua bataie: ",num2str(x(i)*10e-4),'km'];disp(afis);
t0=0; tf=2*v0/g*sind(alpha0); % supraestimare a timpului de zbor
N=1500; t=linspace(t0,tf,N); dt=t(2)-t(1); % discretizarea timpului
% Prealocare si valori de inceput:
vx=zeros(1,N); vy=vx; % prealocare pentru componentele vitezei
x=zeros(1,N); y=x; % prealocare pentru coordonate
vx(1)=v0*cosd(alpha0); % valoarea initiala a componentei vx
vy(1)=v0*sind(alpha0); % valoarea initiala a componentei vy
for i=1:N-1
    aux=1-dt*(r1+r2*sqrt(vx(i)^2+vy(i)^2))/m; % variabila ajutatoare
    vx(i+1)=vx(i)*aux; % recurenta de ordinul I pentru vx
    vy(i+1)=vy(i)*aux-g*dt; % recurenta de ordinul I pentru vy
    x(i+1)=x(i)+vx(i)*dt; % MU pe intervalul dt
    y(i+1)=y(i)+vy(i)*dt; % MU pe intervalul dt
    if y(i+1)<0, break; end;
end
t=t(1:i); vx=vx(1:i); vy=vy(1:i); x=x(1:i); y=y(1:i); % eliminarea valorilor in surplus

if x(i)>bataia_data
  
if (x(i)-bataia_data)>1000
alpha0=alpha0-1;

elseif (x(i)-bataia_data)>100
alpha0=alpha0 - 0.1;

elseif (x(i)-bataia_data)>10
alpha0=alpha0 - 0.01;

elseif (x(i)-bataia_data)>1
alpha0=alpha0 - 0.001;
end
end
if x(i)<bataia_data
  
if (bataia_data-x(i))>1000
alpha0=alpha0+1;

elseif (bataia_data-x(i))>100
alpha0=alpha0 + 0.1;

elseif (bataia_data-x(i))>10
alpha0=alpha0 + 0.01;

elseif (bataia_data-x(i))>1
alpha0=alpha0 + 0.001;
end
end
end
if Gv==1
    figure(1);
    plot(t,vx,'-r',t,vy,'-b');
    xlabel('t(s)'); ylabel('v(m/s)'); grid;
    title('Componentele vitezei ca functii de timp');
    legend('vx','vy');
end;
if Gc==1
    figure(2);
    plot(t,x/1e3,'-r',t,y/1e3,'-b');
    xlabel('t(s)'); ylabel('coord(km)'); grid;
    title('Coordonatele ca functii de timp');
    legend('x','y','Location','NorthWest');
end;
if Gt==1
    figure(3);
    plot(x/1e3,y/1e3,'-k','LineWidth',2);
    xlabel('x(km)'); ylabel('y(km)'); grid;
    title('Curba balistica');
    axis equal; axis tight
end;
% Afisarea unor marimi de interes:
tf=t(i); % timpul de zbor
b=x(i); % bataia
h=max(y); % altitudinea maxima
tu=t(y==h); % timpul de urcare
tc=tf-tu; % timpul de coborare
Q=1/2*m*(v0^2-vx(i)^2-vy(i)^2); % caldura produsa prin frecare
afis=['Timpul de zbor: ',num2str(tf),' s']; disp(afis);
afis=['Bataia proiectilului: ',num2str(b/1e3),' km']; disp(afis);
afis=['Altitudinea maxima: ',num2str(h/1e3),' km']; disp(afis);
afis=['Timpul de urcare: ',num2str(tu),' s']; disp(afis);
afis=['Timpul de coborare: ',num2str(tc),' s']; disp(afis);
afis=['Caldura produsa: ',num2str(Q/1e3),' kJ']; disp(afis);
afis=['Unghiul pentru bataia data: ',num2str(alpha0),' grade']; disp(afis);
if Gd==1
    figure(4);
    set(4,'Position',[50 50 850 600]);
    tic; simt0=toc; simt=simt0; % porneste cronometrul si retine timpul initial
    while simt<tf+simt0
        plot(x/1e3,y/1e3,'-c'); hold on
        xlabel('x(km)'); ylabel('y(km)'); grid;
        title('Simularea miscarii');
        axis equal; axis tight
        simt=toc; % citeste timpul sistemului
        index=abs(t-simt)==min(abs(t-simt)); % cauta cel mai apropiat t din discretizare
        plot(x(index)/1e3,y(index)/1e3,'.b'); hold off
        text(b/2/1e3,h/3/1e3,['t=',num2str(round(t(index))),' s']);
        text(b/2/1e3,h/3/1e3-0.5,['vx=',num2str(round(round(vx(index)))),' m/s']);
        text(b/2/1e3,h/3/1e3-1,['vy=',num2str(round(round(vy(index)))),' m/s']);
        pause(1e-3);
    end
end
clc; clear; close all; % linia de igiena
endfunction