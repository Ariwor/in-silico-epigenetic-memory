%% screening of Km
%Step 1:import model of write module as Write_module_model
params = sbioselect(Write_module_model,'Type','parameter');
cs = getconfigset(Write_module_model, 'active');
set(cs, 'StopTime', 1e6);


meth_ratio_final_wt_gRNA=zeros(10,10);
meth_ratio_final_gRNA=zeros(10,10);

Km_index=1;
for Km=logspace(-4,-8,10)
    b_Km_index=1;
    params(2).Value=Km;
    for b_Km=logspace(1,3,10)
        params(3).Value=(params(2).Value)/b_Km;
        for gRNA=[0,1.66E-12]
            Write_module_model.Species(8).InitialAmount=gRNA;
            [t,x]=sbiosimulate(Write_module_model);
            if(gRNA==0)
                meth_ratio_final_wt_gRNA(Km_index,b_Km_index)=(x(end,6))/(x(end,6)+x(end,7));
            else
                meth_ratio_final_gRNA(Km_index,b_Km_index)=(x(end,6))/(x(end,6)+x(end,7));
            end
        end
        b_Km_index=b_Km_index+1
    end
    Km_index=Km_index+1
end
%%
%plotting the methylated ratio basal
figure;
surf(logspace(-4,-8,10),logspace(1,3,10),transpose(meth_ratio_final_wt_gRNA));
xlabel('Km_{meth}')
ylabel('Km_{meth}/Km_{meth}*')
zlabel('basal methylated ratio')
%%
%plotting the methylated ratio targeted
figure;
surf(logspace(-4,-8,10),logspace(1,3,10),transpose(meth_ratio_final_gRNA));
xlabel('Km_{meth}')
ylabel('Km_{meth}/Km_{meth}*')
zlabel('targeted methylated ratio')
%%
%plotting on/off ratio
figure;
surf(logspace(-4,-8,10),logspace(1,3,10),transpose(meth_ratio_final_gRNA./meth_ratio_final_wt_gRNA));
xlabel('Km_{meth}')
ylabel('Km_{meth}/Km_{meth}*')
zlabel('on/off ratio')
%% Screening of recognition site number and Km*/Km
%
params = sbioselect(Write_module_model,'Type','parameter');
cs = getconfigset(Write_module_model, 'active');
set(cs, 'StopTime', 1e6);


meth_ratio_final_wt_gRNA_scan_RS_bKm=zeros(10,10);
meth_ratio_final_gRNA_scan_RS_bKm=zeros(10,10);

RS_index=1;
for RS=linspace(8.3E-13,3.32E-11,10)
    b_Km_index=1;
    Write_module_model.Species(3).InitialAmount=RS;
    for b_Km=logspace(1,4,10)
        params(3).Value=(params(2).Value)/b_Km;
        for gRNA=[0,1.66E-12]
            Write_module_model.Species(8).InitialAmount=gRNA;
            [t,x]=sbiosimulate(Write_module_model);
            if(gRNA==0)
                meth_ratio_final_wt_gRNA_scan_RS_bKm(RS_index,b_Km_index)=(x(end,6))/(x(end,6)+x(end,7));
            else
                meth_ratio_final_gRNA_scan_RS_bKm(RS_index,b_Km_index)=(x(end,6))/(x(end,6)+x(end,7));
            end
        end
        b_Km_index=b_Km_index+1
    end
    RS_index=RS_index+1
end

%%
%plotting the methylated ratio basal
figure;
surf(linspace(1,40,10),logspace(1,4,10),transpose(meth_ratio_final_wt_gRNA_scan_RS_bKm));
xlabel('number of recognition site')
ylabel('Km_{meth}/Km_{meth}*')
zlabel('basal methylated ratio')
%%
%plotting the methylated ratio targeted
figure;
surf(linspace(1,40,10),logspace(1,4,10),transpose(meth_ratio_final_gRNA_scan_RS_bKm));
xlabel('number of recognition site')
ylabel('Km_{meth}/Km_{meth}*')
zlabel('targeted methylated ratio')
%%
%plotting on/off ratio
figure;
surf(linspace(1,40,10),logspace(1,4,10),transpose(meth_ratio_final_gRNA_scan_RS_bKm./meth_ratio_final_wt_gRNA_scan_RS_bKm));
xlabel('number of recognition site')
ylabel('Km_{meth}/Km_{meth}*')
zlabel('on/off methylation ratio')

%% plotting on/off bar plot before and after parameter scan
params = sbioselect(Write_module_model,'Type','parameter');
cs = getconfigset(Write_module_model, 'active');
set(cs, 'StopTime', 3e5);

%case 1: no gRNA
Write_module_model.Species(8).InitialAmount=0;
%parameters from paper
params(1).Value=0.0155; %k_cat
params(2).Value=4.48E-8; %Km
b_ZF=10; %b_ZF
params(3).Value=4.48E-8/b_ZF;
[t,x]=sbiosimulate(Write_module_model);
ratio_methylated_basal=x(end,6)/(x(end,6)+x(end,7));

%case2: with gRNA
Write_module_model.Species(8).InitialAmount=1.66E-13;

[t,x]=sbiosimulate(Write_module_model);
ratio_methylated_targeted=x(end,6)/(x(end,6)+x(end,7));


% now with selected values:
%case 1: no gRNA
Write_module_model.Species(8).InitialAmount=0;
%parameters from paper
params(1).Value=0.0155; %k_cat
params(2).Value=2.25E-5; %Km
b_ZF=1E4; %b_ZF
params(3).Value=2.25E-5/b_ZF;
[t,x]=sbiosimulate(Write_module_model);
ratio_methylated_basal_n=x(end,6)/(x(end,6)+x(end,7));

%case2: with gRNA
Write_module_model.Species(8).InitialAmount=1.66E-13;

[t,x]=sbiosimulate(Write_module_model);
ratio_methylated_targeted_n=x(end,6)/(x(end,6)+x(end,7));

% we can see that this doesn't work --> change parameters
% via mutations of the enzyme, what range would work ?

X = categorical({'system Off','system On'});
figure;
grid on;
b=bar(X,[ratio_methylated_basal,ratio_methylated_basal_n;ratio_methylated_targeted,ratio_methylated_targeted_n],0.4);
ylabel('methylation ratio');
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = 'Marzabal et al.';
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = 'Screened parameters';
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
