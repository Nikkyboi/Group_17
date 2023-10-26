function [ConvXY] = SelfMade_Conv(X,Y)
%This function computes the convolution of to signals, as sequences.
%We here require that the seqences are equally  long.
%It is also required that both signals have the same length, with regard to
%non zero elements.
if length(X)-length(Y)>0
    error('Input vectores must have the same length')
end
%Start by flipping Y around.
Y = flip(Y);
YWithValues = zeros(1,length(Y));
n=1;
%Now some code to left shift the values from Y to the begining of the
%array.
 for i=1:length(Y)
     if Y(i)==0
         YWithValues(i) = 0;     
     else 
         YWithValues(i) = n; 
         n = n+1;
     end
 end
 
 %Finder første index der ikke er nul
 k = find(YWithValues==1);
 %Finder sidste index der ikke er nul
 [~,MI] = max(YWithValues);
 %Allokere plads og sletter.
 YWithValues = zeros(1,length(Y));
 %Sætter værdierne ind.
 YWithValues(2:n) = Y(k:MI);
 %Nu er vi klar til at lave convolution.
 
N = length(X); % length of first vector
M = length(Y); % length of second vector
lout=N+M-1; % length of output vector
ConvXY=zeros(1,lout); % initialize output vector with zeros
for i = 1:N % loop over first vector
    for k = 1:M % loop over second vector
        ConvXY(i+k-1) = ConvXY(i+k-1) + YWithValues(k)*X(i); % multiply and add elements
    end
end

end

