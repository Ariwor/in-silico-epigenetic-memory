%%
Reset_No_Dilution. Species
%%
conc_Reset = logspace(-10,-8, 10);
Km_demeth = logspace(-8,-6, 10);
AB = [];
A_index = 1;
B_index = 1;
for i=1:length(Km_demeth)
    B_index = 1;
    for j=1:length(conc_Reset)
        %fprintf('it is B:')
        %disp((B_index))       
        Reset_No_Dilution.Parameters(3,1).Value = Km_demeth(i);
        Reset_No_Dilution.Species(1,1).InitialAmount = conc_Reset(j);
        cs = getconfigset(Reset_No_Dilution, 'active')
        set(cs, 'StopTime', 1E5)
        [t,x]=sbiosimulate(Reset_No_Dilution);           
        AB(A_index,B_index)=x(end,3)/(x(end,3)+x(end,2));
        B_index=B_index+1;
    end
    A_index = A_index+1;
    %fprintf('A it is :')
    %disp(A_index)
end
figure;
surf(Km_demeth,conc_Reset,AB');
xlabel('Km_{demethylation}');
ylabel('[synReset]');
title('Ratio of unmethylated sites compared to [synReset] and Km_{demethylation}')
colorbar;

