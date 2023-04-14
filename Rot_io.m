% Função da matriz de rotação: Perifocal -> Inercial
function Rio = Rot_io(x1,x2,x3)
x1 = x1*pi/180;
x2 = x2*pi/180;
x3 = x3*pi/180;

R_z_x1 = [cos(x1) -sin(x1) 0; sin(x1) cos(x1) 0; 0 0 1];
R_x_x2 = [1 0 0; 0 cos(x2) -sin(x2); 0 sin(x2) cos(x2)];
R_z_x3 = [cos(x3) -sin(x3) 0; sin(x3) cos(x3) 0; 0 0 1];

% Matriz de rotação do sistema de perifocal para o inercial
Rio = R_z_x3*R_x_x2*R_z_x1;
end