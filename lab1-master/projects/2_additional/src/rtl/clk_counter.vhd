-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_counter                                                          
--                                                                             
--  Opis:                                                               
--                                                                             
--    Modul odogvaran za indikaciju o proteku sekunde
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY clk_counter IS GENERIC(
                              -- maksimalna vrednost broja do kojeg brojac broji
                              max_cnt : STD_LOGIC_VECTOR(25 DOWNTO 0) := "10111110101111000010000000" -- 50 000 000
                             );
                      PORT   (
                               clk_i     : IN  STD_LOGIC; -- ulazni takt
                               rst_i     : IN  STD_LOGIC; -- reset signal
                               cnt_en_i  : IN  STD_LOGIC; -- signal dozvole brojanja
                               cnt_rst_i : IN  STD_LOGIC; -- signal resetovanja brojaca (clear signal)
                               one_sec_o : OUT STD_LOGIC  -- izlaz koji predstavlja proteklu jednu sekundu vremena
                             );
END clk_counter;



ARCHITECTURE rtl OF clk_counter IS

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


SIGNAL   cnt_r     : STD_LOGIC_VECTOR(25 DOWNTO 0);
SIGNAL   next_cnt  : STD_LOGIC_VECTOR(25 DOWNTO 0);
SIGNAL   mid_cnt   : STD_LOGIC_VECTOR(25 DOWNTO 0);
SIGNAL   add_cnt   : STD_LOGIC_VECTOR(25 DOWNTO 0);
SIGNAL   curr_cnt  : STD_LOGIC_VECTOR(25 DOWNTO 0);
SIGNAL   one_sec  :  STD_LOGIC;


BEGIN

   cnt_reg : reg 
	GENERIC MAP (
	   WIDTH => 26,
		RST_INIT => 0
	)		
	PORT MAP (
	   i_clk => clk_i,
		in_rst => not rst_i,
		i_d => next_cnt,
		o_q => cnt_r
	);

-- DODATI:
-- brojac koji kada izbroji dovoljan broj taktova generise SIGNAL one_sec_o koji
-- predstavlja jednu proteklu sekundu, brojac se nulira nakon toga

   WITH cnt_rst_i SELECT next_cnt <=
        mid_cnt     WHEN '0',
		  "00000000000000000000000000" WHEN OTHERS;
 
   WITH cnt_en_i  SELECT mid_cnt <=
	     curr_cnt    WHEN   '1',
		  cnt_r       WHEN OTHERS;
	
	WITH one_sec   SELECT curr_cnt <=
	     add_cnt     WHEN '0',
		  "00000000000000000000000000" WHEN OTHERS;
		  
   add_cnt  <= cnt_r + 1;
 
   one_sec 	<= '1' WHEN cnt_r = max_cnt - 1 ELSE
	            '0';
					
   one_sec_o <= one_sec;

END rtl;