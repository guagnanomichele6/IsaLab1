library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_maker is  
  port (
    CLK     : in  std_logic;
    RST_n   : in  std_logic;
    sEndSim : in std_logic;
    VOUT    : out std_logic;
    DOUT    : out std_logic_vector(8 downto 0);
    B0      : out std_logic_vector(8 downto 0);
    B1      : out std_logic_vector(8 downto 0);
    B2      : out std_logic_vector(8 downto 0);
    A1      : out std_logic_vector(8 downto 0);
    A2      : out std_logic_vector(8 downto 0));
end data_maker;

architecture beh of data_maker is

constant tco : time := 1 ns;  
signal vout_sign : std_logic;

begin

  B0 <= conv_std_logic_vector(52,9);
  B1 <= conv_std_logic_vector(105,9);
  B2 <= conv_std_logic_vector(52,9);
  A1 <= conv_std_logic_vector(-95,9); 
  A2 <= conv_std_logic_vector(50,9); 

  process (CLK, RST_n)
    file fp_in : text open READ_MODE is "samples.txt";
    variable line_in : line;
    variable x : integer;
  begin
    if RST_n = '0' then 
	VOUT <= '0';
    elsif CLK'event and CLK = '1' then
      if not endfile(fp_in) then
	if(vout_sign = '1') then
          readline(fp_in, line_in);
          read(line_in, x);
          DOUT <= conv_std_logic_vector(x, 9) after tco;
          VOUT <= '1' after tco;
        else
	  DOUT <= "XXXXXXXXX" after tco;
          VOUT <= '0' after tco;  
        end if;
      elsif sEndSim = '1' then
	file_close(fp_in);  
      end if;
     end if;
  end process;

process
  begin
    vout_sign <= '0'; wait for 30ns;
    vout_sign <= not vout_sign; wait for 30ns;
  end process;

end beh;
