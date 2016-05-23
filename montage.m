function [y,heog,veog] = montage(x)

  ## y = montage(x) takes in the data matrix (channels x time) and
  ## returns a re-referenced matrix. In addition HEOG and VEOG are
  ## also returned.

  y = detrend(x(1:128,:));               # EEG data
  heog = x(131,:)-x(132,:);
  veog = x(135,:)-x(136,:);

end
