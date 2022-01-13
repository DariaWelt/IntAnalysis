function [] = plotBox(x, m)
  plot([inf(x(1)), inf(x(1)), sup(x(1)), sup(x(1)), inf(x(1))], [inf(x(2)), sup(x(2)), sup(x(2)), inf(x(2)), inf(x(2))], m)
  hold on
  plot(mid(x(1)), mid(x(2)))
  hold on
endfunction