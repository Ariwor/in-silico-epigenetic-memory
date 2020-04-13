conc_meth = linspace(8*10^-13,4.98*10^-11,100);
conc_meth = [0.0, conc_meth];
conc_dpn1 = [0.0, 1.66e-12];

ratio = [];
for i=1:length(conc_meth)
    m1.Species(3,1).InitialAmount = conc_meth(i);
    m1.Species(1,1).InitialAmount = conc_dpn1(1);
    cs = getconfigset(m1, 'active');
    set(cs, 'StopTime', 1e6);
    [t,x]=sbiosimulate(m1);
    without_input = x(end,4);
    m1.Species(1,1).InitialAmount = conc_dpn1(2);
    [t,x]=sbiosimulate(m1);
    with_input = x(end,4);
    ratio(:,i) = with_input/(without_input);
end
figure;
bar(conc_meth, ratio)
xlabel('Methylated sites concentration [M]', 'fontsize', 12);
ylabel('Ratio of GFP produced between input and no input of synRead', 'fontsize', 12);
title('GFP ratio between basal and induced production', 'fontsize', 13)

