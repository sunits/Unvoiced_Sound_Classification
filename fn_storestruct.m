function [] = fn_storestruct(X,ParCode)

% This function writes a structure to files
% X contains fields:
% feat      : feature vectors of the corresponding file
% numfeat   : number of features for the file
% file      : name or path of the file
%
% ParCode   : Parameter Code (see page 89 of HTK Book v3.4.1 or above)
%             (default value : 8198 (MFCC_0))

N = size(X,2);

% Some default values
period = 100000;
if ~exist('ParCode','var'), ParCode = 8198; end

ParCode = rem(ParCode,2.^12)+2.^13*floor(ParCode/2.^13);

ncomp = size(X(1).feat,1);
NumByte = 4 * ncomp;

% h = waitbar(0,'Storing files');
fprintf(1,'Storing Files...\n');

for i = 1:N
    % Store each utterance
    Y = X(i).feat;
    
    % waitbar(i/N,h);
    fprintf(1, '\rWriting file %d of %d: %s', i, N, X(i).file);
    f = fopen(X(i).file,'w');
    fwrite(f,size(X(i).feat,2),'int32',0,'ieee-le');
    fwrite(f,period,'int32',0,'ieee-le');
    fwrite(f,NumByte,'int16',0,'ieee-le');
    fwrite(f,ParCode,'int16',0,'ieee-le');
    

    v = zeros(1,size(X(i).feat,2)*ncomp);
    for j=1:size(X(i).feat,2)
        inival = (j-1)*ncomp+1;
        v(inival:inival+ncomp-1) = Y(:,j);
    end
    
    fwrite(f,v,'float',0,'ieee-le');
    fclose(f);
end
%close(h);
fprintf(1,'... Done\n');

end
