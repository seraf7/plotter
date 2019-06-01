library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Motor is
    Port ( reloj : in  STD_LOGIC;
			  En0, En1, dir0, dir1 : in STD_LOGIC;
           M1 : out  STD_LOGIC_VECTOR (3 downto 0); ----Salida del motor
			  M2 : out  STD_LOGIC_VECTOR (3 downto 0)
         );
end Motor;

architecture Behavioral of Motor is

signal seg: std_logic;

--Biblioteca de estados
type EstadosM1 is (M1_S0, M1_S1, M1_S2, M1_S3, M1_S4);
signal epresente_M1, esiguiente_M1: EstadosM1;

type EstadosM2 is (M2_S0, M2_S1, M2_S2, M2_S3, M2_S4);
signal epresente_M2, esiguiente_M2: EstadosM2;

begin
	divi: process(reloj)
	variable toggle: std_logic:='0';
	variable cuenta: std_logic_vector(27 downto 0):=X"0000000";		--Declaracion de una varible interna de proceso
	begin
		if rising_edge (reloj) then
			if cuenta = X"000c350" then		--Tiempo para 0.5s,  2BA3487,   04C4B40
				toggle := NOT(toggle); 
				cuenta:=X"0000000";
			else
				cuenta:= cuenta + 1;
			end if;
		end if;
		seg <= toggle; ---modificacion de frecuencia
	end process;
	
--Motor 1	
ASM1_M1: process(seg)
variable arriba: std_logic_vector(4 downto 0):="00000";		--Declaracion de una varible interna de proceso
begin
	if rising_edge(seg) then
		epresente_M1 <= esiguiente_M1;
	end if;
end process;

----------------
ASM2_M1: process(epresente_M1, dir0, En0)
begin

	case epresente_M1 is
		when M1_S0 =>
			M1 <= "0000";
			if En0 = '1' then
				esiguiente_M1 <= M1_S1;
			else
				esiguiente_M1 <= M1_S0;
			end if;
			
		when M1_S1 =>
			M1 <= "1100";
			if En0 = '1' and dir0 = '1' then
				esiguiente_M1 <= M1_S2;
			elsif En0 ='1' and dir0 = '0' then
				esiguiente_M1 <= M1_S4;
			else		--En = 0
				esiguiente_M1 <= M1_S0;
			end if;
			
		when M1_S2 =>
			M1 <= "0110";
			if En0 = '1' and dir0 = '1' then
				esiguiente_M1 <= M1_S3;
			elsif En0 = '1' and dir0 = '0' then
				esiguiente_M1 <= M1_S1;
			else		--En = 0
				esiguiente_M1 <= M1_S0;
			end if;
			
		when M1_S3 =>
			M1 <= "0011";
			if En0 = '1' and dir0 = '1' then
				esiguiente_M1 <= M1_S4;
			elsif En0 = '1' and dir0 = '0' then
				esiguiente_M1 <= M1_S2;
			else		--En = 0
				esiguiente_M1 <= M1_S0;
			end if;
			
		when M1_S4 =>
			M1 <= "1001";
			if En0 = '1' and dir0 = '1' then
				esiguiente_M1 <= M1_S1;
			elsif En0 = '1' and dir0 = '0' then
				esiguiente_M1 <= M1_S3;
			else		--En = 0
				esiguiente_M1 <= M1_S0;
			end if;	
	end case;
end process;


--Motor 2
ASM1_M2: process(seg)
variable arriba: std_logic_vector(4 downto 0):="00000";		--Declaracion de una varible interna de proceso
begin
	if rising_edge(seg) then
		epresente_M2 <= esiguiente_M2;
	end if;
end process;

----------------
ASM2_M2: process(epresente_M2, dir1, En1)
begin

	case epresente_M2 is
		when M2_S0 =>
			M2 <= "0000";
			if En1 = '1' then
				esiguiente_M2 <= M2_S1;
			else
				esiguiente_M2 <= M2_S0;
			end if;
			
		when M2_S1 =>
			M2 <= "1100";
			if En1 = '1' and dir1 = '1' then
				esiguiente_M2 <= M2_S2;
			elsif En1 ='1' and dir1 = '0' then
				esiguiente_M2 <= M2_S4;
			else		--En = 0
				esiguiente_M2 <= M2_S0;
			end if;
			
		when M2_S2 =>
			M2 <= "0110";
			if En1 = '1' and dir1 = '1' then
				esiguiente_M2 <= M2_S3;
			elsif En1 = '1' and dir1 = '0' then
				esiguiente_M2 <= M2_S1;
			else		--En = 0
				esiguiente_M2 <= M2_S0;
			end if;
			
		when M2_S3 =>
			M2 <= "0011";
			if En1 = '1' and dir1 = '1' then
				esiguiente_M2 <= M2_S4;
			elsif En1 = '1' and dir1 = '0' then
				esiguiente_M2 <= M2_S2;
			else		--En = 0
				esiguiente_M2 <= M2_S0;
			end if;
			
		when M2_S4 =>
			M2 <= "1001";
			if En1 = '1' and dir1 = '1' then
				esiguiente_M2 <= M2_S1;
			elsif En1 = '1' and dir1 = '0' then
				esiguiente_M2 <= M2_S3;
			else		--En = 0
				esiguiente_M2 <= M2_S0;
			end if;	
	end case;
end process;
	
end Behavioral;