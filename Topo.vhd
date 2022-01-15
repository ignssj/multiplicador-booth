library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Topo is

	port(
		clk_TOP 	: in std_logic;
		rst_TOP 	: in std_logic;
		X_TOP 		: in signed (5 downto 0);
		Y_TOP 		: in signed (6 downto 0);
		P_TOP 		: out signed (11 downto 0):= "000000000000"
	);

end entity;

architecture rtl of Topo is

component Operativa is
	port(
		clk_PO 	: in std_logic;
		rst_PO 	: in std_logic;
		e_A 		: in std_logic;
		e_p0	 	: in std_logic;
		e_p2	 	: in std_logic;
		e_p4	 	: in std_logic;
		e_P 		: in std_logic;
		Count_PO : in unsigned (1 downto 0) := "00";
		X_PO 		: in signed (5 downto 0);
		Y_PO 		: in signed (6 downto 0);
		P_PO 		: out signed (11 downto 0):= "000000000000"
	);
end component;

component Controle is
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
end component;

signal count_conn : unsigned (1 downto 0);
signal enableA_conn, enablep0_conn, enablep2_conn, enablep4_conn, enableP_conn : std_logic;

begin

PC: Controle port map (clk_PC => clk_TOP, rst_PC => rst_TOP, Count_PC => count_conn, enableA_PC => enableA_conn, p0_PC => enablep0_conn, p2_PC => enablep2_conn, p4_PC => enablep4_conn, enableS_PC => enableP_conn);
PO: Operativa port map (clk_PO => clk_TOP, rst_PO => rst_TOP, Count_PO => count_conn, X_PO => X_TOP, Y_PO => Y_TOP, P_PO => P_TOP, e_A => enableA_conn, e_p0 => enablep0_conn, e_p2 => enablep2_conn, e_p4 => enablep4_conn, e_P => enableP_conn);

end rtl;