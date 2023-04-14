# Determinacao-Atitude
Programa criado na disciplina de Laboratótio de Guiagem, Navegação e Controle.

A atitude de um veículo espacial é sua orientação relativa no espaço, que diz 
respeito a seu apontamento angular vetorial em relação a um referencial inercial ou não. 
O sucesso no processamento e aquisição de informações em uma missão espacial está 
diretamente ligado à acurada determinação da atitude do veículo, alcançada a partir do 
uso de sensores, para posterior controle e estabilização de sua orientação angular. Nessa 
atividade será determinada a atitude de uma IMU: Unidade de Medida Inercial composta 
de três sensores: magnetômetro, acelerômetro e giroscópio.

Com os dados de aceleração, taxa de rotação e de direção do campo magnético de 
uma IMU fornecidos pelos três sensores foi realizada a calibração do equipamento e 
utilizado três métodos de determinação de atitude distintos, dois analíticos e um 
numérico. Determinação de altitude pelo algoritmo TRIAD e determinação de atitude 
pelo Quatérnion são os métodos analíticos de determinar a atitude e o método de 
integração do trapézio é método numérico.

O PROGRAMA PRINCIPAL É O DeterminacaoAtitudeBeatrizDeSouzaGabrielPrieto.m

# Animação do movimento da placa

![Atitude da placa](https://user-images.githubusercontent.com/128917882/232033683-e7b07f82-e1bc-416d-ab79-76d2d60b8943.gif)
