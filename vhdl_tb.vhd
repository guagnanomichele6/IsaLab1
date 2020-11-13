LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_textio.all;
USE std.textio.all;

ENTITY IIR_TB IS
END ENTITY;

ARCHITECTURE TEST OF IIR_TB IS

COMPONENT IIR_FILTER IS 
							PORT
							(	din,b0,b1,b2,a1,a2: IN SIGNED(8 DOWNTO 0);
								clk,vin,rst_n:IN STD_LOGIC;
								dout:	OUT SIGNED(8 DOWNTO 0);
								vout:	OUT STD_LOGIC
							);
END COMPONENT;

SIGNAL clk,rst_n,vin,vout:STD_LOGIC;
SIGNAL din,dout,b0,b1,b2,a1,a2:SIGNED(8 DOWNTO 0);
FILE input_file:TEXT;
FILE output_file:TEXT;

BEGIN


CLK_GEN: 		PROCESS
					BEGIN
					clk<='0'; WAIT FOR 50 ns;
					clk<='1'; WAIT FOR 50	ns;
					END PROCESS;
			
RST_GEN: 		PROCESS
					BEGIN
					rst_n<='0'; WAIT FOR 200 ns;
					rst_n<='1'; WAIT;
					END PROCESS;
					
VIN_GEN: 		PROCESS
					BEGIN
					VIN<='0'; WAIT FOR 300 ns;
					VIN<='1'; WAIT;
					END PROCESS;
					
			
DIN_GEN:			PROCESS
					VARIABLE input_line,output_line:LINE;
					VARIABLE sample,i,b_0,b_1,b_2,a_1,a_2,d_out:INTEGER;
					
					
					BEGIN
					WAIT FOR 300 ns;
					b_0:=52;				--coeff definition
					b_1:=105;
					b_2:=52;
					a_1:=-95;-- -a1
					a_2:=50;-- -a2
					
					b0<=to_signed(b_0,9);
					b1<=to_signed(b_1,9);
					b2<=to_signed(b_2,9);
					a1<=to_signed(a_1,9);
					a2<=to_signed(a_2,9);
					
					FILE_OPEN(input_file,"samples.txt",read_mode);
					FILE_OPEN(output_file,"results_vhdl.txt",write_mode);
					
					i:=0;
					
					WHILE (i<201) LOOP
											
											readline(input_file,input_line);
											read(input_line,sample);
											din<=to_signed(sample,9);
											i:=i+1;
											WAIT FOR 100 ns;
														IF (i>1) THEN 
														d_out:=to_integer(dout);
														write(output_line,d_out);
														writeline(output_file,output_line);
														END IF;
														
											
										END LOOP;
					WAIT FOR 100 ns;	
														
					d_out:=to_integer(dout);		--last output write
					write(output_line,d_out);
					writeline(output_file,output_line);
													
					WAIT;
					END PROCESS;

DUT:	IIR_FILTER PORT MAP(din,b0,b1,b2,a1,a2,clk,vin,rst_n,dout,vout);
END ARCHITECTURE;