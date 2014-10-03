function [m,m_per]= confusion_matrix(truth,predicted,labels)

classes=unique(truth);

horizontal_line_width=70;

m=zeros(length(classes),length(classes));

for outer_index=1:length(classes)
%     true_indices=find(truth==outer_index);
    for inner_index=1:length(classes)
%         m(outer_index,inner_index)=sum(predicted(t)==classes(inner_index));
        m(outer_index,inner_index)=sum((truth==outer_index) & (predicted==inner_index));
%         m(outer_index,inner_index)=sum(predicted(true_indices)==inner_index);
    end    
end

 m_per=100*m./repmat(sum(m,2),1,size(m,2));
 
 m_per=round(m_per*100)/100;
 
 fprintf('\n');
 for display_index=1:horizontal_line_width 
     fprintf('-');
 end
 fprintf('\n');
  fprintf('|');
 for display_index=1:length(classes)
 
     fprintf('\t|%s',cell2mat(labels(display_index)));
 end
 
   fprintf('\n');
for display_index=1:horizontal_line_width 
     fprintf('-');
 end
 
 for display_ph_index=1:length(classes)
     fprintf('\n|%s',cell2mat(labels(display_ph_index)));
    for display_m_index=1:length(classes)
     fprintf('\t|%.1f',m_per(display_ph_index,display_m_index));
    end
    fprintf('\n');
    for display_index=1:horizontal_line_width 
     fprintf('-');
    end

 
 end
 
 fprintf('\n');
 fprintf('Accuracy from confusion matrix is %f \n',sum(diag(m_per)/sum(m_per(:))));