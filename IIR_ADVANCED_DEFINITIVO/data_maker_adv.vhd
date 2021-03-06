library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_maker_adv is  
				 port ( CLK,RST_n :in std_logic;
						  SMPL_END: out std_logic;	--asserted if all samples have been fed to UUT
						  VOUT    : out std_logic;	--VIN signal of UUT
						  DOUT    : out signed(10 downto 0);	 --sample in input to UUT
						  B0,B1,B2,A1_NEG,A1_2_A2,A1A2: out signed(10 downto 0) --coefficients
						);
end data_maker_adv;

architecture beh of data_maker_adv is

constant tco : time := 1 ns;  
signal vout_sign : std_logic;

begin

  B0 <= to_signed(211,11);
  B1 <= to_signed(423,11);
  B2 <= to_signed(211,11);
  A1_NEG <=  to_signed(379,11); 		--coefficient -a1
  A1_2_A2 <= to_signed(-61,11);		--coefficient a1^2 - a2
  A1A2 <= to_signed(-75,11);			--coefficient a1*a2

  process (CLK,RST_n)
    file fp_in : text open READ_MODE is "samples.txt"; --file where input samples are stored
    variable line_in : line;
    variable x : integer;
	 variable first_run:std_logic:='0';
  
  begin
			if (RST_n = '0') then 
										VOUT <= '0';
										SMPL_END<='0';
										
			elsif (first_run='0') then
					if NOT endfile(fp_in) then
													if (CLK'event and CLK = '1') then
														if(vout_sign = '1') then
														readline(fp_in, line_in);
														read(line_in, x);
														DOUT <= to_signed(x, 11) after tco;
														VOUT <= '1' after tco;
														else									 
														DOUT <= "XXXXXXXXXXX" after tco; --set input to don't care
														VOUT <= '0' after tco;  		 --circuit sees VIN='0'
														end if;
													end if;
												else 
												SMPL_END<='1'	after 6 ns;
												VOUT <= '0' after 6 ns;
												first_run:='1';
												file_close(fp_in);
					end if;
			end if;
  end process;

process					 --vout_sign defines vout pattern, to check the circuit works
							 --even if input samples are not always valid
variable i:integer:=0;

  begin
		 if i<3 then
				  vout_sign <= '1'; 			   wait for 30 ns;
				  vout_sign <= not vout_sign; wait for 30 ns;
				  i:=i+1;
				  
		 else   vout_sign<='1';	--after some not valid input samples
				  wait; 				--all samples are valid
		 end if;										
  end process;

end beh;
