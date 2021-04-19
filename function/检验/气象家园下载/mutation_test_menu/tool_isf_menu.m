function [  ] = tool_isf_menu( isfvalin,dpivalin )
%[  ] = tool_isf_menu( isfvalin,dpivalin )
%   Add a menu on figures for image saving.
%   
%   AUTHOR sfhstcn2
%   CONTACT sfh_st_cn2@163.com

if nargin<2
    dpivalin = [];
end
if nargin<1
    isfvalin = [];
end
if isempty(isfvalin)
    isfvalin = 9;
end
if isempty(dpivalin)
    dpivalin = 3;
end
his = uimenu('label','Image Saving','callback', ... 
    ['phf=flipud(get(gcbo,''children''));phcf=flipud(get(phf(2),''children''));phcd=flipud(get(phf(3),''children''));' ... 
    'for i=1:length(phcf) if strcmp(get(phcf(i),''checked''),''on'') isfval=i; break; end; end;' ... 
    'for i=1:length(phcd) if strcmp(get(phcd(i),''checked''),''on'') dpival=i; break; end; end;' ...
    'clear i phf phcf phcd;']);
hn = uimenu(his,'label','Path\Name','callback',['nin=get(gcf,''Name'');' ... 
    'imaname=inputdlg({''Path\Name''},''Input'',1,{nin});' ... 
    'if isempty(imaname) imaname=nin; end;' ...
    'set(gcf,''Name'',char(imaname));clear nin']);
hf = uimenu(his,'label','Format');
hfc(1) = uimenu(hf,'label','*.bmp','callback','isfval=1;b=1:10;b=b(b~=isfval);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(isfval),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
hfc(2) = uimenu(hf,'label','*.emf','callback','isfval=2;b=1:10;b=b(b~=isfval);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(isfval),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
hfc(3) = uimenu(hf,'label','*.eps','callback','isfval=3;b=1:10;b=b(b~=isfval);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(isfval),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
hfc(4) = uimenu(hf,'label','*.jpg','callback','isfval=4;b=1:10;b=b(b~=isfval);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(isfval),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
hfc(5) = uimenu(hf,'label','*.pdf','callback','isfval=5;b=1:10;b=b(b~=isfval);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(isfval),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
hfc(6) = uimenu(hf,'label','*.png','callback','isfval=6;b=1:10;b=b(b~=isfval);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(isfval),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
hfc(7) = uimenu(hf,'label','*.ps','callback','isfval=7;b=1:10;b=b(b~=isfval);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(isfval),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
hfc(8) = uimenu(hf,'label','*.svg','callback','isfval=8;b=1:10;b=b(b~=isfval);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(isfval),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
hfc(9) = uimenu(hf,'label','*.tif','callback','isfval=9;b=1:10;b=b(b~=isfval);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(isfval),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
hfc(10) = uimenu(hf,'label','*.fig','callback','isfval=10;b=1:10;b=b(b~=isfval);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(isfval),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
set(hfc(isfvalin),'checked','on');
hd = uimenu(his,'label','DPI');
hdc(1) = uimenu(hd,'label','0','callback','dpival=1;b=1:4;b=b(b~=dpival);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(dpival),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
hdc(2) = uimenu(hd,'label','300','callback','dpival=2;b=1:4;b=b(b~=dpival);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(dpival),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
hdc(3) = uimenu(hd,'label','600','callback','dpival=3;b=1:4;b=b(b~=dpival);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(dpival),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
hdc(4) = uimenu(hd,'label','1200','callback','dpival=4;b=1:4;b=b(b~=dpival);phc=flipud(get(get(gcbo,''parent''),''children''));set(phc(dpival),''checked'',''on'');set(phc(b),''checked'',''off'');clear b phc;');
set(hdc(dpivalin),'checked','on');
hsi = uimenu(his,'label','Saving It');
set(hsi,'callback',['imaname = get(gcf,''Name'');' ... 
    'if isempty(imaname) imaname = ''FIGURE''; end;' ...
    'tool_save_image( imaname,isfval,dpival );' ... 
    'disp(''========Saving Current Image Complete!========'')']);


end

