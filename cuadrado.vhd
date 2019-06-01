library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity cuadrado is
	 generic( Max: natural := 1000000);
    Port ( reloj : in  STD_LOGIC;
			  inicio: in STD_LOGIC;
			  movServo : out STD_LOGIC;
			  En0, En1, dir0, dir1 : out STD_LOGIC
         );
end cuadrado;

architecture Behavioral of cuadrado is

signal PWM_Count: integer range 1 to Max;--1000000;

signal seg, selector: std_logic;
signal cont: std_logic_vector(9 downto 0);


--Biblioteca de estados
type Estados is (S5, S0, S1, S2, S3, S4);
signal epresente, esiguiente: Estados;

begin

generacion_PWM: process(reloj, selector, PWM_Count)
    constant pos1: integer := 50000;  --representa a 1.00ms = 0°
    constant pos4: integer := 100000; --representa a 2.00ms = 180°
        begin
        if rising_edge(reloj) then 
            PWM_Count <= PWM_Count + 1;
        end if;
        case (selector) is
            when '1' =>--con el selector en 1 se posiciona en servo en 0°
                if PWM_Count <= pos1 then
                    movServo <= '1';
                else
                    movServo <= '0';
                end if;
            when others =>-- con el selector en 0 se posiciona en servo en 180°
                if PWM_Count <= pos4 then
                    movServo <= '1';
                else
                    movServo <= '0';
                end if;
        end case;
    end process generacion_PWM;

-----------
	divi: process(reloj)
	variable toggle: std_logic:='0';
	variable cuenta: std_logic_vector(27 downto 0):=X"0000000";		--Declaracion de una varible interna de proceso
	begin
		if rising_edge (reloj) then
			if cuenta = X"0838A92" then		--Tiempo para 0.5s,  2BA3487,   04C4B40
				toggle := NOT(toggle); 
				cuenta:=X"0000000";
			else
				cuenta:= cuenta + 1;
			end if;
		end if;
		seg <= toggle; ---modificacion de frecuencia
	end process;
	
ASM1: process(seg)
variable cuenta:  std_logic_vector(9 downto 0);
begin
	if rising_edge(seg) then
		if epresente = esiguiente then 
			cuenta:=cuenta+1;
		else
			cuenta:="0000000000";
		end if;
		epresente <= esiguiente;
	end if;
cont<=cuenta;
end process;

ASM2: process(epresente,cont)

begin

	case epresente is
		when S0 =>
			selector <= '0';
			En0 <= '0';
			En1 <= '0';
			dir0 <= '0';
			dir1 <= '0';
			esiguiente <= S1;
			
		when S1 =>
			En0 <= '1';
			En1 <= '0';
			dir0 <= '1';
			dir1 <= '0';	
			if cont = "0000001111" then --Contamos hasta 15
				esiguiente<=S2;
			else
				esiguiente<=S1;
			end if;
		
		when S2 =>
			En0 <= '0';
			En1 <= '1';
			dir0 <= '1';
			dir1 <= '0';
			if cont = "0000001111" then --Contamos hasta 15
				esiguiente<=S3;
			else
				esiguiente<=S2;
			end if;
		
		when S3 =>
			En0 <= '1';
			En1 <= '0';
			dir0 <= '0';
			dir1 <= '0';
			if cont = "0000001111" then --Contamos hasta 15
				esiguiente<=S4;
			else
				esiguiente<=S3;
			end if;
			
		when S4 =>
			En0 <= '0';
			En1 <= '1';
			dir0 <= '1';
			dir1 <= '1';
			if cont = "0000001111" then --Contamos hasta 15
				esiguiente<=S5;
			else
				esiguiente<=S4;
			end if;
		
		when S5 =>
			selector <= '1';
			En0 <= '0';
			En1 <= '0';
			dir0 <= '1';
			dir1 <= '0';
			if inicio = '0' then
				esiguiente <= S5;
			else
				esiguiente <= S0;
			end if;
	end case;
end process;
	
end Behavioral;