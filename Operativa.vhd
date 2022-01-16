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

	signal A_reg  : signed (6 downto 0) := "0000000";
	signal p0,p2,p4: signed (2 downto 0) := "000" ;
	signal S_Reg,partial_reg,partial2_reg,partial3_reg: signed (11 downto 0) := "000000000000";
	constant zero : std_logic_vector (11 downto 0) := "000000000000";
	 	
	begin 
	process(clk_PO) is
	begin
	if (rising_edge(clk_PO)) then
	--------------------------------------------------------------------------
	if( Count_PO = "00" ) then
	A_reg (5 downto 0) <= X_PO;
	p0 <= Y_PO (2 downto 0);
	p2 <= Y_PO (4 downto 2);
	p4 <= Y_PO (6 downto 4); 
	end if;									  -- X= 000.100   (4) | X= 010101 (21
	------------------------------------- Y= 000.110.0 (6) | Y= 011110.0 (30)
	if (Count_PO = "01") then 
		case p0 is
			when "001" | "010" =>
				partial_reg(5 downto 0)<= A_reg(5 downto 0);
			when "011" =>
				partial_reg(6 downto 0)<= resize(A_reg, 7) sll 1; 
			when "100" => -- p0 = 100
				partial_reg(6 downto 0)<= resize((-A_reg),7) sll 1; -- partial_reg = 1111000
				partial_reg(11 downto 7)<= "11111";
			when "101" | "110" => 
				partial_reg(5 downto 0)<= (-A_reg(5 downto 0)); 
			when others => null;
		end case;
	end if;
	--------------------------------------------------------------------------
	if (Count_PO = "10") then
		case p2 is 
			when "000" | "111" =>
				partial2_reg <= (to_signed(0,12));
			when "001" | "010" => 
				partial2_reg (7 downto 2)<= (A_reg(5 downto 0)); 
			when "011" => -- p2 = 011
				partial2_reg(8 downto 2)<= A_reg sll 1; -- partial2 = 0001000
			when "100" =>
				partial2_reg (8 downto 2)<= (-A_reg) sll 1;
				partial2_reg(11 downto 9) <= "111";
			when "101" | "110" =>
				partial2_reg (7 downto 2)<= (-A_reg(5 downto 0));
			when others => null;
		end case;
	end if;
	--------------------------------------------------------------------------
	if (Count_PO = "11") then
		case p4 is 
			when "000" | "111" =>
				partial3_reg <= (to_signed(0,12)); -- partial 3 = 000000000000
			when "001" | "010" =>
				partial3_reg (9 downto 4)<= (A_reg(5 downto 0));
			when "011" =>
				partial3_reg (10 downto 4)<= A_reg sll 1;
			when "100" =>
				partial3_reg (10 downto 4)<= (-A_reg) sll 1;
				partial3_reg(11) <= '1';
			when "101" | "110" =>
				partial3_reg (9 downto 4)<= (-(A_reg(5 downto 0)));
			when others => null;
		end case;
	end if;
	--------------------------------------------------------------------------
	end if;
	if(e_P = '1') then
	P_PO <= partial_reg + partial2_reg + partial3_reg;
	end if;
	end process;
	end rtl;