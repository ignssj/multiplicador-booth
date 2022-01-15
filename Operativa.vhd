library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Operativa is

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

end entity;

architecture rtl of Operativa is

	signal A_reg  : signed (11 downto 0) := "000000000000";
	signal p0,p2,p4: signed (2 downto 0) := "000" ;
	signal S_Reg,partial_reg: signed (11 downto 0) := "000000000000";
	constant zero : std_logic_vector (11 downto 0) := "000000000000";
	 	
	begin 
	process(clk_PO) is
	begin
	if (rising_edge(clk_PO)) then
	--------------------------------------------------------------------------
	if( Count_PO = "00" ) then
	-- count = "00";
	S_reg <= "000000000000";
	A_reg (5 downto 0) <= X_PO;
	p0 <= Y_PO (2 downto 0);
	p2 <= Y_PO (4 downto 2);
	p4 <= Y_PO (6 downto 4);
	end if;									  -- X= 000.100 (4)
	------------------------------------- Y= 000.010.0 (2)
	if (Count_PO = "01") then 
		case p0 is -- p0 = 100
			when "001" | "010" =>
				S_reg <= A_reg; 
			when "011" =>
				S_reg <= A_reg sll 1; 
			when "100" => -- S_reg = 111111.111000
				S_reg <= (-(A_reg sll 1));
			when "101" | "110" => 
				S_reg <= (-(A_reg));
			when others => null;
		end case;
	end if;
	--------------------------------------------------------------------------
	if (Count_PO = "10") then
		A_reg <= A_reg sll 2;
		case p2 is -- p2 = 001
			when "000" | "111" =>
				S_reg <= (S_reg + (to_signed(0,12)));
			when "001" | "010" => -- S_reg = 111111.111000 + 000000.010000 = 111111.100000
				S_reg <= (S_reg + A_reg); -- RESULTADO PARCIAL + MULTIPLICANDO
			when "011" =>
				S_reg <= (S_reg + (A_reg sll 1));
			when "100" =>
				S_reg <= S_reg + (-(A_reg sll 1));
			when "101" | "110" =>
				S_reg <= S_reg + (-(A_reg));
			when others => null;
		end case;
	end if;
	--------------------------------------------------------------------------
	if (Count_PO = "11") then
	A_reg <= A_reg sll 2;
		case p4 is -- p4 = 000
			when "000" | "111" =>
				S_reg <= (S_reg + (to_signed(0,12))); -- S_reg = 111111.111000
			when "001" | "010" =>
				S_reg <= (S_reg + A_reg);
			when "011" =>
				S_reg <= (S_reg + (A_reg sll 1));
			when "100" =>
				S_reg <= S_reg + (-(A_reg sll 1));
			when "101" | "110" =>
				S_reg <= S_reg + (-(A_reg));
			when others => null;
		end case;
	end if;
	P_PO <= S_reg; -- S_reg = 
	--------------------------------------------------------------------------
	end if;
	end process;
	end rtl;