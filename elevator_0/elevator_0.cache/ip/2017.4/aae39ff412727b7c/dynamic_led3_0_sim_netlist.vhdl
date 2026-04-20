-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
-- Date        : Mon Apr 20 16:18:28 2026
-- Host        : LAPTOP-21A831KV running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ dynamic_led3_0_sim_netlist.vhdl
-- Design      : dynamic_led3_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a35tftg256-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_dynamic_led3 is
  port (
    dig : out STD_LOGIC_VECTOR ( 2 downto 0 );
    seg : out STD_LOGIC_VECTOR ( 7 downto 0 );
    clk : in STD_LOGIC;
    disp_data_right1 : in STD_LOGIC_VECTOR ( 8 downto 0 );
    disp_data_right2 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    disp_data_right0 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    \disp_data_right0[8]\ : in STD_LOGIC;
    \disp_data_right2[7]\ : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_dynamic_led3;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_dynamic_led3 is
  signal clk_div : STD_LOGIC;
  signal clk_div_1 : STD_LOGIC;
  signal clk_div_cnt : STD_LOGIC_VECTOR ( 24 downto 0 );
  signal \clk_div_cnt0_carry__0_n_0\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__0_n_1\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__0_n_2\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__0_n_3\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__1_n_0\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__1_n_1\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__1_n_2\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__1_n_3\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__2_n_0\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__2_n_1\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__2_n_2\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__2_n_3\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__3_n_0\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__3_n_1\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__3_n_2\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__3_n_3\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__4_n_1\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__4_n_2\ : STD_LOGIC;
  signal \clk_div_cnt0_carry__4_n_3\ : STD_LOGIC;
  signal clk_div_cnt0_carry_n_0 : STD_LOGIC;
  signal clk_div_cnt0_carry_n_1 : STD_LOGIC;
  signal clk_div_cnt0_carry_n_2 : STD_LOGIC;
  signal clk_div_cnt0_carry_n_3 : STD_LOGIC;
  signal \clk_div_cnt[0]_i_2_n_0\ : STD_LOGIC;
  signal \clk_div_cnt[0]_i_3_n_0\ : STD_LOGIC;
  signal \clk_div_cnt[0]_i_4_n_0\ : STD_LOGIC;
  signal \clk_div_cnt[0]_i_5_n_0\ : STD_LOGIC;
  signal \clk_div_cnt[0]_i_6_n_0\ : STD_LOGIC;
  signal \clk_div_cnt[0]_i_7_n_0\ : STD_LOGIC;
  signal \clk_div_cnt[0]_i_8_n_0\ : STD_LOGIC;
  signal clk_div_cnt_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal clk_div_i_1_n_0 : STD_LOGIC;
  signal data0 : STD_LOGIC_VECTOR ( 24 downto 1 );
  signal g0_b0_i_1_n_0 : STD_LOGIC;
  signal g0_b0_i_2_n_0 : STD_LOGIC;
  signal g0_b0_i_3_n_0 : STD_LOGIC;
  signal g0_b0_i_4_n_0 : STD_LOGIC;
  signal g0_b0_i_5_n_0 : STD_LOGIC;
  signal g0_b0_n_0 : STD_LOGIC;
  signal g0_b1_n_0 : STD_LOGIC;
  signal g0_b2_n_0 : STD_LOGIC;
  signal g0_b3_n_0 : STD_LOGIC;
  signal g0_b4_n_0 : STD_LOGIC;
  signal g0_b5_n_0 : STD_LOGIC;
  signal g0_b6_n_0 : STD_LOGIC;
  signal g0_b7_n_0 : STD_LOGIC;
  signal num : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \num[0]_i_1_n_0\ : STD_LOGIC;
  signal \num[1]_i_1_n_0\ : STD_LOGIC;
  signal \seg[7]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \NLW_clk_div_cnt0_carry__4_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \clk_div_cnt[0]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of clk_div_i_1 : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \dig[0]_INST_0\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \dig[1]_INST_0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \dig[2]_INST_0\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of g0_b0 : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of g0_b0_i_1 : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of g0_b0_i_2 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of g0_b0_i_3 : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of g0_b0_i_4 : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of g0_b0_i_5 : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of g0_b1 : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of g0_b2 : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of g0_b3 : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of g0_b4 : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of g0_b5 : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of g0_b6 : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of g0_b7 : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \num[0]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \num[1]_i_1\ : label is "soft_lutpair1";
begin
clk_div_cnt0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => clk_div_cnt0_carry_n_0,
      CO(2) => clk_div_cnt0_carry_n_1,
      CO(1) => clk_div_cnt0_carry_n_2,
      CO(0) => clk_div_cnt0_carry_n_3,
      CYINIT => clk_div_cnt(0),
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(4 downto 1),
      S(3 downto 0) => clk_div_cnt(4 downto 1)
    );
\clk_div_cnt0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => clk_div_cnt0_carry_n_0,
      CO(3) => \clk_div_cnt0_carry__0_n_0\,
      CO(2) => \clk_div_cnt0_carry__0_n_1\,
      CO(1) => \clk_div_cnt0_carry__0_n_2\,
      CO(0) => \clk_div_cnt0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(8 downto 5),
      S(3 downto 0) => clk_div_cnt(8 downto 5)
    );
\clk_div_cnt0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \clk_div_cnt0_carry__0_n_0\,
      CO(3) => \clk_div_cnt0_carry__1_n_0\,
      CO(2) => \clk_div_cnt0_carry__1_n_1\,
      CO(1) => \clk_div_cnt0_carry__1_n_2\,
      CO(0) => \clk_div_cnt0_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(12 downto 9),
      S(3 downto 0) => clk_div_cnt(12 downto 9)
    );
\clk_div_cnt0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \clk_div_cnt0_carry__1_n_0\,
      CO(3) => \clk_div_cnt0_carry__2_n_0\,
      CO(2) => \clk_div_cnt0_carry__2_n_1\,
      CO(1) => \clk_div_cnt0_carry__2_n_2\,
      CO(0) => \clk_div_cnt0_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(16 downto 13),
      S(3 downto 0) => clk_div_cnt(16 downto 13)
    );
\clk_div_cnt0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \clk_div_cnt0_carry__2_n_0\,
      CO(3) => \clk_div_cnt0_carry__3_n_0\,
      CO(2) => \clk_div_cnt0_carry__3_n_1\,
      CO(1) => \clk_div_cnt0_carry__3_n_2\,
      CO(0) => \clk_div_cnt0_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(20 downto 17),
      S(3 downto 0) => clk_div_cnt(20 downto 17)
    );
\clk_div_cnt0_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \clk_div_cnt0_carry__3_n_0\,
      CO(3) => \NLW_clk_div_cnt0_carry__4_CO_UNCONNECTED\(3),
      CO(2) => \clk_div_cnt0_carry__4_n_1\,
      CO(1) => \clk_div_cnt0_carry__4_n_2\,
      CO(0) => \clk_div_cnt0_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => data0(24 downto 21),
      S(3 downto 0) => clk_div_cnt(24 downto 21)
    );
\clk_div_cnt[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \clk_div_cnt[0]_i_2_n_0\,
      I1 => clk_div_cnt(0),
      O => clk_div_cnt_0(0)
    );
\clk_div_cnt[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \clk_div_cnt[0]_i_3_n_0\,
      I1 => \clk_div_cnt[0]_i_4_n_0\,
      I2 => \clk_div_cnt[0]_i_5_n_0\,
      I3 => \clk_div_cnt[0]_i_6_n_0\,
      I4 => \clk_div_cnt[0]_i_7_n_0\,
      I5 => \clk_div_cnt[0]_i_8_n_0\,
      O => \clk_div_cnt[0]_i_2_n_0\
    );
\clk_div_cnt[0]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => clk_div_cnt(18),
      I1 => clk_div_cnt(17),
      I2 => clk_div_cnt(20),
      I3 => clk_div_cnt(19),
      O => \clk_div_cnt[0]_i_3_n_0\
    );
\clk_div_cnt[0]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => clk_div_cnt(22),
      I1 => clk_div_cnt(21),
      I2 => clk_div_cnt(24),
      I3 => clk_div_cnt(23),
      O => \clk_div_cnt[0]_i_4_n_0\
    );
\clk_div_cnt[0]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => clk_div_cnt(10),
      I1 => clk_div_cnt(9),
      I2 => clk_div_cnt(12),
      I3 => clk_div_cnt(11),
      O => \clk_div_cnt[0]_i_5_n_0\
    );
\clk_div_cnt[0]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFF7"
    )
        port map (
      I0 => clk_div_cnt(14),
      I1 => clk_div_cnt(13),
      I2 => clk_div_cnt(16),
      I3 => clk_div_cnt(15),
      O => \clk_div_cnt[0]_i_6_n_0\
    );
\clk_div_cnt[0]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"DFFF"
    )
        port map (
      I0 => clk_div_cnt(5),
      I1 => clk_div_cnt(6),
      I2 => clk_div_cnt(8),
      I3 => clk_div_cnt(7),
      O => \clk_div_cnt[0]_i_7_n_0\
    );
\clk_div_cnt[0]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFEF"
    )
        port map (
      I0 => clk_div_cnt(2),
      I1 => clk_div_cnt(1),
      I2 => clk_div_cnt(3),
      I3 => clk_div_cnt(4),
      O => \clk_div_cnt[0]_i_8_n_0\
    );
\clk_div_cnt[24]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => clk_div_cnt(0),
      I1 => \clk_div_cnt[0]_i_2_n_0\,
      O => clk_div_1
    );
\clk_div_cnt_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => clk_div_cnt_0(0),
      Q => clk_div_cnt(0),
      R => '0'
    );
\clk_div_cnt_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(10),
      Q => clk_div_cnt(10),
      R => clk_div_1
    );
\clk_div_cnt_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(11),
      Q => clk_div_cnt(11),
      R => clk_div_1
    );
\clk_div_cnt_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(12),
      Q => clk_div_cnt(12),
      R => clk_div_1
    );
\clk_div_cnt_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(13),
      Q => clk_div_cnt(13),
      R => clk_div_1
    );
\clk_div_cnt_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(14),
      Q => clk_div_cnt(14),
      R => clk_div_1
    );
\clk_div_cnt_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(15),
      Q => clk_div_cnt(15),
      R => clk_div_1
    );
\clk_div_cnt_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(16),
      Q => clk_div_cnt(16),
      R => clk_div_1
    );
\clk_div_cnt_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(17),
      Q => clk_div_cnt(17),
      R => clk_div_1
    );
\clk_div_cnt_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(18),
      Q => clk_div_cnt(18),
      R => clk_div_1
    );
\clk_div_cnt_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(19),
      Q => clk_div_cnt(19),
      R => clk_div_1
    );
\clk_div_cnt_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(1),
      Q => clk_div_cnt(1),
      R => clk_div_1
    );
\clk_div_cnt_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(20),
      Q => clk_div_cnt(20),
      R => clk_div_1
    );
\clk_div_cnt_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(21),
      Q => clk_div_cnt(21),
      R => clk_div_1
    );
\clk_div_cnt_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(22),
      Q => clk_div_cnt(22),
      R => clk_div_1
    );
\clk_div_cnt_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(23),
      Q => clk_div_cnt(23),
      R => clk_div_1
    );
\clk_div_cnt_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(24),
      Q => clk_div_cnt(24),
      R => clk_div_1
    );
\clk_div_cnt_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(2),
      Q => clk_div_cnt(2),
      R => clk_div_1
    );
\clk_div_cnt_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(3),
      Q => clk_div_cnt(3),
      R => clk_div_1
    );
\clk_div_cnt_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(4),
      Q => clk_div_cnt(4),
      R => clk_div_1
    );
\clk_div_cnt_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(5),
      Q => clk_div_cnt(5),
      R => clk_div_1
    );
\clk_div_cnt_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(6),
      Q => clk_div_cnt(6),
      R => clk_div_1
    );
\clk_div_cnt_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(7),
      Q => clk_div_cnt(7),
      R => clk_div_1
    );
\clk_div_cnt_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(8),
      Q => clk_div_cnt(8),
      R => clk_div_1
    );
\clk_div_cnt_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => data0(9),
      Q => clk_div_cnt(9),
      R => clk_div_1
    );
clk_div_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E1"
    )
        port map (
      I0 => clk_div_cnt(0),
      I1 => \clk_div_cnt[0]_i_2_n_0\,
      I2 => clk_div,
      O => clk_div_i_1_n_0
    );
clk_div_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => clk_div_i_1_n_0,
      Q => clk_div,
      R => '0'
    );
\dig[0]_INST_0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => num(0),
      I1 => num(1),
      O => dig(0)
    );
\dig[1]_INST_0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => num(0),
      O => dig(1)
    );
\dig[2]_INST_0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => num(1),
      O => dig(2)
    );
g0_b0: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0012D7ED"
    )
        port map (
      I0 => g0_b0_i_1_n_0,
      I1 => g0_b0_i_2_n_0,
      I2 => g0_b0_i_3_n_0,
      I3 => g0_b0_i_4_n_0,
      I4 => g0_b0_i_5_n_0,
      O => g0_b0_n_0
    );
g0_b0_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => disp_data_right1(0),
      I1 => num(0),
      I2 => disp_data_right2(0),
      I3 => num(1),
      I4 => disp_data_right0(0),
      O => g0_b0_i_1_n_0
    );
g0_b0_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => disp_data_right1(1),
      I1 => num(0),
      I2 => disp_data_right2(1),
      I3 => num(1),
      I4 => disp_data_right0(1),
      O => g0_b0_i_2_n_0
    );
g0_b0_i_3: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => disp_data_right1(2),
      I1 => num(0),
      I2 => disp_data_right2(2),
      I3 => num(1),
      I4 => disp_data_right0(2),
      O => g0_b0_i_3_n_0
    );
g0_b0_i_4: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => disp_data_right1(3),
      I1 => num(0),
      I2 => disp_data_right2(3),
      I3 => num(1),
      I4 => disp_data_right0(3),
      O => g0_b0_i_4_n_0
    );
g0_b0_i_5: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => disp_data_right1(4),
      I1 => num(0),
      I2 => disp_data_right2(4),
      I3 => num(1),
      I4 => disp_data_right0(4),
      O => g0_b0_i_5_n_0
    );
g0_b1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0010279F"
    )
        port map (
      I0 => g0_b0_i_1_n_0,
      I1 => g0_b0_i_2_n_0,
      I2 => g0_b0_i_3_n_0,
      I3 => g0_b0_i_4_n_0,
      I4 => g0_b0_i_5_n_0,
      O => g0_b1_n_0
    );
g0_b2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00102FFB"
    )
        port map (
      I0 => g0_b0_i_1_n_0,
      I1 => g0_b0_i_2_n_0,
      I2 => g0_b0_i_3_n_0,
      I3 => g0_b0_i_4_n_0,
      I4 => g0_b0_i_5_n_0,
      O => g0_b2_n_0
    );
g0_b3: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00047B6D"
    )
        port map (
      I0 => g0_b0_i_1_n_0,
      I1 => g0_b0_i_2_n_0,
      I2 => g0_b0_i_3_n_0,
      I3 => g0_b0_i_4_n_0,
      I4 => g0_b0_i_5_n_0,
      O => g0_b3_n_0
    );
g0_b4: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0010FD45"
    )
        port map (
      I0 => g0_b0_i_1_n_0,
      I1 => g0_b0_i_2_n_0,
      I2 => g0_b0_i_3_n_0,
      I3 => g0_b0_i_4_n_0,
      I4 => g0_b0_i_5_n_0,
      O => g0_b4_n_0
    );
g0_b5: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0010DF71"
    )
        port map (
      I0 => g0_b0_i_1_n_0,
      I1 => g0_b0_i_2_n_0,
      I2 => g0_b0_i_3_n_0,
      I3 => g0_b0_i_4_n_0,
      I4 => g0_b0_i_5_n_0,
      O => g0_b5_n_0
    );
g0_b6: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000EEF7C"
    )
        port map (
      I0 => g0_b0_i_1_n_0,
      I1 => g0_b0_i_2_n_0,
      I2 => g0_b0_i_3_n_0,
      I3 => g0_b0_i_4_n_0,
      I4 => g0_b0_i_5_n_0,
      O => g0_b6_n_0
    );
g0_b7: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00010000"
    )
        port map (
      I0 => g0_b0_i_1_n_0,
      I1 => g0_b0_i_2_n_0,
      I2 => g0_b0_i_3_n_0,
      I3 => g0_b0_i_4_n_0,
      I4 => g0_b0_i_5_n_0,
      O => g0_b7_n_0
    );
\num[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => num(0),
      I1 => num(1),
      O => \num[0]_i_1_n_0\
    );
\num[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => num(0),
      I1 => num(1),
      O => \num[1]_i_1_n_0\
    );
\num_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_div,
      CE => '1',
      D => \num[0]_i_1_n_0\,
      Q => num(0),
      R => '0'
    );
\num_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_div,
      CE => '1',
      D => \num[1]_i_1_n_0\,
      Q => num(1),
      R => '0'
    );
\seg[0]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFE200E200000000"
    )
        port map (
      I0 => \disp_data_right0[8]\,
      I1 => num(1),
      I2 => \disp_data_right2[7]\,
      I3 => num(0),
      I4 => \seg[7]_INST_0_i_3_n_0\,
      I5 => g0_b0_n_0,
      O => seg(0)
    );
\seg[1]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFE200E200000000"
    )
        port map (
      I0 => \disp_data_right0[8]\,
      I1 => num(1),
      I2 => \disp_data_right2[7]\,
      I3 => num(0),
      I4 => \seg[7]_INST_0_i_3_n_0\,
      I5 => g0_b1_n_0,
      O => seg(1)
    );
\seg[2]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFE200E200000000"
    )
        port map (
      I0 => \disp_data_right0[8]\,
      I1 => num(1),
      I2 => \disp_data_right2[7]\,
      I3 => num(0),
      I4 => \seg[7]_INST_0_i_3_n_0\,
      I5 => g0_b2_n_0,
      O => seg(2)
    );
\seg[3]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFE200E200000000"
    )
        port map (
      I0 => \disp_data_right0[8]\,
      I1 => num(1),
      I2 => \disp_data_right2[7]\,
      I3 => num(0),
      I4 => \seg[7]_INST_0_i_3_n_0\,
      I5 => g0_b3_n_0,
      O => seg(3)
    );
\seg[4]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFE200E200000000"
    )
        port map (
      I0 => \disp_data_right0[8]\,
      I1 => num(1),
      I2 => \disp_data_right2[7]\,
      I3 => num(0),
      I4 => \seg[7]_INST_0_i_3_n_0\,
      I5 => g0_b4_n_0,
      O => seg(4)
    );
\seg[5]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFE200E200000000"
    )
        port map (
      I0 => \disp_data_right0[8]\,
      I1 => num(1),
      I2 => \disp_data_right2[7]\,
      I3 => num(0),
      I4 => \seg[7]_INST_0_i_3_n_0\,
      I5 => g0_b5_n_0,
      O => seg(5)
    );
\seg[6]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFE200E200000000"
    )
        port map (
      I0 => \disp_data_right0[8]\,
      I1 => num(1),
      I2 => \disp_data_right2[7]\,
      I3 => num(0),
      I4 => \seg[7]_INST_0_i_3_n_0\,
      I5 => g0_b6_n_0,
      O => seg(6)
    );
\seg[7]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFE200E200000000"
    )
        port map (
      I0 => \disp_data_right0[8]\,
      I1 => num(1),
      I2 => \disp_data_right2[7]\,
      I3 => num(0),
      I4 => \seg[7]_INST_0_i_3_n_0\,
      I5 => g0_b7_n_0,
      O => seg(7)
    );
\seg[7]_INST_0_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF00FF01"
    )
        port map (
      I0 => disp_data_right1(8),
      I1 => disp_data_right1(7),
      I2 => disp_data_right1(6),
      I3 => num(1),
      I4 => disp_data_right1(5),
      O => \seg[7]_INST_0_i_3_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    disp_data_right0 : in STD_LOGIC_VECTOR ( 8 downto 0 );
    disp_data_right1 : in STD_LOGIC_VECTOR ( 8 downto 0 );
    disp_data_right2 : in STD_LOGIC_VECTOR ( 8 downto 0 );
    clk : in STD_LOGIC;
    seg : out STD_LOGIC_VECTOR ( 7 downto 0 );
    dig : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "dynamic_led3_0,dynamic_led3,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "dynamic_led3,Vivado 2017.4";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  signal \seg[7]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \seg[7]_INST_0_i_2_n_0\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME clk, FREQ_HZ 100000000, PHASE 0.000";
begin
inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_dynamic_led3
     port map (
      clk => clk,
      dig(2 downto 0) => dig(2 downto 0),
      disp_data_right0(4 downto 0) => disp_data_right0(4 downto 0),
      \disp_data_right0[8]\ => \seg[7]_INST_0_i_1_n_0\,
      disp_data_right1(8 downto 0) => disp_data_right1(8 downto 0),
      disp_data_right2(4 downto 0) => disp_data_right2(4 downto 0),
      \disp_data_right2[7]\ => \seg[7]_INST_0_i_2_n_0\,
      seg(7 downto 0) => seg(7 downto 0)
    );
\seg[7]_INST_0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => disp_data_right0(6),
      I1 => disp_data_right0(5),
      I2 => disp_data_right0(7),
      I3 => disp_data_right0(8),
      O => \seg[7]_INST_0_i_1_n_0\
    );
\seg[7]_INST_0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => disp_data_right2(8),
      I1 => disp_data_right2(6),
      I2 => disp_data_right2(5),
      I3 => disp_data_right2(7),
      O => \seg[7]_INST_0_i_2_n_0\
    );
end STRUCTURE;
