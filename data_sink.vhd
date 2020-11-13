library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_sink is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    VIN   : in std_logic;
    DIN   : in std_logic_vector(8 downto 0);
    sEndSim : out std_logic);
end data_sink;

architecture beh of data_sink is

COMPONENT FLIP_FLOP IS
					PORT (
							d:IN STD_LOGIC;
							clk,rst_n,en:IN STD_LOGIC;
							q:OUT STD_LOGIC
							);
END COMPONENT;

signal EndSim,endsim_tmp,endsim_in : std_logic;

begin
  process (CLK, RST_n)
    variable line_out : line;  
      file res_fp : text open WRITE_MODE is "results.txt"; 
  begin
    if RST_n = '0' then
      endsim_in <= '0';
      EndSim <= '0';
    elsif CLK'event and CLK = '1' then
      if (VIN = '1') then
	EndSim<='1' after 1 ns;
        write(line_out, conv_integer(signed(DIN)));
        writeline(res_fp, line_out);
	endsim_in <= '0';
      end if;
      if(VIN = '0' and EndSim = '1') then
	endsim_in <= '1';
      end if;
    end if;
  end process;


e_ff_1: FLIP_FLOP	PORT MAP(endsim_in,clk,rst_n,vin,endsim_tmp);
e_ff_2: FLIP_FLOP	PORT MAP(endsim_tmp,clk,rst_n,vin,sEndSim);

end beh;
