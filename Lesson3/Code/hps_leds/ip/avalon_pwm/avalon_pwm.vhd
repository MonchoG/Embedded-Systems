-- avalon_pwm.vhd
-- used in ALSE SOPC Training course
-- --------------------------------------------------------
--   PWM Avalon Slave Module
-- --------------------------------------------------------
-- ALSE
-- http://www.alse-fr.com
-- info@alse-fr.com
--
-- Register map :
--   word Addr 0 = Modulus (division factor minus 1)
--   word Addr 1 = Duty cycle
-- Divides system clock by Modulus + 1
-- out_port is high during Duty, low during Modulus-Duty
-- Cyclic ratio is Duty / (Modulus+1)


Library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

Entity avalon_pwm is
  generic (
         duty_default   : integer := 0;   -- duty default reset value
         modulus_default: integer := 0;   -- modulus default reset value
         debug          : integer := 0    -- debug boolean flag (unused here)
  );
  port ( -- Clock and Reset
         clk            : in  std_logic;
         reset          : in  std_logic;
         -- SIF (Avalon MM)
         address        : in  std_logic_vector ( 9 downto 0);  -- 1 Address bit only (Addr 0 & 1)
         write          : in  std_logic;
         writedata      : in  std_logic_vector (31 downto 0);
         read           : in  std_logic;
         readdata       : out std_logic_vector (31 downto 0);
         -- Conduit (goes to outside SOPC)
         pwm_out        : out std_logic
       );
end Entity avalon_pwm;

Architecture RTL of avalon_pwm is

  -- Avalon MM Registers
  signal Modulus : unsigned (31 downto 0);
  signal Duty    : unsigned (31 downto 0);
  -- Internal Counter
  signal Counter : unsigned (31 downto 0);

Begin -- Architecture

-- Avalon Register Read I/F
-- readdata should receive Modulus when address = 0
--                    else Duty
-- A simple mux can do it
readdata <= std_logic_vector(Modulus) when address(0) = '0' else
            std_logic_vector(Duty);

-- Avalon Register Write I/F
-- You can use the duty_default & modulus_default generics to assign duty & modulus reset values
-- synchronous write to Modulus if chipselect = '1', write = '1' and address = 0
-- synchronous write to Duty    if chipselect = '1', write = '1' and address = 1
--
process (clk, reset)
begin
  if reset = '1' then
    Duty    <= To_Unsigned(duty_default   , Duty'Length);
    Modulus <= To_Unsigned(modulus_default, Modulus'Length);
  elsif rising_edge(clk) then
    if (write = '1') then
      if (address(0) = '0') then
        Modulus  <= unsigned(writedata);
      else
        Duty     <= unsigned(writedata);
      end if;
    end if;
  end if;
end process;

-- PWM Generator
pwm_gen: process (clk, reset)
begin
  if reset = '1' then
    Counter   <= (others => '0');
    pwm_out   <= '0';
  elsif rising_edge(clk) then
    --
    if (Counter < Duty) then
      pwm_out   <= '1';
    else
      pwm_out   <= '0';
    end if;
    --
    if (Counter < Modulus) then
      Counter   <= Counter + 1;
    else
      Counter   <= (Others => '0');
    end if;
  end if;
end process;

end architecture RTL;



-- synopsys translate_off

-- --------------------------------------------------------
--   Test bench
-- --------------------------------------------------------
-- simple Avalon BFM 1 setup, 1 hold, 1 idle cycle
-- Compile this file and simulate the test bench, run -all.

Library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

Entity avalon_pwm_tb is end;

Architecture TEST of avalon_pwm_tb is
 signal clk        : std_logic := '0';
 signal reset      : std_logic := '1';
 signal writedata  : std_logic_vector (31 downto 0);
 signal chipselect : std_logic:='0';
 signal write      : std_logic:='-';
 signal read       : std_logic:='-';
 signal pwm_out    : std_logic:='-';
 signal address    : std_logic_vector ( 9 downto 0);
 signal readdata   : std_logic_vector (31 downto 0);
 signal out_port   : std_logic;
 constant Period : time := 10 ns; -- 100 MHz
 signal Done : boolean;
Begin

reset <= '0' after 2 * Period;
clk   <= '0' when Done else not Clk after Period / 2;

process
  procedure Write_cycle(a : std_logic; d : integer) is
  begin
    wait until clk='1';
    address(0)<= a;
    writedata <= std_logic_vector (to_unsigned(d,writedata'length));
    write     <= '0';
    read      <= '0';
    wait until clk='1';
    write     <= '1';
    wait until clk='1';
    writedata <= (others=>'X');
    write     <= '0';
    wait until clk='1';
  end procedure;
begin
  wait for 10 * period;
  write_cycle('0',11);  -- Period = 12 clock cycles
  write_cycle('1',6);   -- 50%
  wait for 30 * Period;

  for i in 0 to 12 loop  -- Ratio 0 .. 100 %, 3 periods
    write_cycle('1',i);
    wait for 30 * Period;
  end loop;
  wait for 30 * Period;
  Done <= True;
end process;

-- Instantiate the Unit Under Test
UUT: Entity work.avalon_pwm  port map (
    clk        => clk       ,
    reset      => reset     ,
    address    => address   ,
    write      => write     ,
    writedata  => writedata ,
    read       => read      ,
    readdata   => readdata  ,
    pwm_out    => pwm_out   );

end architecture TEST;

-- synopsys translate_on
