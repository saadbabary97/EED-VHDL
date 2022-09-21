library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity digital_clock is
port ( 
 clk: in std_logic; 
 
 rst_n: in std_logic; 

 H_in1: in std_logic_vector(1 downto 0);

 H_in0: in std_logic_vector(3 downto 0);
  
 M_in1: in std_logic_vector(3 downto 0);
  
 M_in0: in std_logic_vector(3 downto 0);
 
 H_out1: out std_logic_vector(6 downto 0);
 
 H_out0: out std_logic_vector(6 downto 0);
 
 M_out1: out std_logic_vector(6 downto 0);
 
 M_out0: out std_logic_vector(6 downto 0)
 
 );
end digital_clock;
architecture Behavioral of digital_clock is
component bin2hex
port (
 Bin: in std_logic_vector(3 downto 0);
 Hout: out std_logic_vector(6 downto 0)
 );
end component;
component clk_div
port (
 clk_50: in std_logic;
 clk_1s: out std_logic
     );
end component;

signal clk_1s: std_logic; 
signal counter_hour, counter_minute, counter_second: integer;

signal H_out1_bin: std_logic_vector(3 downto 0); 
signal H_out0_bin: std_logic_vector(3 downto 0);
signal M_out1_bin: std_logic_vector(3 downto 0);
signal M_out0_bin: std_logic_vector(3 downto 0);
begin

create_1s_clock: clk_div port map (clk_50 => clk, clk_1s => clk_1s); 

process(clk_1s,rst_n) begin 

  if(rst_n = '0') then
 counter_hour <= to_integer(unsigned(H_in1))*10 + to_integer(unsigned(H_in0));
 counter_minute <= to_integer(unsigned(M_in1))*10 + to_integer(unsigned(M_in0));
 counter_second <= 0;
 elsif(rising_edge(clk_1s)) then
 counter_second <= counter_second + 1;
 if(counter_second >=59) then 
 counter_minute <= counter_minute + 1;
 counter_second <= 0;
 if(counter_minute >=59) then 
 counter_minute <= 0;
 counter_hour <= counter_hour + 1;
 if(counter_hour >= 24) then 
 counter_hour <= 0;
 end if;
 end if;
 end if;
 end if;
end process;

 H_out1_bin <= x"2" when counter_hour >=20 else
 x"1" when counter_hour >=10 else
 x"0";

convert_hex_H_out1: bin2hex port map (Bin => H_out1_bin, Hout => H_out1); 

 H_out0_bin <= std_logic_vector(to_unsigned((counter_hour - to_integer(unsigned(H_out1_bin))*10),4));

convert_hex_H_out0: bin2hex port map (Bin => H_out0_bin, Hout => H_out0); 

 M_out1_bin <= x"5" when counter_minute >=50 else
 x"4" when counter_minute >=40 else
 x"3" when counter_minute >=30 else
 x"2" when counter_minute >=20 else
 x"1" when counter_minute >=10 else
 x"0";

convert_hex_M_out1: bin2hex port map (Bin => M_out1_bin, Hout => M_out1); 

 M_out0_bin <= std_logic_vector(to_unsigned((counter_minute - to_integer(unsigned(M_out1_bin))*10),4));

convert_hex_M_out0: bin2hex port map (Bin => M_out0_bin, Hout => M_out0); 
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
entity bin2hex is
port (
 Bin: in std_logic_vector(3 downto 0);
 Hout: out std_logic_vector(6 downto 0)
);
end bin2hex;
architecture Behavioral of bin2hex is
begin
 process(Bin)
 begin
  case(Bin) is
   when "0000" =>  Hout <= "1000000"; 
   when "0001" =>  Hout <= "1111001"; 
   when "0010" =>  Hout <= "0100100"; 
   when "0011" =>  Hout <= "0110000"; 
   when "0100" =>  Hout <= "0011001"; 
   when "0101" =>  Hout <= "0010010";
   when "0110" =>  Hout <= "0000010"; 
   when "0111" =>  Hout <= "1111000";    
   when "1000" =>  Hout <= "0000000"; 
   when "1001" =>  Hout <= "0010000"; 
   when "1010" =>  Hout <= "0001000"; 
   when "1011" =>  Hout <= "0000011"; 
   when "1100" =>  Hout <= "1000110";
   when "1101" =>  Hout <= "0100001"; 
   when "1110" =>  Hout <= "0000110"; 
   when others =>  Hout <= "0001110"; 
   end case;
 end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
entity clk_div is
port (
   clk_50: in std_logic;
   clk_1s: out std_logic
  );
end clk_div;
architecture Behavioral of clk_div is
signal counter: std_logic_vector(27 downto 0):=(others =>'0');
begin
 process(clk_50)
 begin
  if(rising_edge(clk_50)) then
   counter <= counter or x"0000001";
   if(counter>=x"2FAF080") then 
  
    counter <= x"0000000";
   end if;
  end if;
 end process;
 clk_1s <= '0' when counter < x"17D7840" else '1';
end Behavioral;