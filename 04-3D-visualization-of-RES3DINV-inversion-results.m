%% ----------- 3D-visualization-of-RES3DINV-inversion-results -------------
%
% Adrien Dimech - Master Project - 22/04/2018
%
% -------------------------------------------------------------------------
% Matlab codes to prepare - process - visualize and interpret 3D time-lapse
% geolelectrical monitoring of a waste rock pile.
% -------------------------------------------------------------------------
%
% This Matlab code was used to load inversion results from RES3DINV
% inversion software and provide 3D visualizations of resistivity and
% sensitivity distribution. Several tools are provided to the user to
% identify the best 3D visualizations of the data. 
%
% Feel free to visit : https://www.researchgate.net/profile/Adrien_Dimech
% for more information about my research or contact me for more information
% and data files : adrien.dimech@gmail.com
%
%% CODE DE VISUALISATION DES RESISTIVITES 3D
for o=1
    % -------------------------------------------------------------------------
    %
    %
    %                           Suivi du code
    % -------------------------------------------------------------------------
    % Creation          |       20/11/2016        |     Adrien Dimech
    % -------------------------------------------------------------------------
    
    %% 0) Chargement des donnees
    % Creation le 20/11/2016
    close all
    clear all
    indfig =0;
    
    load('ELEC.mat')
    IMAGE1 = xlsread('results.xlsx',2);
    
    %% 1) Traitement des donnees de resistivités
    % Creation le 20/11/2016
    for o=1
        IMAGE2 = IMAGE1;
        IMAGE2(:,3)=IMAGE2(:,3)+7;
        
        % Colonne des resistivites
        colonne = 4;
        
        data2(:,1:3) = IMAGE2(:,1:3);
        %minV = min(IMAGE2(:,colonne));
        
        YSelect = menu('Quel abscisse de la coupe ?','Y = 0.5 m','Y = 2 m','Y = 4 m','Y = 5 m','Y = 6 m','Y = 8 m','Y = 10 m');
        YChoix = [0.5 , 2, 4, 5,6, 8,10];
        YSelect=YChoix(1,YSelect);
        
        data2(:,4) = log(abs(log(IMAGE2(:,colonne))));
    end
    
    %% 2) Maillage de la halde 3D
    % Creation le 20/11/2016
    for o=1
        pas = 0.5;
        dX = pas; %résolution spatiale en X
        dY = pas; %résolution spatiale en Y
        dZ = pas; %résolution spatiale en Z
        [X,Y,Z] = meshgrid(0:dX:60,0:dY:10,0:dZ:7);
    end
    
    %% 3) Représentation des données 3D
    % Creation le 20/11/2016
    for o=1
        figure('color',[1 1 1])
        hold on
        
        % Interpolation
        clearvars F;
        F = scatteredInterpolant(data2(:,1),data2(:,2),data2(:,3),data2(:,4),'natural');
        vq = F(X,Y,Z);
        ValAffichee = vq;
        
        % Mise en forme de la figure
        daspect([1,1,1])
        axis tight
        ax = gca;
        ax.FontSize = 13;
        view(-38.5,16)
        light('Position',[40 -10 50],'Style','local')
        camzoom(1.8)
        camproj perspective
        colormap ((jet(100)))               % POUR SAGEEP
        %colormap (flipud(gray(100)))       % POUR NSGL
        cmap = colormap;
        
        % Légende logarithmique
        colorbar
        caxis([1.5 2.3])
        TicksM = [1.5;1.6;1.7;1.8;1.9;2.0;2.1;2.2;2.3];
        TicksL = round(exp(exp(TicksM)),0);
        colorbar('Ticks',TicksM,'TickLabels',{num2str(TicksL)},'FontSize', 12)
        colorbar.Label.String = 'Resistivity in Ohm.m';
        
        % Plans d'interet
        p2 = slice(X,Y,Z,ValAffichee,[],YSelect,[]);
        p2.FaceColor = 'interp';
        p2.EdgeColor = 'none';
        line([0 60],[YSelect YSelect],[0 0],'LineWidth',0.5,'Color','k')
        line([0 60],[YSelect YSelect],[7 7],'LineWidth',0.5,'Color','k')
        line([0 0],[YSelect YSelect],[0 7],'LineWidth',0.5,'Color','k')
        line([60 60],[YSelect YSelect],[0 7],'LineWidth',0.5,'Color','k')
        
        p4 = slice(X,Y,Z,ValAffichee,60,[],[]);
        p4.FaceColor = 'interp';
        p4.EdgeColor = 'none';
        
        p3 = slice(X,Y,Z,ValAffichee,[],[],0);
        p3.FaceColor = 'interp';
        p3.EdgeColor = 'none';
        
        
        % Affichage des volumes (UNE seule valeur de coupure)
        Valeur=1.9;
        v2 = Valeur - 1.5;
        v3 = round(v2*100/0.8);
        p1=patch(isocaps(X,Y,Z,ValAffichee,Valeur,'enclose','above'),...
            'FaceColor','interp','EdgeColor','none');
        p1 = patch(isosurface(X,Y,Z,ValAffichee,Valeur,'enclose','above'),...
            'FaceColor',cmap(v3,:),'EdgeColor','none');
        isonormals(X,Y,Z,ValAffichee,p1)
        
        % Affichage des volumes (DEUX valeurs de coupure)
        % val = ValAffichee;
        % val(val>2.09999)=nan;
        % v4 = round((1.9-1.5)*100/0.8);
        % p1=patch(isocaps(X,Y,Z,val,1.9,'enclose','above'),'FaceColor','interp','EdgeColor','none');
        % p1 = patch(isosurface(X,Y,Z,val,1.9,'enclose','above'),'FaceColor',cmap(v4,:),'EdgeColor','none');
        % isonormals(X,Y,Z,ValAffichee,p1)
        %
        % val2 = ValAffichee;
        % val2(val2<1.95)=nan;
        % v5 = round((2.1-1.5)*100/0.8);
        % p2=patch(isocaps(X,Y,Z,val2,2.1,'enclose','below'),'FaceColor','interp','EdgeColor','none');
        % p2 = patch(isosurface(X,Y,Z,val2,2.1,'enclose','below'),'FaceColor',cmap(v5,:),'EdgeColor','none');
        
        
        % Légende et titre
        xlabel('X (m)', 'FontSize', 12,'FontWeight','bold')
        ylabel('Y (m)', 'FontSize', 12,'FontWeight','bold')
        zlabel('Z (m)', 'FontSize', 12,'FontWeight','bold')
        xlim([0 60]);
        ylim([0 10]);
        zlim([0 7]);
        
        % Mise en forme de la halde 3D
        line([0 0],[0 10],[7 7],'LineWidth',1,'Color','k')
        line([0 0],[0 10],[0 0],'LineWidth',1,'Color','k')
        line([60 60],[0 10],[7 7],'LineWidth',1,'Color','k')
        line([60 60],[0 10],[0 0],'LineWidth',1,'Color','k')
        line([0 0],[10 10],[0 7],'LineWidth',1,'Color','k')
        line([0 0],[0 0],[0 7],'LineWidth',1,'Color','k')
        line([60 60],[10 10],[0 7],'LineWidth',1,'Color','k')
        line([60 60],[0 0],[0 7],'LineWidth',1,'Color','k')
        line([0 60],[0 0],[7 7],'LineWidth',1,'Color','k')
        line([0 60],[10 10],[7 7],'LineWidth',1,'Color','k')
        line([0 60],[0 0],[0 0],'LineWidth',1,'Color','k')
        line([0 60],[10 10],[0 0],'LineWidth',1,'Color','k')
        
        % Affichage des électrodes (approximation halde rectangulaire)
        for i=1:192
            plot3(ELEC(i,5),ELEC(i,6),(ELEC(i,7)~=0.1)*6+0.5,'k.','MarkerSize',10)
        end
    end
end

%% CODE DE VISUALISATION DES SENSIBILITES 3D
for o=1
    % -------------------------------------------------------------------------
    %
    %
    %                           Suivi du code
    % -------------------------------------------------------------------------
    % Creation          |       20/11/2016        |     Adrien Dimech
    % -------------------------------------------------------------------------
    
    %% 0) Chargement des donnees
    % Creation le 20/11/2016
    for o=1
        close all
        clear all
        indfig =0;
        
        load('ELEC.mat')
        IMAGE1 = xlsread('results.xlsx',2);
    end
    
    %% 1) Traitement des donnees de sensibilites
    % Creation le 20/11/2016
    for o=1
        IMAGE2 = IMAGE1;
        IMAGE2(:,3)=IMAGE2(:,3)+7;
        
        % Colonne des sensibilites
        colonne = 4;
        data2(:,1:3) = IMAGE2(:,1:3);
        data2(:,4) = log(abs(IMAGE2(:,colonne)))+3;
    end
    
    %% 2) Maillage de la halde 3D
    % Creation le 20/11/2016
    for o=1
        pas = 0.5;
        dX = pas; %résolution spatiale en X
        dY = pas; %résolution spatiale en Y
        dZ = pas; %résolution spatiale en Z
        [X,Y,Z] = meshgrid(0:dX:60,0:dY:10,0:dZ:7);
    end
    
    %% 3) Représentation des données 3D
    % Creation le 20/11/2016
    for o=1
        figure('color',[1 1 1])
        hold on
        
        % Interpolation
        clearvars F;
        F = scatteredInterpolant(data2(:,1),data2(:,2),data2(:,3),data2(:,4),'natural');
        vq = F(X,Y,Z);
        ValAffichee = vq;
        
        % Plans d'interet
        p1 = slice(X,Y,Z,ValAffichee,[],[],0);
        p1.FaceColor = 'interp';
        p1.EdgeColor = 'none';
        
        p1 = slice(X,Y,Z,ValAffichee,[],[],1);
        p1.FaceColor = 'interp';
        p1.EdgeColor = 'none';
        
        YSelect = 6;
        p2 = slice(X,Y,Z,ValAffichee,[],YSelect,[]);
        p2.FaceColor = 'interp';
        p2.EdgeColor = 'none';
        line([0 60],[YSelect YSelect],[0 0],'LineWidth',0.5,'Color','k')
        line([0 60],[YSelect YSelect],[7 7],'LineWidth',0.5,'Color','k')
        line([0 0],[YSelect YSelect],[0 7],'LineWidth',0.5,'Color','k')
        line([60 60],[YSelect YSelect],[0 7],'LineWidth',0.5,'Color','k')
        
        % Mise en forme de la figure
        daspect([1,1,1])
        axis tight
        ax = gca;
        ax.FontSize = 13;
        view(-38.5,16)
        camzoom(1.75)
        camproj perspective
        lightangle(20,45)
        colormap (flipud(hot(10)))          % POUR SAGEEP
        %colormap (flipud(gray(10)))        % POUR NSGL
        
        % Légende et titre
        xlabel('X (m)', 'FontSize', 12,'FontWeight','bold')
        ylabel('Y (m)', 'FontSize', 12,'FontWeight','bold')
        zlabel('Z (m)', 'FontSize', 12,'FontWeight','bold')
        xlim([0 60]);
        ylim([0 10]);
        zlim([0 7]);
        
        % Légende logarithmique
        colorbar
        
        caxis([0 6])
        TicksM = [0;1;2;3;4;5;6];
        TicksL = round(exp(TicksM-3),1);
        colorbar('Ticks',TicksM,'TickLabels',{num2str(TicksL)},'FontSize', 12)
        
        % Mise en forme de la halde 3D
        line([0 0],[0 10],[7 7],'LineWidth',1,'Color','k')
        line([0 0],[0 10],[0 0],'LineWidth',1,'Color','k')
        line([60 60],[0 10],[7 7],'LineWidth',1,'Color','k')
        line([60 60],[0 10],[0 0],'LineWidth',1,'Color','k')
        line([0 0],[10 10],[0 7],'LineWidth',1,'Color','k')
        line([0 0],[0 0],[0 7],'LineWidth',1,'Color','k')
        line([60 60],[10 10],[0 7],'LineWidth',1,'Color','k')
        line([60 60],[0 0],[0 7],'LineWidth',1,'Color','k')
        line([0 60],[0 0],[7 7],'LineWidth',1,'Color','k')
        line([0 60],[10 10],[7 7],'LineWidth',1,'Color','k')
        line([0 60],[0 0],[0 0],'LineWidth',1,'Color','k')
        line([0 60],[10 10],[0 0],'LineWidth',1,'Color','k')
        
        % Affichage des électrodes (approximation halde rectangulaire)
        for i=1:192
            plot3(ELEC(i,5),ELEC(i,6),(ELEC(i,7)~=0.1)*6+0.5,'k.','MarkerSize',10)
        end
    end
end
