function [permdRunOrder] = getPmdRunOrd(runOrder,globals)
permdRunOrder = nan(size(runOrder));

for ii=1:numel(permdRunOrder)
    if ~isnan(runOrder(ii))
        baseid = runOrder(ii);
        permdRunOrder(ii) = globals.imgPerms(baseid);
    end
end
return