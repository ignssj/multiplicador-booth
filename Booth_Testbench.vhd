library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Booth_Testbench  IS 
  GENERIC (
    LENGHT_TOP_sg  : NATURAL   := 6 ); 
END Booth_Testbench; 
 
ARCHITECTURE behaviour OF Booth_Testbench IS
  
  COMPONENT Topo
    	port(
		clk_TOP 	: in std_logic;
		rst_TOP 	: in std_logic;
		X_TOP 		: in signed (5 downto 0);
		Y_TOP 		: in signed (6 downto 0);
		P_TOP 		: out signed (11 downto 0):= "000000000000"
	);
  END COMPONENT ; 
  
		SIGNAL clk_TOP_sg	: std_logic:= '0';
		SIGNAL rst_TOP_sg	: std_logic:= '0';
		SIGNAL X_TOP_sg : signed (5 downto 0);
		SIGNAL Y_TOP_sg : signed (6 downto 0);
		SIGNAL P_TOP_sg : signed (11 downto 0):= "000000000000";

BEGIN
  
  inst_TB : Topo
    PORT MAP ( 
      clk_TOP   => clk_TOP_sg  ,
      rst_TOP   => rst_TOP_sg  ,
      X_TOP   => X_TOP_sg  ,
      Y_TOP   => Y_TOP_sg  ,
      P_TOP   => P_TOP_sg   ) ; 

   clk_TOP_sg <= not clk_TOP_sg after 10 ns;

  Process
	Begin
	 X_TOP_sg  <= "000100";  -- (4)
	 Y_TOP_sg  <= "0001100"; -- (6)
	 rst_TOP_sg  <= '0'  ;
	wait for 110 ns ;
	 rst_TOP_sg <= '1' ;
	 wait for 40 ns;
	 X_TOP_sg  <= "010101";  -- (21)
	 Y_TOP_sg  <= "0111100"; -- (30)
	 rst_TOP_sg  <= '0'  ;
	wait;
 end process;
 
end behaviour;
