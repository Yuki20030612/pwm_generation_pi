library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_signed.all;

entity triangle is
	port(
		clk 				: in std_logic;
--		cnt_100k 		: in std_logic_vector(15 downto 0);
		cnt_5k     		: in std_logic_vector(15 downto 0);
		triangle_wave   	: out std_logic_vector(15 downto 0)
		);
end triangle;

architecture Behavioral of triangle is

signal triangle_wave_buf 	: std_logic_vector (15 downto 0):=X"7EF4";--CF_max
signal cnt_flag             : std_logic:='0';

begin

--process(clk) begin
--  if(rising_edge(clk)) then
--    --if(cnt_100k <= X"01F3") then--X"01F3" = 499d
--    if(cnt_100k <= X"09C3") then--X"01F3" = 2499d
--	   triangle_wave_buf <= triangle_wave_buf - X"001A";--X"0082"= 26d
--	 else
--	   triangle_wave_buf <= triangle_wave_buf + X"001A";--X"0082"= 26d
--	end if;
--  end if;
-- end process;
 
 process(clk) begin
  if(rising_edge(clk)) then
--    if(cnt_100k <= X"01F3") then--X"01F3" = 499d
    if(cnt_5k <= X"270F") then--X"270F" = 9999d
        if(cnt_flag =   '0')then
    	   triangle_wave_buf <= triangle_wave_buf - X"0006";--X"0006"= 6d
    	   cnt_flag    <=  '1';
    	else
    	   triangle_wave_buf <= triangle_wave_buf - X"0007";--X"0007"= 6d
    	   cnt_flag    <=  '0';    	
    	end if;
	 else
        if(cnt_flag =   '0')then
    	   triangle_wave_buf <= triangle_wave_buf + X"0006";--X"0006"= 6d
    	   cnt_flag    <=  '1';
    	else
    	   triangle_wave_buf <= triangle_wave_buf + X"0007";--X"0007"= 7d
    	   cnt_flag    <=  '0';    	
    	end if;
	end if;
  end if;
 end process;

triangle_wave <= triangle_wave_buf;

end Behavioral;

