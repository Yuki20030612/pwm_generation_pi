library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;

entity deadtime is
	port(
		clk 		: in std_logic;
		time_delay 	: in std_logic_vector(8 downto 0);
		P_in,N_in 	: in std_logic;
		P_out,N_out : out std_logic
		);
end deadtime;

architecture Behavioral of deadtime is

component delay
	port( 
		clk 		: in std_logic;
		time_delay 	: in std_logic_vector(8 downto 0);
		input 		: in std_logic;
		output 		: out std_logic
		 );
end component;

signal P2, P3, P4, N2, N3, N4 : std_logic;
signal Pdelay_out,Ndelay_out : std_logic;

begin

	time_delay_P : delay port map (
		clk => clk,
		time_delay => time_delay,
		input => P_in,
		output => Pdelay_out
		);
	
	time_delay_N : delay port map (
		clk => clk,
		time_delay => time_delay,
		input => N_in,
		output => Ndelay_out
		);

	P2 <= P_in and (not N_in);
	N2 <= N_in and (not P_in);
	P4 <= P2 and Pdelay_out;
	N4 <= N2 and Ndelay_out;
		
process(clk)begin
	if(clk' event and clk='1') then
	P_out <= not P4;
	N_out <= not N4;
	end if;
end process;

end Behavioral;

