function arr = lin_smooth(X);

n = size(X, 2);
chng = zeros(1, n);
i = 2;

while i < n
  j = i + 1;
  while j <= n
    if X(j) ~= X(i)
      i = j;
      chng(i) = 1;
      break;
    end
    j = j + 1;
  end
  if j == (n+1)
    i = n;
  end
end

idx = find(chng == 1);
idx = [1 idx];
m = size(idx, 2);

arr = X;

for i = 2:m
  i1 = idx(i - 1);
  i2 = idx(i);

  arr(i1:i2) = linspace(X(i1), X(i2), i2-i1+1);
end
