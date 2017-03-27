-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_counter                                                           
--                                                                             
--  Opis:                                                               
--                                                                             
--    Modul broji sekunde i prikazuje na LED diodama                                         
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY timer_counter IS PORT (
                               clk_i     : IN STD_LOGIC; -- ulazni takt
                               rst_i     : IN STD_LOGIC; -- reset signal 
                               one_sec_i : IN STD_LOGIC; -- signal koji predstavlja proteklu jednu sekundu vremena 
                               cnt_en_i  : IN STD_LOGIC; -- signal dozvole brojanja                              
                               cnt_rst_i : IN STD_LOGIC; -- signal resetovanja brojaca (clear signal)
                               led_o     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- izlaz ka led diodama
                             );
END timer_counter;

ARCHITECTURE rtl OF timer_counter IS

SIGNAL counter_value_r  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL next_cnt         : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL mid_cnt          : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL add_cnt          : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL curr_cnt         : STD_LOGIC_VECTOR(7 DOWNTO 0);


COMPONENT reg IS
	GENERIC(
		WIDTH    : POSITIVE := 1;
		RST_INIT : INTEGER := 0
	);
	PORT(
		i_clk  : IN  STD_LOGIC;
		in_rst : IN  STD_LOGIC;
		i_d    : IN  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
		o_q    : OUT STD_LOGIC_VECTOR(WIDTH-1 downto 0)
	);
END COMPONENT reg;


BEGIN

   cnt_reg : reg 
	GENERIC MAP (
	   WIDTH => 8,
		RST_INIT => 0
	)		
	PORT MAP (
	   i_clk => clk_i,
		in_rst => not rst_i,
		i_d => next_cnt,
		o_q => counter_value_r
	);

-- DODATI :
-- brojac koji na osnovu izbrojanih sekundi pravi izlaz na LE diode

   WITH cnt_rst_i SELECT next_cnt <=
        mid_cnt     WHEN '0',
		  "00000000"  WHEN OTHERS;
		  
   WITH cnt_en_i  SELECT mid_cnt <=
	     curr_cnt              WHEN   '1',
		  counter_value_r       WHEN OTHERS;

	WITH one_sec_i        SELECT curr_cnt <=
	     add_cnt          WHEN '1',
		  counter_value_r  WHEN OTHERS;  

  
   add_cnt <= counter_value_r + 1;  
	
	
	led_o   <= counter_value_r;



END rtl;