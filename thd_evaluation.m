fp_results='results_vhdl.txt';
input_file=fopen(fp_results,'r');
for i=1:201
    tmp=fgetl(input_file);
    results_vhdl(i)=sscanf(tmp,'%f');
end
thd(results_vhdl,10000,5)
fclose(input_file)
max_error=max(abs(resultsc-results_vhdl))

