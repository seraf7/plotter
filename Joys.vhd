library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Joys is
    Port ( joys : in STD_LOGIC_VECTOR (3 downto 0);
			  En0, En1, dir0, dir1 : out  std_logic
         );
end Joys;

architecture Behavioral of Joys is

begin

--Tabla de verdad control de motores
joystick : process(joys)
begin
	case joys is
		when "0000" =>
			En1 <= '0';
			En0 <= '0';
			dir1 <= '1';
			dir0 <= '1';
		
		when "0001" =>
			En1 <= '0';
			En0 <= '1';
			dir1 <= '1';
			dir0 <= '1';
		
		when "0010" =>
			En1 <= '0';
			En0 <= '1';
			dir1 <= '1';
			dir0 <= '0';
		
		when "0100" =>
			En1 <= '1';
			En0 <= '0';
			dir1 <= '1';
			dir0 <= '1';
			
		when "0101" =>
			En1 <= '1';
			En0 <= '1';
			dir1 <= '1';
			dir0 <= '1';
		
		when "0110" =>
			En1 <= '1';
			En0 <= '1';
			dir1 <= '1';
			dir0 <= '0';
		
		when "1000" =>
			En1 <= '1';
			En0 <= '0';
			dir1 <= '0';
			dir0 <= '1';
		
		when "1001" =>
			En1 <= '1';
			En0 <= '1';
			dir1 <= '0';
			dir0 <= '1';
			
		when "1010" =>
			En1 <= '1';
			En0 <= '1';
			dir1 <= '0';
			dir0 <= '0';
			
		when others =>
			En1 <= '0';
			En0 <= '0';
			dir1 <= '1';
			dir0 <= '1';

	end case;
end process;

end Behavioral;