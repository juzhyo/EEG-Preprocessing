function [y] = downsample(x,m,n)

  ## y = downsample(x,m,n) reduces the original sampling rate of a
  ## sequence from m to a lower rate n.

  if m < n
    disp('ERROR: New sampling rate is greater than original sampling rate');
  else
    interval = floor(m/n);
    y = x(:,1:interval:end);
  end
