addpath('E:\Face Recognition\Gabor_Project_v5\lib');

R = 128; C = 128;

% create_selected_filter(R,C);

create_gcc_filter(R,C);
create_gcs_filter(R,C);
create_gsc_filter(R,C);
create_gss_filter(R,C);

for v = 0:4
    create_gcv_filter(R,C,v);
    create_gsv_filter(R,C,v);
end

for u = 0:7
    create_gmuc_filter(R,C,u);
    create_gmus_filter(R,C,u);
end

for v = 0:4
    for u = 0:7
        create_gmuv_filter(R,C,v,u);
    end
end

msgbox('finished');