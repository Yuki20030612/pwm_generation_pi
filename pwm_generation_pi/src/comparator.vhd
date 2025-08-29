
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_signed.all;

entity comparator is
	port(
		clk 			: in std_logic;
--		cnt_100k 		: in std_logic_vector(15 downto 0);
		cnt_5k     		: in std_logic_vector(15 downto 0);
		d_time  		: in std_logic_vector(15 downto 0);
		triangle_wave 	: in std_logic_vector(15 downto 0);
		P,N 			: out std_logic
		);
end comparator;

architecture Behavioral of comparator is

signal d_time_buf  : std_logic_vector(15 downto 0):=X"0000";
signal d_time_temp : std_logic_vector(15 downto 0):=X"0000";
signal hold_flag_temp : std_logic:='0';
signal counter : std_logic_vector(15 downto 0):="0000000000000000";

begin

------- single ------
--process(clk)begin
-- if(rising_edge(clk))then
--	if(d_time >= triangle_wave)then
--		P <= '1';
--		N <= '0';
--	elsif(d_time < triangle_wave)then
--		P <= '0';
--		N <= '1';
--	else
--		P <= '0';
--		N <= '0';
--	end if;
-- end if;
--end process;
--------------------


------ multi sampling -----
process(clk) begin
	if(rising_edge(clk))then
--		if(cnt_100k = "0000000000000000")then --0	
		if(cnt_5k = "0000000000000000")then --0
			if(d_time >= triangle_wave)then
				counter <= counter + "0000000000000001";
			else
				counter <= "0000000000000000";
			end if;
			
--		elsif(cnt_100k < "0000000111110100" and cnt_100k > "0000000000000000")then   -- 1~499
		elsif(cnt_5k < "0010011100010000" and cnt_5k > "0000000000000000")then   -- 1~9999
			
			if(d_time >= triangle_wave)then
				counter <= counter + "0000000000000001";	  -- mode_2
				hold_flag_temp <= '1';
				if(counter(15) = '1')then
					counter <= "0000000000000001";
				end if;
			else
				hold_flag_temp <= '0';			        -- mode_1	
			end if;
		
--		elsif(cnt_100k = "0000000111110100")then --500
		elsif(cnt_5k = "0010011100010000")then --500

			if(d_time >= triangle_wave)then
				counter <= "0000000000000000";
			else
				counter <= "0000000000000000";
			end if;
		
--		elsif(cnt_100k > "0000000111110100" and cnt_100k < "0000001111100111")then
		elsif(cnt_5k > "0010011100010000" and cnt_5k < "0100111000011111")then
			if(d_time >= triangle_wave)then       -- 501~998
				hold_flag_temp <= '0';            -- mode_3
			else
				counter <= counter + "0000000000000001";			 -- mode_4		
				hold_flag_temp <= '1';
				
				if(counter(15) = '1')then
					counter <= "0000000000000001";
				end if;				
			end if;
		
--		elsif(cnt_100k = "0000001111100111")then --999		
		elsif(cnt_5k = "0100111000011111")then --999

			if(d_time >= triangle_wave)then
				counter <= counter + "0000000000000001";
			else
				counter <= "0000000000000000";
			end if;
		end if;
	
--		hold_flag <= hold_flag_temp;
	
		if(counter < "0000000000000001")then
			d_time_buf <= d_time;
--			d_time_out <= d_time;
		else 
			d_time_buf <= d_time_buf;
--			d_time_out <= d_time_buf;
		end if;
	end if;
end process;
--------------------

process(clk)begin
	if(rising_edge(clk))then
		if(d_time_buf >= triangle_wave)then
			P <= '1';
			N <= '0';
		elsif(d_time_buf < triangle_wave)then
			P <= '0';
			N <= '1';
		else
			P <= '0';
			N <= '0';
		end if;
	end if;
end process;        

end Behavioral;

