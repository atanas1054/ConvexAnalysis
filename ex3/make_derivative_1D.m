function [D] = make_derivative(N,h)

row  = zeros(1,N*2);
col = zeros(1,N*2);
val  = zeros(1,N*2);

cnt = 1;

for x=1:N-1
  row(cnt) = x;
  col(cnt) = x;
  val(cnt) = -1/h;
  cnt = cnt+1;
  
  row(cnt) = x;
  col(cnt) = x+1;
  val(cnt) = 1/h;
  cnt = cnt+1;
end
row = row(1:cnt-1);
col = col(1:cnt-1);
val = val(1:cnt-1);

D = sparse(row,col,val,N,N);

