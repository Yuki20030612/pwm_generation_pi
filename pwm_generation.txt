library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_signed.all;

entity pwm_generation_pi is
	port(
		clk 			: in std_logic;
--		cnt_100k 		: in std_logic_vector(15 downto 0);
		cnt_5k     		: in std_logic_vector(15 downto 0);
		d_time_u 		: in std_logic_vector(15 downto 0);
		d_time_v 		: in std_logic_vector(15 downto 0);
		d_time_w 		: in std_logic_vector(15 downto 0);
		START 		    : in std_logic;
		tri_wave 		: out std_logic_vector(15 downto 0);
		UP 				: out std_logic;
		UN 				: out std_logic;
		VP 				: out std_logic;
		VN 				: out std_logic;
		WP 				: out std_logic;
		WN 				: out std_logic
		);
end pwm_generation_pi;

architecture Behavioral of pwm_generation_pi is

component triangle is
	port(
		clk 			: in std_logic;
--		cnt_100k 		: in std_logic_vector(15 downto 0);
		cnt_5k 	      	: in std_logic_vector(15 downto 0);
		triangle_wave 	: out std_logic_vector(15 downto 0)
		);
end component;

component comparator is
	port(
		clk 			: in std_logic;
		d_time 			: in std_logic_vector(15 downto 0);
--		cnt_100k 		: in std_logic_vector(15 downto 0);
		cnt_5k 	      	: in std_logic_vector(15 downto 0);
		triangle_wave 	: in std_logic_vector(15 downto 0);
		P,N 			: out std_logic
		);
end component;

component deadtime is
	port(
		clk 			: in std_logic;
		time_delay 		: in std_logic_vector(8 downto 0);
		P_in,N_in 		: in std_logic;
		P_out,N_out	 	: out std_logic
		);
end component;

constant time_delay     : std_logic_vector(8 downto 0):="001100100";--1u
--constant time_delay     : std_logic_vector(8 downto 0):="011001000";--2u
--constant time_delay     : std_logic_vector(8 downto 0):="000010100";--0.2u
--constant time_delay     : std_logic_vector(8 downto 0):="000011110";--0.3u
--constant time_delay     : std_logic_vector(8 downto 0):="100101100";--3u
--constant time_delay     : std_logic_vector(8 downto 0):="110010000";--4u
--constant time_delay     : std_logic_vector(8 downto 0):="111110100";--5u

signal UP_reg			: std_logic;
signal UN_reg			: std_logic;
signal VP_reg			: std_logic;
signal VN_reg			: std_logic;
signal WP_reg			: std_logic;
signal WN_reg 			: std_logic;
signal dt_UP_reg		: std_logic;
signal dt_UN_reg		: std_logic;
signal dt_VP_reg		: std_logic;
signal dt_VN_reg		: std_logic;
signal dt_WP_reg		: std_logic;
signal dt_WN_reg		: std_logic;
signal UP_signal		: std_logic;
signal UN_signal		: std_logic;
signal VP_signal		: std_logic;
signal VN_signal		: std_logic;
signal WP_signal		: std_logic;
signal WN_signal		: std_logic;
signal triangle_wave 	: std_logic_vector(15 downto 0);

begin

triangle_wave_generation : triangle
	port map(
		clk => clk,
--		cnt_100k => cnt_100k,
		cnt_5k => cnt_5k,
		triangle_wave => triangle_wave
		);

COMP_u : comparator
	port map(
		clk => clk,
		d_time => d_time_u,
--		cnt_100k => cnt_100k,
		cnt_5k => cnt_5k,
		triangle_wave => triangle_wave,
		P => UP_reg,
		N => UN_reg
		);

COMP_v : comparator
port map(
		clk => clk,
		d_time => d_time_v,
--		cnt_100k => cnt_100k,
		cnt_5k => cnt_5k,
		triangle_wave => triangle_wave,
		P => VP_reg,
		N => VN_reg
		);

COMP_w : comparator
	port map(
		clk => clk,
		d_time => d_time_w,
--		cnt_100k => cnt_100k,
		cnt_5k => cnt_5k,
		triangle_wave => triangle_wave,
		P => WP_reg,
		N => WN_reg
		);
	

deadtime_u : deadtime
	port map(
		clk => clk,
		time_delay => time_delay,
		P_in => UP_reg,
		N_in => UN_reg,
		P_out => dt_UP_reg,
		N_out => dt_UN_reg
		);
		
deadtime_v : deadtime
	port map(
		clk => clk,
		time_delay => time_delay,
		P_in => VP_reg,
		N_in => VN_reg,
		P_out => dt_VP_reg,
		N_out => dt_VN_reg
		);

deadtime_w : deadtime
	port map(
		clk => clk,
		time_delay => time_delay,
		P_in => WP_reg,
		N_in => WN_reg,
		P_out => dt_WP_reg,
		N_out => dt_WN_reg
		);
		
tri_wave <= triangle_wave;

process(clk) begin
    if rising_edge(clk) then
        if START = '1' then
            UP_signal <= not dt_UP_reg;
            UN_signal <= not dt_UN_reg;
            VP_signal <= not dt_VP_reg;
            VN_signal <= not dt_VN_reg;
            WP_signal <= not dt_WP_reg;
            WN_signal <= not dt_WN_reg;
         else
            UP_signal <= '0'; --active high
            UN_signal <= '0';
            VP_signal <= '0';
            VN_signal <= '0';
            WP_signal <= '0';
            WN_signal <= '0';
         end if;
    end if;
end process;
UP <= UP_signal;--active high
UN <= UN_signal;
VP <= VP_signal;
VN <= VN_signal;
WP <= WP_signal;
WN <= WN_signal;
		
end Behavioral;

