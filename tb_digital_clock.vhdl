LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_digital_clock IS
END tb_digital_clock;
ARCHITECTURE behavior OF tb_digital_clock IS 

    COMPONENT digital_clock
    PORT(
         clk : IN  std_logic;
         rst_n : IN  std_logic;
         H_in1 : IN  std_logic_vector(1 downto 0);
         H_in0 : IN  std_logic_vector(3 downto 0);
         M_in1 : IN  std_logic_vector(3 downto 0);
         M_in0 : IN  std_logic_vector(3 downto 0);
         H_out1 : OUT  std_logic_vector(6 downto 0);
         H_out0 : OUT  std_logic_vector(6 downto 0);
         M_out1 : OUT  std_logic_vector(6 downto 0);
         M_out0 : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;

   signal clk : std_logic := '0';
   signal rst_n : std_logic := '0';
   signal H_in1 : std_logic_vector(1 downto 0) := (others => '0');
   signal H_in0 : std_logic_vector(3 downto 0) := (others => '0');
   signal M_in1 : std_logic_vector(3 downto 0) := (others => '0');
   signal M_in0 : std_logic_vector(3 downto 0) := (others => '0');


   signal H_out1 : std_logic_vector(6 downto 0);
   signal H_out0 : std_logic_vector(6 downto 0);
   signal M_out1 : std_logic_vector(6 downto 0);
   signal M_out0 : std_logic_vector(6 downto 0);

   constant clk_period : time := 10 ps;
BEGIN

   uut: digital_clock PORT MAP (
          clk => clk,
          rst_n => rst_n,
          H_in1 => H_in1,
          H_in0 => H_in0,
          M_in1 => M_in1,
          M_in0 => M_in0,
          H_out1 => H_out1,
          H_out0 => H_out0,
          M_out1 => M_out1,
          M_out0 => M_out0
        );

   clk_process :process
   begin
 clk <= '0';
 wait for clk_period/2;
 clk <= '1';
 wait for clk_period/2;
   end process;

   stim_proc: process
   begin 

 rst_n <= '0';
 H_in1 <= "01";
 H_in0 <= x"0";
 M_in1 <= x"2";
 M_in0 <= x"0";
      wait for 100 ns; 
 rst_n <= '1';
      wait for clk_period*10;

      wait;
   end process;

END;