--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:48:53 03/15/2017
-- Design Name:   
-- Module Name:   C:/Users/Miroslav/Desktop/LPRS/LPRS2/lab1-master/projects/1_basic/top_tb.vhd
-- Project Name:  lab1_basic
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         i_clk : IN  std_logic;
         in_rst : IN  std_logic;
         i_sw : IN  std_logic_vector(7 downto 0);
         in_btn : IN  std_logic_vector(4 downto 0);
         o_led : OUT  std_logic_vector(7 downto 0);
         o_7_segm : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_clk : std_logic := '0';
   signal in_rst : std_logic := '0';
   signal i_sw : std_logic_vector(7 downto 0) := (others => '0');
   signal in_btn : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal o_led : std_logic_vector(7 downto 0);
   signal o_7_segm : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant i_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          i_clk => i_clk,
          in_rst => in_rst,
          i_sw => i_sw,
          in_btn => in_btn,
          o_led => o_led,
          o_7_segm => o_7_segm
        );

   -- Clock process definitions
   i_clk_process :process
   begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
         in_rst <= '0';
         i_sw   <= "00000000";
         in_btn <= "00000";
      wait for i_clk_period*10;
         in_rst <= '1';
         i_sw   <= "00000100";
         in_btn <= "00000";		
      wait for i_clk_period*5;
         in_rst <= '1';
         i_sw   <= "00000000";
         in_btn <= "00000";			
      wait for i_clk_period*100;
         in_rst <= '1';
         i_sw   <= "00000010";
         in_btn <= "00000";

      wait for i_clk_period*30;
         in_rst <= '1';
         i_sw   <= "00000000";
         in_btn <= "00000";

      wait for i_clk_period*10;
         in_rst <= '1';
         i_sw   <= "00001000";
         in_btn <= "00000";			
			


      -- insert stimulus here 

      wait;
   end process;

END;
