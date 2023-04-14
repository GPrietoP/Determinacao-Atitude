close all
clear
clc

g = 9.81; % [m/s²] - aceleração da gravidade


%% LER ARQUIVOS

% Arquivo parada.txt
fileID = fopen('parada.txt','r'); % Abrir o Arquivo
for i = 1:1000
    string_parada = regexp(fgetl(fileID),',','split'); % Vetor com todos as strings separadas por ,
    parada(i,:) = str2double(string_parada(1:9));
    tempo_parada(i) = str2double(string_parada(10));
end
fclose(fileID);
% Sistema de referência do acelerômetro para o giroscópio
parada(:,1) = -parada(:,1);
% Sistema de referência do magnetômetro para o giroscópio
parada(:,4:6) = [fliplr(parada(:,4:5)) parada(:,6)];
parada(:,4) = -parada(:,4);

% Arquivo 90yzx.txt
fileID = fopen('90yzx.txt','r'); % Abrir o Arquivo
for i = 1:1000
    string_movimento = regexp(fgetl(fileID),',','split'); % Vetor com todos as strings separadas por ,
    movimento(i,:) = str2double(string_movimento(1:9));
    tempo_movimento(i) = str2double(string_movimento(10));
end
fclose(fileID);
% Sistema de referência do acelerômetro para o giroscópio
movimento(:,1) = -movimento(:,1);
% Sistema de referência do magnetômetro para o giroscópio
movimento(:,4:6) = [fliplr(movimento(:,4:5)) movimento(:,6)];
movimento(:,4) = -movimento(:,4);

%% CONVERSÃO DOS VALORES

modulo_parada = vecnorm(parada(:,4:6)')';
parada(:,1:3) = parada(:,1:3)*(1/256)*g; % Acelerômetro em g - m/s²
parada(:,4) = parada(:,4)./modulo_parada; % X magnetômetro
parada(:,5) = parada(:,5)./modulo_parada; % Y magnetômetro
parada(:,6) = parada(:,6)./modulo_parada; % Z magnetômetro
parada(:,7:9) = parada(:,7:9)*(1/14.375); % Giroscópio em rad/s

modulo_movimento = vecnorm(movimento(:,4:6)')';
movimento(:,1:3) = movimento(:,1:3)*(1/256)*g; % Acelerômetro em g - m/s²
movimento(:,4) = movimento(:,4)./modulo_movimento; % X magnetômetro
movimento(:,5) = movimento(:,5)./modulo_movimento; % Y magnetômetro
movimento(:,6) = movimento(:,6)./modulo_movimento; % Z magnetômetro
movimento(:,7:9) = movimento(:,7:9)*(1/14.375); % Giroscópio em rad/s


%% CALIBRAÇÃO

% vetor de desvio: colunas 1 a 3 acelerômetro / colunas 4 a 6 magnetômetro
% / colunas 7 a 9 giroscópio
desvio = [0 0 g 0 1 0 0 0 0] - mean(parada(:,1:9));

% Sensores calibrados
parada_calibrado = parada(:,1:9)+desvio;
movimento_calibrado = movimento(:,1:9)+desvio;


%% TEMPO

% Placa parada
t_parada = tempo_parada(1);
for i = 2:1000
   t_parada(i) = t_parada(i-1)+tempo_parada(i); % milisegundos
end
t_parada = t_parada*1/1000;

% Em movimento
t_movimento = tempo_movimento(1);
for i = 2:1000
   t_movimento(i) = t_movimento(i-1)+tempo_movimento(i); % milisegundos
end
t_movimento = t_movimento*1/1000;


%% PLOTAGEM DOS GRÁFICOS

% Para placa Parada sem e com calibração
figure
subplot(3,2,1)
plot(t_parada,parada(:,1:3))
title('Placa parada e sensor não calibrado')
xlabel('Tempo [s]'); ylabel('Aceleração [m/s²]')
axis([0 35 -5 15])
grid on
subplot(3,2,2)
plot(t_parada,parada_calibrado(:,1:3))
title('Placa parada e sensor calibrado')
xlabel('Tempo [s]'); ylabel('Aceleração [m/s²]')
axis([0 35 -5 15])
grid on
subplot(3,2,3)
plot(t_parada,parada(:,4:6))
xlabel('Tempo [s]'); ylabel('Campo magnético [normalizado]')
axis([0 35 -1 2])
grid on
subplot(3,2,4)
plot(t_parada,parada_calibrado(:,4:6))
xlabel('Tempo [s]'); ylabel('Campo magnético [normalizado]')
axis([0 35 -1 2])
grid on
subplot(3,2,5)
plot(t_parada,parada(:,7:9))
xlabel('Tempo [s]'); ylabel('Velocidade de rotação [rad/s]')
axis([0 35 -3 3])
grid on
subplot(3,2,6)
plot(t_parada,parada_calibrado(:,7:9))
xlabel('Tempo [s]'); ylabel('Velocidade de rotação [rad/s]')
axis([0 35 -3 3])
legend('X','Y','Z')
grid on

% Para placa em movimento com e sem calibração
figure
subplot(3,2,1)
plot(t_movimento,movimento(:,1:3))
title('Placa em movimento e sensor não calibrado')
xlabel('Tempo [s]'); ylabel('Aceleração [m/s²]')
axis([0 35 -15 15])
grid on
subplot(3,2,2)
plot(t_movimento,movimento_calibrado(:,1:3))
title('Placa em movimento e sensor calibrado')
xlabel('Tempo [s]'); ylabel('Aceleração [m/s²]')
axis([0 35 -15 15])
grid on
subplot(3,2,3)
plot(t_movimento,movimento(:,4:6))
xlabel('Tempo [s]'); ylabel('Campo magnético [normalizado]')
axis([0 35 -2 2])
grid on
subplot(3,2,4)
plot(t_movimento,movimento_calibrado(:,4:6))
xlabel('Tempo [s]'); ylabel('Campo magnético [normalizado]')
axis([0 35 -2 2])
grid on
subplot(3,2,5)
plot(t_movimento,movimento(:,7:9))
xlabel('Tempo [s]'); ylabel('Velocidade de rotação [rad/s]')
axis([0 35 -150 100])
grid on
subplot(3,2,6)
plot(t_movimento,movimento_calibrado(:,7:9))
xlabel('Tempo [s]'); ylabel('Velocidade de rotação [rad/s]')
axis([0 35 -150 100])
legend('X','Y','Z')
grid on


%% TRIAD METHOD

% Componentes de aceleração
ax_parada = parada_calibrado(:,1)./vecnorm(parada_calibrado(:,1:3)')';
ay_parada = parada_calibrado(:,2)./vecnorm(parada_calibrado(:,1:3)')';
az_parada = parada_calibrado(:,3)./vecnorm(parada_calibrado(:,1:3)')';
a_parada = [ax_parada ay_parada az_parada];

ax_movimento = movimento_calibrado(:,1)./vecnorm(movimento_calibrado(:,1:3)')';
ay_movimento = movimento_calibrado(:,2)./vecnorm(movimento_calibrado(:,1:3)')';
az_movimento = movimento_calibrado(:,3)./vecnorm(movimento_calibrado(:,1:3)')';
a_movimento = [ax_movimento ay_movimento az_movimento];

% ax_parada = parada_calibrado(:,1);
% ay_parada = parada_calibrado(:,2);
% az_parada = parada_calibrado(:,3);
% a_parada = [ax_parada ay_parada az_parada];
% 
% ax_movimento = movimento_calibrado(:,1);
% ay_movimento = movimento_calibrado(:,2);
% az_movimento = movimento_calibrado(:,3);
% a_movimento = [ax_movimento ay_movimento az_movimento];

% Componentes magnetômetro
mag_parada = parada_calibrado(:,4:6);
mag_movimento = movimento_calibrado(:,4:6);

for i = 1:1000
    
    t1i = a_parada(i,:);
    t1b = a_movimento(i,:);
    
%     t1i = a_parada(i,:)/norm(a_parada(i,:));
%     t1b = a_movimento(i,:)/norm(a_movimento(i,:));
    
    t2i = cross(a_parada(i,:),mag_parada(i,:))/norm(cross(a_parada(i,:),mag_parada(i,:)));
    t2b = cross(a_movimento(i,:),mag_movimento(i,:))/norm(cross(a_movimento(i,:),mag_movimento(i,:)));
    
    t3i = cross(t1i,t2i)/norm(cross(t1i,t2i));
    t3b = cross(t1b,t2b)/norm(cross(t1b,t2b));
    
    Ab = [t1b' t2b' t3b'];
    Ai = [t1i' t2i' t3i'];
    Rbi = Ab*Ai';
    
    pitch(i) = asind(Rbi(3,1));  
    yaw(i) = atand(Rbi(1,2)/Rbi(1,1));    
    if Rbi(1,1)<0 && Rbi(1,2)>0
        yaw(i) = yaw(i)+180;
    elseif Rbi(1,1)<0 && Rbi(1,2)<0
        yaw(i) = yaw(i)-180;
    end
    roll(i) = atand(Rbi(2,3)/Rbi(3,3));
    if Rbi(3,3)<0 && Rbi(2,3)>0
        roll(i) = roll(i)+180;
    elseif Rbi(3,3)<0 && Rbi(2,3)<0
        roll(i) = roll(i)-180;
    end
end


%% INTEGRAÇÃO PELA REGRA DO TRAPÉZIO

% Componentes giroscópio
gx_movimento = movimento_calibrado(:,7);
gy_movimento = movimento_calibrado(:,8);
gz_movimento = movimento_calibrado(:,9);
giro_movimento = [gx_movimento gy_movimento gz_movimento];

r = 0;
p = 0;
ya = 0;
for i = 1:999
    x = gx_movimento(i:i+1);
    y = gy_movimento(i:i+1);
    z = gz_movimento(i:i+1);
    t = t_movimento(i:i+1);
        
    roll2(i) = r+trapz(t,x);
    r = roll2(i);
    pitch2(i) = p+trapz(t,y);
    p = pitch2(i);
    yaw2(i) = ya+trapz(t,z);
    ya = yaw2(i);
    t2(i) = sum(t)/2;
end

%% QUATÉRNIONS

for i =1:999
    phi = roll2(i)/2;
    theta = pitch2(i)/2;
    psi = yaw2(i)/2;
    
    q1 = sind(phi)*cosd(theta)*cosd(psi)+cosd(phi)*sind(theta)*sind(psi);
    q2 = cosd(phi)*sind(theta)*cosd(psi)-sind(phi)*cosd(theta)*sind(psi);
    q3 = cosd(phi)*cosd(theta)*sind(psi)+sind(phi)*sind(theta)*cosd(psi);
    q4 = cosd(phi)*cosd(theta)*cosd(psi)-sind(phi)*sind(theta)*sind(psi);
      
    Q = [q1^2-q2^2-q3^2+q4^2, 2*(q1*q2+q3*q4), 2*(q1*q3-q2*q4);
        2*(q1*q2-q3*q4), -q1^2+q2^2-q3^2+q4^2, 2*(q2*q3+q1*q4);
        2*(q1*q3+q2*q4), 2*(q2*q3-q1*q4), -q1^2-q2^2+q3^2+q4^2 ]; 
    
    pitch3(i) = asind(Q(3,1));  
    yaw3(i) = atand(Q(1,2)/Q(1,1));
    if Q(1,1)<0 && Q(1,2)>0
        yaw3(i) = yaw3(i)+180;
    elseif Q(1,1)<0 && Q(1,2)<0
        yaw3(i) = yaw3(i)-180;
    end    
    roll3(i) = atand(Q(2,3)/Q(3,3));
        if Q(3,3)<0 && Q(2,3)>0
        roll3(i) = roll3(i)+180;
    elseif Q(3,3)<0 && Q(2,3)<0
        roll3(i) = roll3(i)-180;
    end
end


%% MÉDIA DOS 3 MÉTODOS

pitch_medio = mean([pitch(1:999); pitch2; pitch3]);
yaw_medio = mean([yaw(1:999); yaw2; yaw3]);
roll_medio = mean([roll(1:999); roll2; roll3]);


%% SEGUNDA PLOTAGEM DE GRÁFICOS

% Comparação entre os Ângulos de Euler de cada método

figure
subplot(3,1,1)
plot(t_movimento,roll, t_movimento,pitch, t_movimento,yaw, 'linewidth',1.1)
title('Ângulos de Euler pelo método da TRIAD')
xlabel('Tempo [s]'); ylabel('Ângulo [graus]')
grid on

subplot(3,1,2)
plot(t2,roll2, t2,pitch2, t2,yaw2, 'linewidth',1.1)
title('Ângulos de Euler pelo método dos TRAPÉZIOS')
xlabel('Tempo [s]'); ylabel('Ângulo [graus]')
grid on

subplot(3,1,3)
plot(t2,roll3, t2,pitch3, t2,yaw3, 'linewidth',1.1)
title('Ângulos de Euler por QUATÉRNIOS')
legend('roll \phi','pitch \theta','yaw \psi')
xlabel('Tempo [s]'); ylabel('Ângulo [graus]')
grid on

% Comparação entre os métodos

figure
subplot(3,1,1)
plot(t_movimento,pitch)
hold on
plot(t2,pitch2, t2,pitch3, 'linewidth',1.1)
title('Ângulo de arfagem (PITCH \theta)')
xlabel('Tempo [s]'); ylabel('Ângulo [graus]')
grid on

subplot(3,1,2)
plot(t_movimento,yaw)
hold on
plot(t2,yaw2, t2,yaw3, 'linewidth',1.1)
title('Ângulo de guinada (YAW \psi)')
xlabel('Tempo [s]'); ylabel('Ângulo [graus]')
grid on

subplot(3,1,3)
plot(t_movimento,roll)
hold on
plot(t2,roll2, t2,roll3, 'linewidth',1.1)
title('Ângulo de rolamento (ROLL \phi)')
xlabel('Tempo [s]'); ylabel('Ângulo [graus]')
legend('TRIAD', 'Trapézio', 'Quatérnion')
grid on

% Média

figure
plot(t2,roll_medio, t2,pitch_medio, t2,yaw_medio, 'linewidth',1.1)
title('Ângulos de Euler - Média dos 3 métodos')
xlabel('Tempo [s]'); ylabel('Ângulo [graus]')
legend('roll \phi','pitch \theta','yaw \psi')
grid on


%% Erros absolutos e relativos

% TRIAD E TRAPÉZIO
fprintf('Método da TRIAD e do TRAPÉZIO \n\n')

erro_absoluto_medio_pitch_Triad_Trap = abs(mean(pitch)-mean(pitch2));
erro_absoluto_medio_yaw_Triad_Trap = abs(mean(yaw)-mean(yaw2));
erro_absoluto_medio_roll_Triad_Trap = abs(mean(roll)-mean(roll2));
fprintf('# Erro Absoluto \n * Pitch: %f º\n * Yaw: %f º\n * Roll: %f º\n\n',erro_absoluto_medio_pitch_Triad_Trap,erro_absoluto_medio_yaw_Triad_Trap,erro_absoluto_medio_roll_Triad_Trap)

erro_relativo_medio_pitch_Triad_Trap = erro_absoluto_medio_pitch_Triad_Trap/abs(mean(pitch2));
erro_relativo_medio_yaw_Triad_Trap = erro_absoluto_medio_yaw_Triad_Trap/abs(mean(yaw2));
erro_relativo_medio_roll_Triad_Trap = erro_absoluto_medio_roll_Triad_Trap/abs(mean(roll2));
fprintf('# Erro Relativo \n * Pitch: %f %%\n * Yaw: %f %%\n * Roll: %f %%\n\n',erro_relativo_medio_pitch_Triad_Trap,erro_relativo_medio_yaw_Triad_Trap,erro_relativo_medio_roll_Triad_Trap)

fprintf('___________________________________________________________________ \n\n')
% TRIAD E QUATÉRNIONS
fprintf('Método da TRIAD e dos QUATÉRNIONS\n\n')

erro_absoluto_medio_pitch_Triad_Quat = abs(mean(pitch)-mean(pitch3));
erro_absoluto_medio_yaw_Triad_Quat = abs(mean(yaw)-mean(yaw3));
erro_absoluto_medio_roll_Triad_Quat = abs(mean(roll)-mean(roll3));
fprintf('# Erro Absoluto \n * Pitch: %f º\n * Yaw: %f º\n * Roll: %f º\n\n',erro_absoluto_medio_pitch_Triad_Quat,erro_absoluto_medio_yaw_Triad_Quat,erro_absoluto_medio_roll_Triad_Quat)

fprintf('___________________________________________________________________ \n\n')
% TRAPÉZIO E QUATÉRNIONS
fprintf('Método do TRAPÉZIO e dos QUARTÉRNIONS\n\n')

erro_absoluto_medio_pitch_Trap_Quat = abs(mean(pitch2)-mean(pitch3));
erro_absoluto_medio_yaw_Trap_Quat = abs(mean(yaw2)-mean(yaw3));
erro_absoluto_medio_roll_Trap_Quat = abs(mean(roll2)-mean(roll3));
fprintf('# Erro Absoluto  \n * Pitch: %f º\n * Yaw: %f º\n * Roll: %f º\n\n',erro_absoluto_medio_pitch_Trap_Quat,erro_absoluto_medio_yaw_Trap_Quat,erro_absoluto_medio_roll_Trap_Quat)

erro_relativo_medio_pitch_Trap_Quat = erro_absoluto_medio_pitch_Trap_Quat/abs(mean(pitch2));
erro_relativo_medio_yaw_Trap_Quat = erro_absoluto_medio_yaw_Trap_Quat/abs(mean(yaw2));
erro_relativo_medio_roll_Trap_Quat = erro_absoluto_medio_roll_Trap_Quat/abs(mean(roll2));
fprintf('# Erro Relativo \n * Pitch: %f %%\n * Yaw: %f %%\n * Roll: %f %%\n\n',erro_relativo_medio_pitch_Trap_Quat,erro_relativo_medio_yaw_Trap_Quat,erro_relativo_medio_roll_Trap_Quat)

%% ANIMAÇÃO
my_vertices = [-1 -2 -1/4; 1 -2 -1/4; 1 2 -1/4; -1 2 -1/4; -1 -2 1/4; 1 -2 1/4; 1 2 1/4; -1 2 1/4];
my_faces = [1 2 3 4; 2 6 7 3; 4 3 7 8; 1 5 8 4; 1 2 6 5; 5 6 7 8];
fig = figure(6);
cube2 = patch('Vertices', my_vertices, 'Faces', my_faces, 'FaceColor', [0.6 0 0]);
axis([-1 1 -1 1 -1 1]*4)
view([-30 30])
axis off
lx = line([-4 4], [0 0], [0 0]); Tx = text(4, 0, 0, 'ROLL \phi');
ly = line( [0 0], [-4 4], [0 0]); Ty = text( 0, 4, 0, 'PITCH \theta');
lz = line( [0 0], [0 0], [-4 4]); Tz = text( 0, 0, 4, 'YAW \psi');

line([-4 4], [0 0], [0 0], 'Color','black','LineStyle','--'); text(4, 0, 0, 'X');
line( [0 0], [-4 4], [0 0], 'Color','black','LineStyle','--'); text( 0, 4, 0, 'Y');
line( [0 0], [0 0], [-4 4], 'Color','black','LineStyle','--'); text( 0, 0, 4, 'Z');
legend('','','','','Posição inicial dos eixos', 'Location','south')

pp2 = 0; 
yy2 = 0; 
rr2 = 0; 
for i = 1:999
   tic
   
   title(['Tempo: ' num2str(fix(t2(i))) ' s'])

   rotate(cube2, [0 1 0],pitch2(i)-pp2,[0 0 0])   
   rotate(cube2, [0 0 1],yaw2(i)-yy2,[0 0 0])
   rotate(cube2, [1 0 0],roll2(i)-rr2,[0 0 0])
    
   rotate(lx, [0 1 0],pitch2(i)-pp2,[0 0 0])
   rotate(lx, [0 0 1],yaw2(i)-yy2,[0 0 0])
   rotate(lx, [1 0 0],roll2(i)-rr2,[0 0 0])
   rotate(ly, [0 1 0],pitch2(i)-pp2,[0 0 0]) 
   rotate(ly, [0 0 1],yaw2(i)-yy2,[0 0 0])   
   rotate(ly, [1 0 0],roll2(i)-rr2,[0 0 0])   
   rotate(lz, [0 1 0],pitch2(i)-pp2,[0 0 0])
   rotate(lz, [0 0 1],yaw2(i)-yy2,[0 0 0])
   rotate(lz, [1 0 0],roll2(i)-rr2,[0 0 0])
   
   rotate(Tx, [0 1 0],pitch2(i)-pp2,[0 0 0])
   rotate(Tx, [0 0 1],yaw2(i)-yy2,[0 0 0])
   rotate(Tx, [1 0 0],roll2(i)-rr2,[0 0 0])
   rotate(Ty, [0 1 0],pitch2(i)-pp2,[0 0 0]) 
   rotate(Ty, [0 0 1],yaw2(i)-yy2,[0 0 0])   
   rotate(Ty, [1 0 0],roll2(i)-rr2,[0 0 0])   
   rotate(Tz, [0 1 0],pitch2(i)-pp2,[0 0 0])
   rotate(Tz, [0 0 1],yaw2(i)-yy2,[0 0 0])
   rotate(Tz, [1 0 0],roll2(i)-rr2,[0 0 0])
   
   pp2 = pitch2(i);
   yy2 = yaw2(i);
   rr2 = roll2(i);
   
   drawnow
   
   tiempo = toc;
   pause((tempo_movimento(i)/1000)-tiempo)
   
%    pause(2)
%    saveas(cube2,sprintf('%d.png',i))

   frame = getframe(fig);
   im{i} = frame2im(frame);
end

fprintf('\n *PROGRAMA FINALIZADO* \n')

%% Criando GIF
% filename = 'Atitude da placa.gif'; % Specify the output file name
% for idx = 1:999
%     [A,map] = rgb2ind(im{idx},256);
%     if idx == 1
%         imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',tempo_movimento(i)/1000);
%     else
%         imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',tempo_movimento(i)/1000);
%     end
% end









