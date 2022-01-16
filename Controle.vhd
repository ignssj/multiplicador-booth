library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controle is

	port(
		clk_PC		: in std_logic := '0';
		rst_PC	 	: in std_logic := '0';
		Count_PC			: out unsigned (1 downto 0);
		enableA_PC	 	: out	std_logic := '0';
		p0_PC	 	: out	std_logic := '0';
		p2_PC	 	: out	std_logic := '0';
		p4_PC	 	: out	std_logic := '0';
		enableS_PC	 	: out	std_logic := '0'
	);

end entity;

architecture rtl of Controle is

	TYPE state_name IS (C1, C2, C3, C4);

	SIGNAL state, next_state : state_name;
	SIGNAL count : unsigned (1 downto 0) := "00";

BEGIN

	PROCESS (clk_PC)
	BEGIN
		IF (rst_PC = '1') THEN
			state <= C1;
		ELSIF (rising_edge(clk_PC)) THEN
			state <= next_state;
		END IF;
	END PROCESS;

	PROCESS (state)
	BEGIN
		CASE state IS
			WHEN C1 =>
				enableA_PC <= '1';
				enableS_PC <= '1';
				p0_PC <= '1';
				p2_PC <= '1';
				p4_PC <= '1';
				count <= "00";
				next_state <= C2;

			WHEN C2 =>
				enableA_PC <= '0';
				enableS_PC <= '0';
				p0_PC <= '0';
				p2_PC <= '0';
				p4_PC <= '0';
				count <= "01";
				next_state <= C3;

			WHEN C3 =>
				count <= "10";
				next_state <= C4;
			WHEN C4 =>
				enableS_PC <= '1';
				count <= "11";
		END CASE;
	END PROCESS;
	Count_PC <= count;
END rtl;