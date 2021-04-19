function [ ] = tool_save_image( imaname,isfval,dpival )
% [ ] = tool_save_image( imaname,isfval,dpival )
%   Saving image simply and crudely.
%   
%   AUTHOR sfhstcn2
%   CONTACT sfh_st_cn2@163.com

set(gcf, 'PaperPositionMode', 'auto');
imaname(imaname=='.') = 'p';
imaname = imaname(imaname~='*');

if isfval==10
    savefig(gcf,imaname);
    return
end
if isfval==2 || isfval==3 || isfval==5 || isfval==7  || isfval==8
    switch isfval
        case 2
            isf = '-dmeta';
        case 3
            isf = '-depsc';
        case 5
            isf = '-dpdf';
        case 7
            isf = '-dpsc';
        case 8
            isf = '-dsvg';
    end
    print(gcf,isf,imaname);
else
    switch isfval
        case 1
            isf = '-dbmp';
        case 4
            isf = '-djpeg';
        case 6
            isf = '-dpng';
        case 9
            isf = '-dtiff';
    end
    switch dpival
        case 1
            dpi = '-r0';
        case 2
            dpi = '-r300';
        case 3
            dpi = '-r600';
        case 4
            dpi = '-r1200';
    end
    print(gcf,isf,imaname,dpi);
end

end

