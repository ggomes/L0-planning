function ORQ = compute_or_queues(D)

[m, n] = size(D);
ORQ = zeros(m, n);
q = zeros(1, m);

for j = 1:n
  new_q = q + (1/12)*D(:, j)';
  %new_q = max([new_q; zeros(1, m)]);
  ORQ(:, j) = new_q';
  q = new_q;
end


for i = 1:m
  q = ORQ(i, :) - 5*ones(1, n);
  ORQ(i, :) = max([q; zeros(1, n)]);
end

ORQ = round(ORQ);

return;

