library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity plotter is
    Port ( reloj : in  STD_LOGIC;
			  button : in  STD_LOGIC;
			  modo : in  STD_LOGIC;
			  start : in  STD_LOGIC;
			  selFig : in STD_LOGIC_VECTOR (1 downto 0);
			  joystick : in STD_LOGIC_VECTOR (3 downto 0);
			  pwm : out  STD_LOGIC;
           M1 : out  STD_LOGIC_VECTOR (3 downto 0); ----Salida del motor
			  M2 : out  STD_LOGIC_VECTOR (3 downto 0)
         );
end plotter;

architecture Behavioral of plotter is

--Señales Manuales
signal En0_M, En1_M, dir0_M, dir1_M, pwm_M: std_logic;
signal M1_Man, M2_Man : std_logic_vector (3 downto 0);

--Señales Automaticas
signal En0_A, En1_A, dir0_A, dir1_A, pwm_A: std_logic;
signal M1_Aut, M2_Aut : std_logic_vector (3 downto 0);

--Componente para mover Servo
component Servo
	port(
		clk :  in  STD_LOGIC;--reloj de 50MHz
		boton :  in  STD_LOGIC;--selecciona las 2 posiciones
		PWM :  out  STD_LOGIC);--terminal donde sale la señal de PWM
end component;

--Componente para Joystick
component Joys is
    Port ( joys : in STD_LOGIC_VECTOR (3 downto 0);
			  En0, En1, dir0, dir1 : out  std_logic
         );
end component;

--Componente para mover motores
component Motor is
    Port ( reloj : in  STD_LOGIC;
			  En0, En1, dir0, dir1 : in STD_LOGIC;
           M1 : out  STD_LOGIC_VECTOR (3 downto 0); ----Salida del motor
			  M2 : out  STD_LOGIC_VECTOR (3 downto 0)
         );
end component;

component figuras is
    Port ( reloj : in  STD_LOGIC;
			  play : in std_logic;
			  selector : in STD_LOGIC_VECTOR (1 downto 0);
			  pwm_Aut : out std_logic;
			  M1 : out  STD_LOGIC_VECTOR (3 downto 0); ----Salida del motor
			  M2 : out  STD_LOGIC_VECTOR (3 downto 0)
        );
end component;

begin
	
controlServo : Servo port map(reloj, button, pwm_M);
controlJoys : Joys port map(joystick, En0_M, En1_M, dir0_M, dir1_M);
controlMotorMan : Motor port map(reloj, En0_M, En1_M, dir0_M, dir1_M, M1_Man, M2_Man);

controlAutomatico : figuras port map(reloj, start, selFig, pwm_A, M1_Aut, M2_Aut);

Muxy : process(modo)
begin
	case modo is
		when '0' =>
			pwm <= pwm_M;
			M1 <= M1_Man;
			M2 <= M2_Man;
		when others =>
			pwm <= pwm_A;
			M1 <= M1_Aut;
			M2 <= M2_Aut;
	end case;
end process; 

end Behavioral;