function A = random_graph(n, p)
  % generate an n*n random Array with chance p per entry to be 1
  A=(rand(n,n)<p);
  % clear diagonal Elements out of it
  A=A-diag(diag(A)==1);
end