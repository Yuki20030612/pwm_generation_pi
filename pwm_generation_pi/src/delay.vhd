library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;

entity delay is
	port(
		clk 			: in std_logic;
		time_delay 		: in std_logic_vector(8 downto 0);
		input 			: in std_logic;
		output 			: out std_logic
		);
end delay;

architecture Behavioral of delay is

signal in_flg, out_flg 	: std_logic;
signal cnt_tmp 			: std_logic_vector(8 downto 0) := (others => '0');
signal td_tmp 			: std_logic_vector(8 downto 0) := (others => '0');
	
begin

-- Luch TD
	process(clk) begin
		if (clk' event and clk='1') then
			td_tmp <= time_delay - "10";
		end if;
	end process;
	
-- delay count
	process(clk) begin
		if(clk' event and clk='1') then
		-- rising
			if(input = '1') then
				if(cnt_tmp <= td_tmp) then
					output <= '0';
					cnt_tmp <= cnt_tmp + 1;
				else
					output <= '1';
				end if;
		-- verging
			elsif(input = '0') then
				if(cnt_tmp = "000000000") then
					output <= '0';
				else
					output <= '1';
					cnt_tmp <= cnt_tmp - 1;
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;

