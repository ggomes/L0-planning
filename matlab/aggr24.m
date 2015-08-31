function Y=aggr24(X)

sz = size(X, 2);

Y = [];
for i = 1:12:277
  Y = [Y sum(X(i:i+11))];
end
