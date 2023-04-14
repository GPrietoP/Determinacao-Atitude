function Q = matriz_quaternion(q)
%{
Matriz dos cossenos diretores a partir do quatérnion
q - quaternion (onde q(4) é a parte escalar)
Q - Matriz dos cossenos dieretores
%}
% ––––––––––––––––––––––––––––––––––––––––––––––
q1 = q(1); q2 = q(2); q3 = q(3); q4 = q(4);
Q = [q1^2-q2^2-q3^2+q4^2, 2*(q1*q2+q3*q4), 2*(q1*q3-q2*q4);
2*(q1*q2-q3*q4), -q1^2+q2^2-q3^2+q4^2, 2*(q2*q3+q1*q4);
2*(q1*q3+q2*q4), 2*(q2*q3-q1*q4), -q1^2-q2^2+q3^2+q4^2 ];
end 
