LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_unsigned.all;
ENTITY trafficlightwithcrosswalk IS
	PORT (CLOCK_50: IN STD_LOGIC;
		clr: IN STD_LOGIC;
		LEDR: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		LEDG: OUT STD_LOGIC_VECTOR (5 DOWNTO 0));
END trafficlightwithcrosswalk;

ARCHITECTURE stateMachine OF trafficlightwithcrosswalk IS
TYPE state_type IS (s0, s1, s2, s3, s4, s5);
SIGNAL state: state_type;
SIGNAL count: STD_LOGIC_VECTOR (3 DOWNTO 0);
CONSTANT SEC5: STD_LOGIC_VECTOR (3 DOWNTO 0) := "1111";
CONSTANT SEC1: STD_LOGIC_VECTOR (3 DOWNTO 0) := "0011";
BEGIN
PROCESS (CLOCK_50, clr)
BEGIN
	IF clr = '1' THEN state <= s0;
							count <= X"0";
	ELSIF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN 
	  CASE state IS
		WHEN s0 =>
				IF count < SEC5 THEN 
					state <= s0;
					count <= count +1;
				ELSE
					state <=s1;
					count <= X"0";
				END IF;
		WHEN s1 =>
				IF count < SEC1 THEN 
					state <= s1;
					count <= count + 1;
				ELSE
					state <= s2;
					count <= X"0";
				END IF;
		WHEN s2 =>
				IF count < SEC1 THEN 
					state <= s2;
					count <= count + 1;
				ELSE
					state <= s3;
					count <= X"0";
				END IF;
		WHEN s3 =>
				IF count < SEC5 THEN 
					state <= s3;
					count <= count + 1;
				ELSE
					state <= s4;
					count <= X"0";
				END IF;
		WHEN s4 =>
				IF count < SEC1 THEN 
					state <= s4;
					count <= count + 1;
				ELSE
					state <= s5;
					count <= X"0";
				END IF;
		WHEN s5 =>
				IF count < SEC1 THEN 
					state <= s5;
					count <= count + 1;
				ELSE
					state <= s0;
					count <= X"0";
				END IF;
		WHEN OTHERS => STATE <= s0;
	  END CASE;
	END IF;
END PROCESS;

C2: PROCESS(state)
BEGIN 
CASE state is
	when s0 => LEDR <= "000001"; LEDG <= "001000";
	when s1 => LEDR <= "000001"; LEDG <= "110000";
	when s2 => LEDR <= "001001"; LEDG <= "000000";
	when s3 => LEDR <= "001000"; LEDG <= "000001";
	when s4 => LEDR <= "001000"; LEDG <= "000011";
	when s5 => LEDR <= "001001"; LEDG <= "000000";
	when others => LEDR <= "000000";
END CASE;
END PROCESS;
END stateMachine;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
ENTITY trafficlightwithcrosswalk_lights_top IS
	PORT(mclk: IN STD_LOGIC;
			btn: IN STD_LOGIC_VECTOR(3 DOWNTO 2);
			ld : OUT STD_LOGIC_VECTOR(7 DOWNTO 2));
END trafficlightwithcrosswalk_lights_top;

ARCHITECTURE trafficlightwithcrosswalk_lights_top OF trafficlightwithcrosswalk_lights_top IS 
COMPONENT clkdiv IS
	PORT(mclk : IN STD_LOGIC;
			clr : IN STD_LOGIC;
			clk3: OUT STD_LOGIC);
END COMPONENT;

COMPONENT trafficlightwithcrosswalk IS
	PORT(CLOCK_50: IN STD_LOGIC;
			clr: IN STD_LOGIC;
			LEDR: OUT STD_LOGIC_VECTOR(5 DOWNTO 0));
	END COMPONENT;
SIGNAL clr, clk3: STD_LOGIC;
BEGIN
	clr <= btn(3);
	U1: clkdiv
			PORT MAP (mclk => mclk,
						clr => clr,
						clk3 => clk3);
	U2: trafficlightwithcrosswalk
			PORT MAP (CLOCK_50 => clk3,
						clr => clr,
						LEDR => ld);
END trafficlightwithcrosswalk_lights_top;