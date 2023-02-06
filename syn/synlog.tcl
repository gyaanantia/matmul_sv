history clear
add_file -verilog /home/gfa2226/fpga/matmul/bram.sv
add_file -verilog /home/gfa2226/fpga/matmul/bram_block.sv
add_file -verilog /home/gfa2226/fpga/matmul/matmul.sv
add_file -verilog /home/gfa2226/fpga/matmul/matmul_top.sv
project -run  
project_file -remove /home/gfa2226/fpga/matmul/bram.sv
project_file -remove /home/gfa2226/fpga/matmul/bram_block.sv
project_file -remove /home/gfa2226/fpga/matmul/matmul.sv
project -run  
project -close /home/gfa2226/fpga/matmul/syn/proj_1.prj
