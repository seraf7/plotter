library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity figuras is
    Port ( reloj : in  STD_LOGIC;
			  play : in std_logic;
			  selector : in STD_LOGIC_VECTOR (1 downto 0);
			  pwm_Aut : out std_logic;
			  M1 : out  STD_LOGIC_VECTOR (3 downto 0); ----Salida del motor
			  M2 : out  STD_LOGIC_VECTOR (3 downto 0)
        );
end figuras;

architecture Behavioral of figuras is
signal En0, En1, dir0, dir1 : STD_LOGIC;

COMPONENT cuadrado is
    Port ( reloj : in  STD_LOGIC;
			  inicio: in STD_LOGIC;
			  movServo : out STD_LOGIC;
			  En0, En1, dir0, dir1 : out STD_LOGIC
         );
end COMPONENT;

COMPONENT triangulo is
    Port ( reloj : in  STD_LOGIC;
			  inicio: in STD_LOGIC;
			  movServo : out STD_LOGIC;
			  En0, En1, dir0, dir1 : out STD_LOGIC
         );
end COMPONENT;

component octagono is
	 generic( Max: natural := 1000000);
    Port ( reloj : in  STD_LOGIC;
			  inicio: in STD_LOGIC;
			  movServo : out STD_LOGIC;
			  En0, En1, dir0, dir1 : out STD_LOGIC
         );
end component;

component cruz is
    Port ( reloj : in  STD_LOGIC;
			  inicio: in STD_LOGIC;
			  movServo : out STD_LOGIC;
			  En0, En1, dir0, dir1 : out STD_LOGIC
         );
end component;

COMPONENT Motor is
    Port ( reloj : in  STD_LOGIC;
			  En0, En1, dir0, dir1 : in STD_LOGIC;
           M1 : out  STD_LOGIC_VECTOR (3 downto 0); ----Salida del motor
			  M2 : out  STD_LOGIC_VECTOR (3 downto 0)
         );
end COMPONENT;

--Cuadrado
signal En0_C, En1_C, dir0_C, dir1_C, servoC: std_logic;

--Triangulo
signal En0_T, En1_T, dir0_T, dir1_T, servoT: std_logic;

--Octagono
signal En0_O, En1_O, dir0_O, dir1_O, servoO: std_logic;

--Cruz
signal En0_Cr, En1_Cr, dir0_Cr, dir1_Cr, servoCr: std_logic;


begin
caja1: cuadrado port map(reloj, play, servoC, En0_C, En1_C, dir0_C, dir1_C);
caja2: triangulo port map(reloj, play, servoT, En0_T, En1_T, dir0_T, dir1_T);
caja3: octagono port map(reloj, play, servoO, En0_O, En1_O, dir0_O, dir1_O);
caja4: cruz port map(reloj, play, servoCr, En0_Cr, En1_Cr, dir0_Cr, dir1_Cr);
caja5: Motor port map(reloj, En0, En1, dir0, dir1, M1, M2);

Muxy : process(selector)
begin
	case selector is
		when "00" =>
			En0 <= En0_C;
			En1 <= En1_C;
			dir0 <= dir0_C;
			dir1 <= dir1_C;
			pwm_Aut <= servoC;
			
		when "01" =>
			En0 <= En0_T;
			En1 <= En1_T;
			dir0 <= dir0_T;
			dir1 <= dir1_T;
			pwm_Aut <= servoT;
		
		when "10" =>
			En0 <= En0_O;
			En1 <= En1_O;
			dir0 <= dir0_O;
			dir1 <= dir1_O;
			pwm_Aut <= servoO;
			
		when "11" =>
			En0 <= En0_Cr;
			En1 <= En1_Cr;
			dir0 <= dir0_Cr;
			dir1 <= dir1_Cr;
			pwm_Aut <= servoCr;
			
	end case;
	
end process;

end Behavioral;