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
                              clk_i         : IN STD_LOGIC;                    -- ulazni takt
                              rst_i         : IN STD_LOGIC;                    -- reset aktivan 
                              one_sec_i     : IN STD_LOGIC;                    -- signal koji predstavlja proteklu jednu sekundu vremena 
                              cnt_en_i      : IN STD_LOGIC;                    -- signal dozvole brojanja
                              cnt_rst_i     : IN STD_LOGIC;                    -- signal resetovanja brojaca (clear signal)

                              -- modul se prosiruje sa dva ulaza koji predstavljaju stanja tastera

                              button_min_i  : IN STD_LOGIC;                    -- taster koji cijim se aktiviranjem na LE diodama prikazuju protekle minute
                              button_hour_i : IN STD_LOGIC;                    -- taster koji cijim se aktiviranjem na LE diodama prikazuju protekli sati
                              led_o         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- izlaz ka LE diodama
                             );
END timer_counter;

ARCHITECTURE rtl OF timer_counter IS

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


SIGNAL counter_value_s   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL counter_value_m   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL counter_value_h   : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL next_cnt_s         : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL mid_cnt_s          : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL add_cnt_s          : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL add_cnt_s_mux      : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL curr_cnt_s         : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL next_cnt_m         : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL mid_cnt_m          : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL add_cnt_m          : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL add_cnt_m_mux      : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL curr_cnt_m         : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL next_cnt_h        : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL mid_cnt_h          : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL add_cnt_h          : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL curr_cnt_h         : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL one_min            :  STD_LOGIC;
SIGNAL one_hour           :  STD_LOGIC;

SIGNAL time_sel          : STD_LOGIC_VECTOR(1 DOWNTO 0); 

SIGNAL time_val         : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

   sec_cnt_reg : reg 
	GENERIC MAP (
	   WIDTH => 8,
		RST_INIT => 0
	)		
	PORT MAP (
	   i_clk => clk_i,
		in_rst => not rst_i,
		i_d => next_cnt_s,
		o_q => counter_value_s
	);
	
   min_cnt_reg : reg 
	GENERIC MAP (
	   WIDTH => 8,
		RST_INIT => 0
	)		
	PORT MAP (
	   i_clk => clk_i,
		in_rst => not rst_i,
		i_d => next_cnt_m,
		o_q => counter_value_m
	);
	
   hour_cnt_reg : reg 
	GENERIC MAP (
	   WIDTH => 8,
		RST_INIT => 0
	)		
	PORT MAP (
	   i_clk => clk_i,
		in_rst => not rst_i,
		i_d => next_cnt_h,
		o_q => counter_value_h
	);	
-- DODATI :

-- sistem za brojane sekundi,minuta i sata kao sistem za generisanje izlaza u odnosu na pritisnuti taster
-- ako nije pritisnut nijedan taster onda se prikazuju sekunde

----------------------------------------------------------------------------------------
--SECOND COUNTER
----------------------------------------------------------------------------------------
   WITH cnt_rst_i SELECT next_cnt_s <=
        mid_cnt_s   WHEN '0',
		  "00000000"  WHEN OTHERS;
		  
   WITH cnt_en_i  SELECT mid_cnt_s <=
	     curr_cnt_s            WHEN   '1',
		  counter_value_s       WHEN OTHERS;

	WITH one_sec_i   SELECT curr_cnt_s <=
	     add_cnt_s_mux        WHEN '1',
		  counter_value_s      WHEN OTHERS;

   WITH one_min SELECT add_cnt_s_mux <= 
        add_cnt_s  WHEN '0',
        "00000000" WHEN '1';

   one_min <= '1' WHEN add_cnt_s = 60 ELSE
              '0';	
		    
   add_cnt_s <= counter_value_s + 1;  	
		
----------------------------------------------------------------------------------------
--MINUTE COUNTER
----------------------------------------------------------------------------------------	


   WITH cnt_rst_i SELECT next_cnt_m <=
        mid_cnt_m   WHEN '0',
		  "00000000"  WHEN OTHERS;
		  
   WITH cnt_en_i  SELECT mid_cnt_m <=
	     curr_cnt_m            WHEN   '1',
		  counter_value_m       WHEN OTHERS;

	WITH one_min   SELECT curr_cnt_m <=
	     add_cnt_m_mux        WHEN '1',
		  counter_value_m      WHEN OTHERS;

   WITH one_hour SELECT add_cnt_m_mux <= 
        add_cnt_m  WHEN '0',
        "00000000" WHEN '1';

   one_hour <= '1' WHEN add_cnt_m = 60 ELSE
               '0';	
		    
   add_cnt_m <= counter_value_m + 1;  	

----------------------------------------------------------------------------------------
--HOUR COUNTER
----------------------------------------------------------------------------------------	



   WITH cnt_rst_i  SELECT next_cnt_h <=
        mid_cnt_h     WHEN '0',
		  "00000000"    WHEN OTHERS;
		  
   WITH cnt_en_i         SELECT mid_cnt_h <=
	     curr_cnt_h            WHEN   '1',
		  counter_value_h       WHEN OTHERS;

	WITH one_hour        SELECT curr_cnt_h <=
	     add_cnt_h          WHEN '1',
		  counter_value_h    WHEN OTHERS;  

  
   add_cnt_h <= counter_value_h + 1;  
	
----------------------------------------------------------------------------------------	
	
	time_sel <= button_hour_i & button_min_i;

   WITH time_sel SELECT time_val <= 
        "00000000"      WHEN "00",
        counter_value_m	WHEN "10",
        counter_value_h WHEN "01",
        counter_value_s WHEN OTHERS;	

   led_o <= time_val;		  

END rtl;