<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:doc="http://xsltsl.org/xsl/documentation/1.0" xmlns:str="http://xsltsl.org/string" version="1.0" extension-element-prefixes="doc str">
  <doc:reference xmlns="">
    <referenceinfo>
      <releaseinfo role="meta">
	$Id: string.xsl,v 1.13 2004/10/08 06:37:25 balls Exp $
      </releaseinfo>
      <author>
        <surname>Ball</surname>
        <firstname>Steve</firstname>
      </author>
      <copyright>
        <year>2002</year>
        <year>2001</year>
        <holder>Steve Ball</holder>
      </copyright>
    </referenceinfo>
    <title>String Processing</title>
    <partintro>
      <section>
        <title>Introduction</title>
        <para>This module provides templates for manipulating strings.</para>
      </section>
    </partintro>
  </doc:reference>
  <!-- Common string constants and datasets as XSL variables -->
  <!-- str:lower and str:upper contain pairs of lower and upper case
       characters. Below insanely long strings should contain the
       official lower/uppercase pairs, making this stylesheet working
       for every language on earth. Hopefully. -->
  <!-- These values are not enough, however. There are some
       exceptions, dealt with below. -->
  <xsl:variable name="xsltsl-str-lower" select="'abcdefghijklmnopqrstuvwxyz&#xB5;&#xE0;&#xE1;&#xE2;&#xE3;&#xE4;&#xE5;&#xE6;&#xE7;&#xE8;&#xE9;&#xEA;&#xEB;&#xEC;&#xED;&#xEE;&#xEF;&#xF0;&#xF1;&#xF2;&#xF3;&#xF4;&#xF5;&#xF6;&#xF8;&#xF9;&#xFA;&#xFB;&#xFC;&#xFD;&#xFE;&#xFF;&#x101;&#x103;&#x105;&#x107;&#x109;&#x10B;&#x10D;&#x10F;&#x111;&#x113;&#x115;&#x117;&#x119;&#x11B;&#x11D;&#x11F;&#x121;&#x123;&#x125;&#x127;&#x129;&#x12B;&#x12D;&#x12F;&#x131;&#x133;&#x135;&#x137;&#x13A;&#x13C;&#x13E;&#x140;&#x142;&#x144;&#x146;&#x148;&#x14B;&#x14D;&#x14F;&#x151;&#x153;&#x155;&#x157;&#x159;&#x15B;&#x15D;&#x15F;&#x161;&#x163;&#x165;&#x167;&#x169;&#x16B;&#x16D;&#x16F;&#x171;&#x173;&#x175;&#x177;&#x17A;&#x17C;&#x17E;&#x17F;&#x183;&#x185;&#x188;&#x18C;&#x192;&#x195;&#x199;&#x1A1;&#x1A3;&#x1A5;&#x1A8;&#x1AD;&#x1B0;&#x1B4;&#x1B6;&#x1B9;&#x1BD;&#x1BF;&#x1C5;&#x1C6;&#x1C8;&#x1C9;&#x1CB;&#x1CC;&#x1CE;&#x1D0;&#x1D2;&#x1D4;&#x1D6;&#x1D8;&#x1DA;&#x1DC;&#x1DD;&#x1DF;&#x1E1;&#x1E3;&#x1E5;&#x1E7;&#x1E9;&#x1EB;&#x1ED;&#x1EF;&#x1F2;&#x1F3;&#x1F5;&#x1F9;&#x1FB;&#x1FD;&#x1FF;&#x201;&#x203;&#x205;&#x207;&#x209;&#x20B;&#x20D;&#x20F;&#x211;&#x213;&#x215;&#x217;&#x219;&#x21B;&#x21D;&#x21F;&#x223;&#x225;&#x227;&#x229;&#x22B;&#x22D;&#x22F;&#x231;&#x233;&#x253;&#x254;&#x256;&#x257;&#x259;&#x25B;&#x260;&#x263;&#x268;&#x269;&#x26F;&#x272;&#x275;&#x280;&#x283;&#x288;&#x28A;&#x28B;&#x292;&#x345;&#x3AC;&#x3AD;&#x3AE;&#x3AF;&#x3B1;&#x3B2;&#x3B3;&#x3B4;&#x3B5;&#x3B6;&#x3B7;&#x3B8;&#x3B9;&#x3BA;&#x3BB;&#x3BC;&#x3BD;&#x3BE;&#x3BF;&#x3C0;&#x3C1;&#x3C2;&#x3C3;&#x3C4;&#x3C5;&#x3C6;&#x3C7;&#x3C8;&#x3C9;&#x3CA;&#x3CB;&#x3CC;&#x3CD;&#x3CE;&#x3D0;&#x3D1;&#x3D5;&#x3D6;&#x3DB;&#x3DD;&#x3DF;&#x3E1;&#x3E3;&#x3E5;&#x3E7;&#x3E9;&#x3EB;&#x3ED;&#x3EF;&#x3F0;&#x3F1;&#x3F2;&#x3F5;&#x430;&#x431;&#x432;&#x433;&#x434;&#x435;&#x436;&#x437;&#x438;&#x439;&#x43A;&#x43B;&#x43C;&#x43D;&#x43E;&#x43F;&#x440;&#x441;&#x442;&#x443;&#x444;&#x445;&#x446;&#x447;&#x448;&#x449;&#x44A;&#x44B;&#x44C;&#x44D;&#x44E;&#x44F;&#x450;&#x451;&#x452;&#x453;&#x454;&#x455;&#x456;&#x457;&#x458;&#x459;&#x45A;&#x45B;&#x45C;&#x45D;&#x45E;&#x45F;&#x461;&#x463;&#x465;&#x467;&#x469;&#x46B;&#x46D;&#x46F;&#x471;&#x473;&#x475;&#x477;&#x479;&#x47B;&#x47D;&#x47F;&#x481;&#x48D;&#x48F;&#x491;&#x493;&#x495;&#x497;&#x499;&#x49B;&#x49D;&#x49F;&#x4A1;&#x4A3;&#x4A5;&#x4A7;&#x4A9;&#x4AB;&#x4AD;&#x4AF;&#x4B1;&#x4B3;&#x4B5;&#x4B7;&#x4B9;&#x4BB;&#x4BD;&#x4BF;&#x4C2;&#x4C4;&#x4C8;&#x4CC;&#x4D1;&#x4D3;&#x4D5;&#x4D7;&#x4D9;&#x4DB;&#x4DD;&#x4DF;&#x4E1;&#x4E3;&#x4E5;&#x4E7;&#x4E9;&#x4EB;&#x4ED;&#x4EF;&#x4F1;&#x4F3;&#x4F5;&#x4F9;&#x561;&#x562;&#x563;&#x564;&#x565;&#x566;&#x567;&#x568;&#x569;&#x56A;&#x56B;&#x56C;&#x56D;&#x56E;&#x56F;&#x570;&#x571;&#x572;&#x573;&#x574;&#x575;&#x576;&#x577;&#x578;&#x579;&#x57A;&#x57B;&#x57C;&#x57D;&#x57E;&#x57F;&#x580;&#x581;&#x582;&#x583;&#x584;&#x585;&#x586;&#x1E01;&#x1E03;&#x1E05;&#x1E07;&#x1E09;&#x1E0B;&#x1E0D;&#x1E0F;&#x1E11;&#x1E13;&#x1E15;&#x1E17;&#x1E19;&#x1E1B;&#x1E1D;&#x1E1F;&#x1E21;&#x1E23;&#x1E25;&#x1E27;&#x1E29;&#x1E2B;&#x1E2D;&#x1E2F;&#x1E31;&#x1E33;&#x1E35;&#x1E37;&#x1E39;&#x1E3B;&#x1E3D;&#x1E3F;&#x1E41;&#x1E43;&#x1E45;&#x1E47;&#x1E49;&#x1E4B;&#x1E4D;&#x1E4F;&#x1E51;&#x1E53;&#x1E55;&#x1E57;&#x1E59;&#x1E5B;&#x1E5D;&#x1E5F;&#x1E61;&#x1E63;&#x1E65;&#x1E67;&#x1E69;&#x1E6B;&#x1E6D;&#x1E6F;&#x1E71;&#x1E73;&#x1E75;&#x1E77;&#x1E79;&#x1E7B;&#x1E7D;&#x1E7F;&#x1E81;&#x1E83;&#x1E85;&#x1E87;&#x1E89;&#x1E8B;&#x1E8D;&#x1E8F;&#x1E91;&#x1E93;&#x1E95;&#x1E9B;&#x1EA1;&#x1EA3;&#x1EA5;&#x1EA7;&#x1EA9;&#x1EAB;&#x1EAD;&#x1EAF;&#x1EB1;&#x1EB3;&#x1EB5;&#x1EB7;&#x1EB9;&#x1EBB;&#x1EBD;&#x1EBF;&#x1EC1;&#x1EC3;&#x1EC5;&#x1EC7;&#x1EC9;&#x1ECB;&#x1ECD;&#x1ECF;&#x1ED1;&#x1ED3;&#x1ED5;&#x1ED7;&#x1ED9;&#x1EDB;&#x1EDD;&#x1EDF;&#x1EE1;&#x1EE3;&#x1EE5;&#x1EE7;&#x1EE9;&#x1EEB;&#x1EED;&#x1EEF;&#x1EF1;&#x1EF3;&#x1EF5;&#x1EF7;&#x1EF9;&#x1F00;&#x1F01;&#x1F02;&#x1F03;&#x1F04;&#x1F05;&#x1F06;&#x1F07;&#x1F10;&#x1F11;&#x1F12;&#x1F13;&#x1F14;&#x1F15;&#x1F20;&#x1F21;&#x1F22;&#x1F23;&#x1F24;&#x1F25;&#x1F26;&#x1F27;&#x1F30;&#x1F31;&#x1F32;&#x1F33;&#x1F34;&#x1F35;&#x1F36;&#x1F37;&#x1F40;&#x1F41;&#x1F42;&#x1F43;&#x1F44;&#x1F45;&#x1F51;&#x1F53;&#x1F55;&#x1F57;&#x1F60;&#x1F61;&#x1F62;&#x1F63;&#x1F64;&#x1F65;&#x1F66;&#x1F67;&#x1F70;&#x1F71;&#x1F72;&#x1F73;&#x1F74;&#x1F75;&#x1F76;&#x1F77;&#x1F78;&#x1F79;&#x1F7A;&#x1F7B;&#x1F7C;&#x1F7D;&#x1F80;&#x1F81;&#x1F82;&#x1F83;&#x1F84;&#x1F85;&#x1F86;&#x1F87;&#x1F90;&#x1F91;&#x1F92;&#x1F93;&#x1F94;&#x1F95;&#x1F96;&#x1F97;&#x1FA0;&#x1FA1;&#x1FA2;&#x1FA3;&#x1FA4;&#x1FA5;&#x1FA6;&#x1FA7;&#x1FB0;&#x1FB1;&#x1FB3;&#x1FBE;&#x1FC3;&#x1FD0;&#x1FD1;&#x1FE0;&#x1FE1;&#x1FE5;&#x1FF3;&#x2170;&#x2171;&#x2172;&#x2173;&#x2174;&#x2175;&#x2176;&#x2177;&#x2178;&#x2179;&#x217A;&#x217B;&#x217C;&#x217D;&#x217E;&#x217F;&#x24D0;&#x24D1;&#x24D2;&#x24D3;&#x24D4;&#x24D5;&#x24D6;&#x24D7;&#x24D8;&#x24D9;&#x24DA;&#x24DB;&#x24DC;&#x24DD;&#x24DE;&#x24DF;&#x24E0;&#x24E1;&#x24E2;&#x24E3;&#x24E4;&#x24E5;&#x24E6;&#x24E7;&#x24E8;&#x24E9;&#xFF41;&#xFF42;&#xFF43;&#xFF44;&#xFF45;&#xFF46;&#xFF47;&#xFF48;&#xFF49;&#xFF4A;&#xFF4B;&#xFF4C;&#xFF4D;&#xFF4E;&#xFF4F;&#xFF50;&#xFF51;&#xFF52;&#xFF53;&#xFF54;&#xFF55;&#xFF56;&#xFF57;&#xFF58;&#xFF59;&#xFF5A;&#x10428;&#x10429;&#x1042A;&#x1042B;&#x1042C;&#x1042D;&#x1042E;&#x1042F;&#x10430;&#x10431;&#x10432;&#x10433;&#x10434;&#x10435;&#x10436;&#x10437;&#x10438;&#x10439;&#x1043A;&#x1043B;&#x1043C;&#x1043D;&#x1043E;&#x1043F;&#x10440;&#x10441;&#x10442;&#x10443;&#x10444;&#x10445;&#x10446;&#x10447;&#x10448;&#x10449;&#x1044A;&#x1044B;&#x1044C;&#x1044D;'"/>
  <xsl:variable name="xsltsl-str-upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ&#x39C;&#xC0;&#xC1;&#xC2;&#xC3;&#xC4;&#xC5;&#xC6;&#xC7;&#xC8;&#xC9;&#xCA;&#xCB;&#xCC;&#xCD;&#xCE;&#xCF;&#xD0;&#xD1;&#xD2;&#xD3;&#xD4;&#xD5;&#xD6;&#xD8;&#xD9;&#xDA;&#xDB;&#xDC;&#xDD;&#xDE;&#x178;&#x100;&#x102;&#x104;&#x106;&#x108;&#x10A;&#x10C;&#x10E;&#x110;&#x112;&#x114;&#x116;&#x118;&#x11A;&#x11C;&#x11E;&#x120;&#x122;&#x124;&#x126;&#x128;&#x12A;&#x12C;&#x12E;I&#x132;&#x134;&#x136;&#x139;&#x13B;&#x13D;&#x13F;&#x141;&#x143;&#x145;&#x147;&#x14A;&#x14C;&#x14E;&#x150;&#x152;&#x154;&#x156;&#x158;&#x15A;&#x15C;&#x15E;&#x160;&#x162;&#x164;&#x166;&#x168;&#x16A;&#x16C;&#x16E;&#x170;&#x172;&#x174;&#x176;&#x179;&#x17B;&#x17D;S&#x182;&#x184;&#x187;&#x18B;&#x191;&#x1F6;&#x198;&#x1A0;&#x1A2;&#x1A4;&#x1A7;&#x1AC;&#x1AF;&#x1B3;&#x1B5;&#x1B8;&#x1BC;&#x1F7;&#x1C4;&#x1C4;&#x1C7;&#x1C7;&#x1CA;&#x1CA;&#x1CD;&#x1CF;&#x1D1;&#x1D3;&#x1D5;&#x1D7;&#x1D9;&#x1DB;&#x18E;&#x1DE;&#x1E0;&#x1E2;&#x1E4;&#x1E6;&#x1E8;&#x1EA;&#x1EC;&#x1EE;&#x1F1;&#x1F1;&#x1F4;&#x1F8;&#x1FA;&#x1FC;&#x1FE;&#x200;&#x202;&#x204;&#x206;&#x208;&#x20A;&#x20C;&#x20E;&#x210;&#x212;&#x214;&#x216;&#x218;&#x21A;&#x21C;&#x21E;&#x222;&#x224;&#x226;&#x228;&#x22A;&#x22C;&#x22E;&#x230;&#x232;&#x181;&#x186;&#x189;&#x18A;&#x18F;&#x190;&#x193;&#x194;&#x197;&#x196;&#x19C;&#x19D;&#x19F;&#x1A6;&#x1A9;&#x1AE;&#x1B1;&#x1B2;&#x1B7;&#x399;&#x386;&#x388;&#x389;&#x38A;&#x391;&#x392;&#x393;&#x394;&#x395;&#x396;&#x397;&#x398;&#x399;&#x39A;&#x39B;&#x39C;&#x39D;&#x39E;&#x39F;&#x3A0;&#x3A1;&#x3A3;&#x3A3;&#x3A4;&#x3A5;&#x3A6;&#x3A7;&#x3A8;&#x3A9;&#x3AA;&#x3AB;&#x38C;&#x38E;&#x38F;&#x392;&#x398;&#x3A6;&#x3A0;&#x3DA;&#x3DC;&#x3DE;&#x3E0;&#x3E2;&#x3E4;&#x3E6;&#x3E8;&#x3EA;&#x3EC;&#x3EE;&#x39A;&#x3A1;&#x3A3;&#x395;&#x410;&#x411;&#x412;&#x413;&#x414;&#x415;&#x416;&#x417;&#x418;&#x419;&#x41A;&#x41B;&#x41C;&#x41D;&#x41E;&#x41F;&#x420;&#x421;&#x422;&#x423;&#x424;&#x425;&#x426;&#x427;&#x428;&#x429;&#x42A;&#x42B;&#x42C;&#x42D;&#x42E;&#x42F;&#x400;&#x401;&#x402;&#x403;&#x404;&#x405;&#x406;&#x407;&#x408;&#x409;&#x40A;&#x40B;&#x40C;&#x40D;&#x40E;&#x40F;&#x460;&#x462;&#x464;&#x466;&#x468;&#x46A;&#x46C;&#x46E;&#x470;&#x472;&#x474;&#x476;&#x478;&#x47A;&#x47C;&#x47E;&#x480;&#x48C;&#x48E;&#x490;&#x492;&#x494;&#x496;&#x498;&#x49A;&#x49C;&#x49E;&#x4A0;&#x4A2;&#x4A4;&#x4A6;&#x4A8;&#x4AA;&#x4AC;&#x4AE;&#x4B0;&#x4B2;&#x4B4;&#x4B6;&#x4B8;&#x4BA;&#x4BC;&#x4BE;&#x4C1;&#x4C3;&#x4C7;&#x4CB;&#x4D0;&#x4D2;&#x4D4;&#x4D6;&#x4D8;&#x4DA;&#x4DC;&#x4DE;&#x4E0;&#x4E2;&#x4E4;&#x4E6;&#x4E8;&#x4EA;&#x4EC;&#x4EE;&#x4F0;&#x4F2;&#x4F4;&#x4F8;&#x531;&#x532;&#x533;&#x534;&#x535;&#x536;&#x537;&#x538;&#x539;&#x53A;&#x53B;&#x53C;&#x53D;&#x53E;&#x53F;&#x540;&#x541;&#x542;&#x543;&#x544;&#x545;&#x546;&#x547;&#x548;&#x549;&#x54A;&#x54B;&#x54C;&#x54D;&#x54E;&#x54F;&#x550;&#x551;&#x552;&#x553;&#x554;&#x555;&#x556;&#x1E00;&#x1E02;&#x1E04;&#x1E06;&#x1E08;&#x1E0A;&#x1E0C;&#x1E0E;&#x1E10;&#x1E12;&#x1E14;&#x1E16;&#x1E18;&#x1E1A;&#x1E1C;&#x1E1E;&#x1E20;&#x1E22;&#x1E24;&#x1E26;&#x1E28;&#x1E2A;&#x1E2C;&#x1E2E;&#x1E30;&#x1E32;&#x1E34;&#x1E36;&#x1E38;&#x1E3A;&#x1E3C;&#x1E3E;&#x1E40;&#x1E42;&#x1E44;&#x1E46;&#x1E48;&#x1E4A;&#x1E4C;&#x1E4E;&#x1E50;&#x1E52;&#x1E54;&#x1E56;&#x1E58;&#x1E5A;&#x1E5C;&#x1E5E;&#x1E60;&#x1E62;&#x1E64;&#x1E66;&#x1E68;&#x1E6A;&#x1E6C;&#x1E6E;&#x1E70;&#x1E72;&#x1E74;&#x1E76;&#x1E78;&#x1E7A;&#x1E7C;&#x1E7E;&#x1E80;&#x1E82;&#x1E84;&#x1E86;&#x1E88;&#x1E8A;&#x1E8C;&#x1E8E;&#x1E90;&#x1E92;&#x1E94;&#x1E60;&#x1EA0;&#x1EA2;&#x1EA4;&#x1EA6;&#x1EA8;&#x1EAA;&#x1EAC;&#x1EAE;&#x1EB0;&#x1EB2;&#x1EB4;&#x1EB6;&#x1EB8;&#x1EBA;&#x1EBC;&#x1EBE;&#x1EC0;&#x1EC2;&#x1EC4;&#x1EC6;&#x1EC8;&#x1ECA;&#x1ECC;&#x1ECE;&#x1ED0;&#x1ED2;&#x1ED4;&#x1ED6;&#x1ED8;&#x1EDA;&#x1EDC;&#x1EDE;&#x1EE0;&#x1EE2;&#x1EE4;&#x1EE6;&#x1EE8;&#x1EEA;&#x1EEC;&#x1EEE;&#x1EF0;&#x1EF2;&#x1EF4;&#x1EF6;&#x1EF8;&#x1F08;&#x1F09;&#x1F0A;&#x1F0B;&#x1F0C;&#x1F0D;&#x1F0E;&#x1F0F;&#x1F18;&#x1F19;&#x1F1A;&#x1F1B;&#x1F1C;&#x1F1D;&#x1F28;&#x1F29;&#x1F2A;&#x1F2B;&#x1F2C;&#x1F2D;&#x1F2E;&#x1F2F;&#x1F38;&#x1F39;&#x1F3A;&#x1F3B;&#x1F3C;&#x1F3D;&#x1F3E;&#x1F3F;&#x1F48;&#x1F49;&#x1F4A;&#x1F4B;&#x1F4C;&#x1F4D;&#x1F59;&#x1F5B;&#x1F5D;&#x1F5F;&#x1F68;&#x1F69;&#x1F6A;&#x1F6B;&#x1F6C;&#x1F6D;&#x1F6E;&#x1F6F;&#x1FBA;&#x1FBB;&#x1FC8;&#x1FC9;&#x1FCA;&#x1FCB;&#x1FDA;&#x1FDB;&#x1FF8;&#x1FF9;&#x1FEA;&#x1FEB;&#x1FFA;&#x1FFB;&#x1F88;&#x1F89;&#x1F8A;&#x1F8B;&#x1F8C;&#x1F8D;&#x1F8E;&#x1F8F;&#x1F98;&#x1F99;&#x1F9A;&#x1F9B;&#x1F9C;&#x1F9D;&#x1F9E;&#x1F9F;&#x1FA8;&#x1FA9;&#x1FAA;&#x1FAB;&#x1FAC;&#x1FAD;&#x1FAE;&#x1FAF;&#x1FB8;&#x1FB9;&#x1FBC;&#x399;&#x1FCC;&#x1FD8;&#x1FD9;&#x1FE8;&#x1FE9;&#x1FEC;&#x1FFC;&#x2160;&#x2161;&#x2162;&#x2163;&#x2164;&#x2165;&#x2166;&#x2167;&#x2168;&#x2169;&#x216A;&#x216B;&#x216C;&#x216D;&#x216E;&#x216F;&#x24B6;&#x24B7;&#x24B8;&#x24B9;&#x24BA;&#x24BB;&#x24BC;&#x24BD;&#x24BE;&#x24BF;&#x24C0;&#x24C1;&#x24C2;&#x24C3;&#x24C4;&#x24C5;&#x24C6;&#x24C7;&#x24C8;&#x24C9;&#x24CA;&#x24CB;&#x24CC;&#x24CD;&#x24CE;&#x24CF;&#xFF21;&#xFF22;&#xFF23;&#xFF24;&#xFF25;&#xFF26;&#xFF27;&#xFF28;&#xFF29;&#xFF2A;&#xFF2B;&#xFF2C;&#xFF2D;&#xFF2E;&#xFF2F;&#xFF30;&#xFF31;&#xFF32;&#xFF33;&#xFF34;&#xFF35;&#xFF36;&#xFF37;&#xFF38;&#xFF39;&#xFF3A;&#x10400;&#x10401;&#x10402;&#x10403;&#x10404;&#x10405;&#x10406;&#x10407;&#x10408;&#x10409;&#x1040A;&#x1040B;&#x1040C;&#x1040D;&#x1040E;&#x1040F;&#x10410;&#x10411;&#x10412;&#x10413;&#x10414;&#x10415;&#x10416;&#x10417;&#x10418;&#x10419;&#x1041A;&#x1041B;&#x1041C;&#x1041D;&#x1041E;&#x1041F;&#x10420;&#x10421;&#x10422;&#x10423;&#x10424;&#x10425;'"/>
  <xsl:variable name="xsltsl-str-digits" select="'0123456789'"/>
  <!-- space (#x20) characters, carriage returns, line feeds, or tabs. -->
  <xsl:variable name="xsltsl-str-ws" select="' &#9;&#13;&#10;'"/>
  <doc:template xmlns="" name="str:to-upper">
    <refpurpose>Make string uppercase</refpurpose>
    <refdescription>
      <para>Converts all lowercase letters to uppercase.</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string to be converted</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns string with all uppercase letters.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:to-upper">
    <xsl:param name="text"/>
    <!-- Below exception is extracted from unicode's SpecialCasing.txt
         file. It's the german lowercase "eszett" (the thing looking
         like a greek beta) that's to become "SS" in uppercase (note:
         that are *two* characters, that's why it doesn't fit in the
         list of upper/lowercase characters). There are more
         characters in that file (103, excluding the locale-specific
         ones), but they seemed to be much less used to me and they
         add up to a hellish long stylesheet.... - Reinout -->
    <xsl:param name="modified-text">
      <xsl:call-template name="str:subst">
        <xsl:with-param name="text">
          <xsl:value-of select="$text"/>
        </xsl:with-param>
        <xsl:with-param name="replace">
          <xsl:text>&#xDF;</xsl:text>
        </xsl:with-param>
        <xsl:with-param name="with">
          <xsl:text>S</xsl:text>
          <xsl:text>S</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:param>
    <xsl:value-of select="translate($modified-text, $xsltsl-str-lower, $xsltsl-str-upper)"/>
  </xsl:template>
  <doc:template xmlns="" name="str:to-lower">
    <refpurpose>Make string lowercase</refpurpose>
    <refdescription>
      <para>Converts all uppercase letters to lowercase.</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string to be converted</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns string with all lowercase letters.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:to-lower">
    <xsl:param name="text"/>
    <xsl:value-of select="translate($text, $xsltsl-str-upper, $xsltsl-str-lower)"/>
  </xsl:template>
  <doc:template xmlns="" name="str:capitalise">
    <refpurpose>Capitalise string</refpurpose>
    <refdescription>
      <para>Converts first character of string to an uppercase letter.  All remaining characters are converted to lowercase.</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string to be capitalised</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>all</term>
          <listitem>
            <para>Boolean controlling whether all words in the string are capitalised.</para>
            <para>Default is true.</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns string with first character uppercase and all remaining characters lowercase.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:capitalise">
    <xsl:param name="text"/>
    <xsl:param name="all" select="true()"/>
    <xsl:choose>
      <xsl:when test="$all and (contains($text, ' ') or contains($text, ' ') or contains($text, '&#10;'))">
        <xsl:variable name="firstword">
          <xsl:call-template name="str:substring-before-first">
            <xsl:with-param name="text" select="$text"/>
            <xsl:with-param name="chars" select="$xsltsl-str-ws"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="str:capitalise">
          <xsl:with-param name="text">
            <xsl:value-of select="$firstword"/>
          </xsl:with-param>
          <xsl:with-param name="all" select="false()"/>
        </xsl:call-template>
        <xsl:value-of select="substring($text, string-length($firstword) + 1, 1)"/>
        <xsl:call-template name="str:capitalise">
          <xsl:with-param name="text">
            <xsl:value-of select="substring($text, string-length($firstword) + 2)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="str:to-upper">
          <xsl:with-param name="text" select="substring($text, 1, 1)"/>
        </xsl:call-template>
        <xsl:call-template name="str:to-lower">
          <xsl:with-param name="text" select="substring($text, 2)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc:template xmlns="" name="str:to-camelcase">
    <refpurpose>Convert a string to one camelcase word</refpurpose>
    <refdescription>
      <para>Converts a string to one lowerCamelCase or UpperCamelCase
      word, depending on the setting of the "upper"
      parameter. UpperCamelCase is also called MixedCase while
      lowerCamelCase is also called just camelCase. The template
      removes any spaces, tabs and slashes, but doesn't deal with
      other punctuation. It's purpose is to convert strings like
      "hollow timber flush door" to a term suitable as identifier or
      XML tag like "HollowTimberFlushDoor".
      </para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string to be capitalised</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>upper</term>
          <listitem>
            <para>Boolean controlling whether the string becomes an
            UpperCamelCase word or a lowerCamelCase word.</para>
            <para>Default is true.</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns string with first character uppercase and all remaining characters lowercase.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:to-camelcase">
    <xsl:param name="text"/>
    <xsl:param name="upper" select="true()"/>
    <!-- First change all 'strange' characters to spaces -->
    <xsl:param name="string-with-only-spaces">
      <xsl:value-of select="translate($text,concat($xsltsl-str-ws,'/'),'     ')"/>
    </xsl:param>
    <!-- Then process them -->
    <xsl:param name="before-space-removal">
      <xsl:variable name="firstword">
        <xsl:call-template name="str:substring-before-first">
          <xsl:with-param name="text" select="$string-with-only-spaces"/>
          <xsl:with-param name="chars" select="$xsltsl-str-ws"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$upper">
          <xsl:call-template name="str:to-upper">
            <xsl:with-param name="text" select="substring($firstword, 1, 1)"/>
          </xsl:call-template>
          <xsl:call-template name="str:to-lower">
            <xsl:with-param name="text" select="substring($firstword, 2)"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="str:to-lower">
            <xsl:with-param name="text" select="$firstword"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="str:capitalise">
        <xsl:with-param name="text">
          <xsl:value-of select="substring($string-with-only-spaces, string-length($firstword) + 2)"/>
        </xsl:with-param>
        <xsl:with-param name="all" select="true()"/>
      </xsl:call-template>
    </xsl:param>
    <xsl:value-of select="translate($before-space-removal,' ','')"/>
  </xsl:template>
  <doc:template xmlns="" name="str:substring-before-first">
    <refpurpose>String extraction</refpurpose>
    <refdescription>
      <para>Extracts the portion of string 'text' which occurs before any of the characters in string 'chars'.</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string from which to extract a substring.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>chars</term>
          <listitem>
            <para>The string containing characters to find.</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns string.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:substring-before-first">
    <xsl:param name="text"/>
    <xsl:param name="chars"/>
    <xsl:choose>
      <xsl:when test="string-length($text) = 0"/>
      <xsl:when test="string-length($chars) = 0">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:when test="contains($text, substring($chars, 1, 1))">
        <xsl:variable name="this" select="substring-before($text, substring($chars, 1, 1))"/>
        <xsl:variable name="rest">
          <xsl:call-template name="str:substring-before-first">
            <xsl:with-param name="text" select="$text"/>
            <xsl:with-param name="chars" select="substring($chars, 2)"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length($this) &lt; string-length($rest)">
            <xsl:value-of select="$this"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$rest"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="str:substring-before-first">
          <xsl:with-param name="text" select="$text"/>
          <xsl:with-param name="chars" select="substring($chars, 2)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc:template xmlns="" name="str:substring-after-last">
    <refpurpose>String extraction</refpurpose>
    <refdescription>
      <para>Extracts the portion of string 'text' which occurs after the last of the character in string 'chars'.</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string from which to extract a substring.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>chars</term>
          <listitem>
            <para>The string containing characters to find.</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns string.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:substring-after-last">
    <xsl:param name="text"/>
    <xsl:param name="chars"/>
    <xsl:choose>
      <xsl:when test="contains($text, $chars)">
        <xsl:variable name="last" select="substring-after($text, $chars)"/>
        <xsl:choose>
          <xsl:when test="contains($last, $chars)">
            <xsl:call-template name="str:substring-after-last">
              <xsl:with-param name="text" select="$last"/>
              <xsl:with-param name="chars" select="$chars"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$last"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc:template xmlns="" name="str:substring-before-last">
    <refpurpose>String extraction</refpurpose>
    <refdescription>
      <para>Extracts the portion of string 'text' which occurs before the first character of the last occurance of string 'chars'.</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string from which to extract a substring.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>chars</term>
          <listitem>
            <para>The string containing characters to find.</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns string.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:substring-before-last">
    <xsl:param name="text"/>
    <xsl:param name="chars"/>
    <xsl:choose>
      <xsl:when test="string-length($text) = 0"/>
      <xsl:when test="string-length($chars) = 0">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:when test="contains($text, $chars)">
        <xsl:call-template name="str:substring-before-last-aux">
          <xsl:with-param name="text" select="$text"/>
          <xsl:with-param name="chars" select="$chars"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="str:substring-before-last-aux">
    <xsl:param name="text"/>
    <xsl:param name="chars"/>
    <xsl:choose>
      <xsl:when test="string-length($text) = 0"/>
      <xsl:when test="contains($text, $chars)">
        <xsl:variable name="after">
          <xsl:call-template name="str:substring-before-last-aux">
            <xsl:with-param name="text" select="substring-after($text, $chars)"/>
            <xsl:with-param name="chars" select="$chars"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="substring-before($text, $chars)"/>
        <xsl:if test="string-length($after) &gt; 0">
          <xsl:value-of select="$chars"/>
          <xsl:copy-of select="$after"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  <doc:template xmlns="" name="str:subst">
    <refpurpose>String substitution</refpurpose>
    <refdescription>
      <para>Substitute 'replace' for 'with' in string 'text'.</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string upon which to perform substitution.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>replace</term>
          <listitem>
            <para>The string to substitute.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>with</term>
          <listitem>
            <para>The string to be substituted.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>disable-output-escaping</term>
          <listitem>
            <para>A value of <literal>yes</literal> indicates that the result should have output escaping disabled.  Any other value allows normal escaping of text values.  The default is to enable output escaping.</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns string.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:subst">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:param name="disable-output-escaping">no</xsl:param>
    <xsl:choose>
      <xsl:when test="string-length($replace) = 0 and $disable-output-escaping = 'yes'">
        <xsl:value-of select="$text" disable-output-escaping="yes"/>
      </xsl:when>
      <xsl:when test="string-length($replace) = 0">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:when test="contains($text, $replace)">
        <xsl:variable name="before" select="substring-before($text, $replace)"/>
        <xsl:variable name="after" select="substring-after($text, $replace)"/>
        <xsl:choose>
          <xsl:when test="$disable-output-escaping = &quot;yes&quot;">
            <xsl:value-of select="$before" disable-output-escaping="yes"/>
            <xsl:value-of select="$with" disable-output-escaping="yes"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$before"/>
            <xsl:value-of select="$with"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="str:subst">
          <xsl:with-param name="text" select="$after"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
          <xsl:with-param name="disable-output-escaping" select="$disable-output-escaping"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$disable-output-escaping = &quot;yes&quot;">
        <xsl:value-of select="$text" disable-output-escaping="yes"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc:template xmlns="" name="str:count-substring">
    <refpurpose>Count Substrings</refpurpose>
    <refdescription>
      <para>Counts the number of times a substring occurs in a string.  This can also counts the number of times a character occurs in a string, since a character is simply a string of length 1.</para>
    </refdescription>
    <example>
      <title>Counting Lines</title>
      <programlisting><![CDATA[
<xsl:call-template name="str:count-substring">
  <xsl:with-param name="text" select="$mytext"/>
  <xsl:with-param name="chars" select="'&#x0a;'"/>
</xsl:call-template>
]]></programlisting>
    </example>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The source string.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>chars</term>
          <listitem>
            <para>The substring to count.</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns a non-negative integer value.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:count-substring">
    <xsl:param name="text"/>
    <xsl:param name="chars"/>
    <xsl:choose>
      <xsl:when test="string-length($text) = 0 or string-length($chars) = 0">
        <xsl:text>0</xsl:text>
      </xsl:when>
      <xsl:when test="contains($text, $chars)">
        <xsl:variable name="remaining">
          <xsl:call-template name="str:count-substring">
            <xsl:with-param name="text" select="substring-after($text, $chars)"/>
            <xsl:with-param name="chars" select="$chars"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$remaining + 1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc:template xmlns="" name="str:substring-after-at">
    <refpurpose>String extraction</refpurpose>
    <refdescription>
      <para>Extracts the portion of a 'char' delimited 'text' string "array" at a given 'position'.</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string from which to extract a substring.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>chars</term>
          <listitem>
            <para>delimiters</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>position</term>
          <listitem>
            <para>position of the elements</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>all</term>
          <listitem>
            <para>If true all of the remaining string is returned, otherwise only the element at the given position is returned.  Default: false().</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns string.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:substring-after-at">
    <xsl:param name="text"/>
    <xsl:param name="chars"/>
    <xsl:param name="position"/>
    <xsl:param name="all" select="false()"/>
    <xsl:choose>
      <xsl:when test="number($position) = 0 and $all">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:when test="number($position) = 0 and not($chars)">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:when test="number($position) = 0 and not(contains($text, $chars))">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:when test="not(contains($text, $chars))">
      </xsl:when>
      <xsl:when test="number($position) = 0">
        <xsl:value-of select="substring-before($text, $chars)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="str:substring-after-at">
          <xsl:with-param name="text" select="substring-after($text, $chars)"/>
          <xsl:with-param name="chars" select="$chars"/>
          <xsl:with-param name="all" select="$all"/>
          <xsl:with-param name="position" select="$position - 1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc:template xmlns="" name="str:substring-before-at">
    <refpurpose>String extraction</refpurpose>
    <refdescription>
      <para>Extracts the portion of a 'char' delimited 'text' string "array" at a given 'position' </para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string from which to extract a substring.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>chars</term>
          <listitem>
            <para>delimiters</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>position</term>
          <listitem>
            <para>position of the elements</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns string.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:substring-before-at">
    <xsl:param name="text"/>
    <xsl:param name="chars"/>
    <xsl:param name="position"/>
    <xsl:choose>
      <xsl:when test="$position &lt;= 0"/>
      <xsl:when test="not(contains($text, $chars))"/>
      <xsl:otherwise>
        <xsl:value-of select="substring-before($text, $chars)"/>
        <xsl:value-of select="$chars"/>
        <xsl:call-template name="str:substring-before-at">
          <xsl:with-param name="text" select="substring-after($text, $chars)"/>
          <xsl:with-param name="position" select="$position - 1"/>
          <xsl:with-param name="chars" select="$chars"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc:template xmlns="" name="str:insert-at">
    <refpurpose>String insertion</refpurpose>
    <refdescription>
      <para>Insert 'chars' into "text' at any given "position'</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string upon which to perform insertion</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>position</term>
          <listitem>
            <para>the position where insertion will be performed</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>with</term>
          <listitem>
            <para>The string to be inserted</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns string.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:insert-at">
    <xsl:param name="text"/>
    <xsl:param name="position"/>
    <xsl:param name="chars"/>
    <xsl:variable name="firstpart" select="substring($text, 0, $position)"/>
    <xsl:variable name="secondpart" select="substring($text, $position, string-length($text))"/>
    <xsl:value-of select="concat($firstpart, $chars, $secondpart)"/>
  </xsl:template>
  <doc:template xmlns="" name="str:backward">
    <refpurpose>String reversal</refpurpose>
    <refdescription>
      <para>Reverse the content of a given string</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string to be reversed</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns string.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:backward">
    <xsl:param name="text"/>
    <xsl:variable name="mirror">
      <xsl:call-template name="str:build-mirror">
        <xsl:with-param name="text" select="$text"/>
        <xsl:with-param name="position" select="string-length($text)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="substring($mirror, string-length($text) + 1, string-length($text))"/>
  </xsl:template>
  <xsl:template name="str:build-mirror">
    <xsl:param name="text"/>
    <xsl:param name="position"/>
    <xsl:choose>
      <xsl:when test="$position &gt; 0">
        <xsl:call-template name="str:build-mirror">
          <xsl:with-param name="text" select="concat($text, substring($text, $position, 1))"/>
          <xsl:with-param name="position" select="$position - 1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc:template xmlns="" name="str:justify">
    <refpurpose>Format a string</refpurpose>
    <refdescription>
      <para>Inserts newlines and spaces into a string to format it as a block of text.</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>String to be formatted.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>max</term>
          <listitem>
            <para>Maximum line length.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>indent</term>
          <listitem>
            <para>Number of spaces to insert at the beginning of each line.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>justify</term>
          <listitem>
            <para>Justify left, right or both.  Not currently implemented (fixed at "left").</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Formatted block of text.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:justify">
    <xsl:param name="text"/>
    <xsl:param name="max" select="&quot;80&quot;"/>
    <xsl:param name="indent" select="&quot;0&quot;"/>
    <xsl:param name="justify" select="&quot;left&quot;"/>
    <xsl:choose>
      <xsl:when test="string-length($text) = 0 or $max &lt;= 0"/>
      <xsl:when test="string-length($text) &gt; $max and contains($text, &quot; &quot;) and string-length(substring-before($text, &quot; &quot;)) &gt; $max">
        <xsl:call-template name="str:generate-string">
          <xsl:with-param name="text" select="&quot; &quot;"/>
          <xsl:with-param name="count" select="$indent"/>
        </xsl:call-template>
        <xsl:value-of select="substring-before($text, &quot; &quot;)"/>
        <xsl:text>
</xsl:text>
        <xsl:call-template name="str:justify">
          <xsl:with-param name="text" select="substring-after($text, &quot; &quot;)"/>
          <xsl:with-param name="max" select="$max"/>
          <xsl:with-param name="indent" select="$indent"/>
          <xsl:with-param name="justify" select="$justify"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="string-length($text) &gt; $max and contains($text, &quot; &quot;)">
        <xsl:variable name="first">
          <xsl:call-template name="str:substring-before-last">
            <xsl:with-param name="text" select="substring($text, 1, $max)"/>
            <xsl:with-param name="chars" select="&quot; &quot;"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="str:generate-string">
          <xsl:with-param name="text" select="&quot; &quot;"/>
          <xsl:with-param name="count" select="$indent"/>
        </xsl:call-template>
        <xsl:value-of select="$first"/>
        <xsl:text>
</xsl:text>
        <xsl:call-template name="str:justify">
          <xsl:with-param name="text" select="substring($text, string-length($first) + 2)"/>
          <xsl:with-param name="max" select="$max"/>
          <xsl:with-param name="indent" select="$indent"/>
          <xsl:with-param name="justify" select="$justify"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="str:generate-string">
          <xsl:with-param name="text" select="&quot; &quot;"/>
          <xsl:with-param name="count" select="$indent"/>
        </xsl:call-template>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc:template xmlns="" name="str:character-first">
    <refpurpose>Find first occurring character in a string</refpurpose>
    <refdescription>
      <para>Finds which of the given characters occurs first in a string.</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The source string.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>chars</term>
          <listitem>
            <para>The characters to search for.</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
  </doc:template>
  <xsl:template name="str:character-first">
    <xsl:param name="text"/>
    <xsl:param name="chars"/>
    <xsl:choose>
      <xsl:when test="string-length($text) = 0 or string-length($chars) = 0"/>
      <xsl:when test="contains($text, substring($chars, 1, 1))">
        <xsl:variable name="next-character">
          <xsl:call-template name="str:character-first">
            <xsl:with-param name="text" select="$text"/>
            <xsl:with-param name="chars" select="substring($chars, 2)"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length($next-character)">
            <xsl:variable name="first-character-position" select="string-length(substring-before($text, substring($chars, 1, 1)))"/>
            <xsl:variable name="next-character-position" select="string-length(substring-before($text, $next-character))"/>
            <xsl:choose>
              <xsl:when test="$first-character-position &lt; $next-character-position">
                <xsl:value-of select="substring($chars, 1, 1)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$next-character"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring($chars, 1, 1)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="str:character-first">
          <xsl:with-param name="text" select="$text"/>
          <xsl:with-param name="chars" select="substring($chars, 2)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc:template xmlns="" name="str:string-match">
    <refpurpose>Match A String To A Pattern</refpurpose>
    <refdescription>
      <para>Performs globbing-style pattern matching on a string.</para>
    </refdescription>
    <example>
      <title>Match Pattern</title>
      <programlisting><![CDATA[
<xsl:call-template name="str:string-match">
  <xsl:with-param name="text" select="$mytext"/>
  <xsl:with-param name="pattern" select="'abc*def?g'"/>
</xsl:call-template>
]]></programlisting>
    </example>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The source string.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>pattern</term>
          <listitem>
            <para>The pattern to match against.  Certain characters have special meaning:</para>
            <variablelist>
              <varlistentry>
                <term>*</term>
                <listitem>
                  <para>Matches zero or more characters.</para>
                </listitem>
              </varlistentry>
              <varlistentry>
                <term>?</term>
                <listitem>
                  <para>Matches a single character.</para>
                </listitem>
              </varlistentry>
              <varlistentry>
                <term>\</term>
                <listitem>
                  <para>Character escape.  The next character is taken as a literal character.</para>
                </listitem>
              </varlistentry>
            </variablelist>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
    <refreturn>
      <para>Returns "1" if the string matches the pattern, "0" otherwise.</para>
    </refreturn>
  </doc:template>
  <xsl:template name="str:string-match">
    <xsl:param name="text"/>
    <xsl:param name="pattern"/>
    <xsl:choose>
      <xsl:when test="$pattern = '*'">
        <!-- Special case: always matches -->
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:when test="string-length($text) = 0 and string-length($pattern) = 0">
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:when test="string-length($text) = 0 or string-length($pattern) = 0">
        <xsl:text>0</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="before-special">
          <xsl:call-template name="str:substring-before-first">
            <xsl:with-param name="text" select="$pattern"/>
            <xsl:with-param name="chars" select="&quot;*?\&quot;"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="special">
          <xsl:call-template name="str:character-first">
            <xsl:with-param name="text" select="$pattern"/>
            <xsl:with-param name="chars" select="&quot;*?\&quot;"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="new-text" select="substring($text, string-length($before-special) + 1)"/>
        <xsl:variable name="new-pattern" select="substring($pattern, string-length($before-special) + 1)"/>
        <xsl:choose>
          <xsl:when test="not(starts-with($text, $before-special))">
            <!-- Verbatim characters don't match -->
            <xsl:text>0</xsl:text>
          </xsl:when>
          <xsl:when test="$special = '*' and string-length($new-pattern) = 1">
            <xsl:text>1</xsl:text>
          </xsl:when>
          <xsl:when test="$special = '*'">
            <xsl:call-template name="str:match-postfix">
              <xsl:with-param name="text" select="$new-text"/>
              <xsl:with-param name="pattern" select="substring($new-pattern, 2)"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$special = '?'">
            <xsl:call-template name="str:string-match">
              <xsl:with-param name="text" select="substring($new-text, 2)"/>
              <xsl:with-param name="pattern" select="substring($new-pattern, 2)"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$special = '\' and substring($new-text, 1, 1) = substring($new-pattern, 2, 1)">
            <xsl:call-template name="str:string-match">
              <xsl:with-param name="text" select="substring($new-text, 2)"/>
              <xsl:with-param name="pattern" select="substring($new-pattern, 3)"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$special = '\' and substring($new-text, 1, 1) != substring($new-pattern, 2, 1)">
            <xsl:text>0</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <!-- There were no special characters in the pattern -->
            <xsl:choose>
              <xsl:when test="$text = $pattern">
                <xsl:text>1</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>0</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="str:match-postfix">
    <xsl:param name="text"/>
    <xsl:param name="pattern"/>
    <xsl:variable name="result">
      <xsl:call-template name="str:string-match">
        <xsl:with-param name="text" select="$text"/>
        <xsl:with-param name="pattern" select="$pattern"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$result = &quot;1&quot;">
        <xsl:value-of select="$result"/>
      </xsl:when>
      <xsl:when test="string-length($text) = 0">
        <xsl:text>0</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="str:match-postfix">
          <xsl:with-param name="text" select="substring($text, 2)"/>
          <xsl:with-param name="pattern" select="$pattern"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <doc:template xmlns="" name="str:generate-string">
    <refpurpose>Create A Repeating Sequence of Characters</refpurpose>
    <refdescription>
      <para>Repeats a string a given number of times.</para>
    </refdescription>
    <refparameter>
      <variablelist>
        <varlistentry>
          <term>text</term>
          <listitem>
            <para>The string to repeat.</para>
          </listitem>
        </varlistentry>
        <varlistentry>
          <term>count</term>
          <listitem>
            <para>The number of times to repeat the string.</para>
          </listitem>
        </varlistentry>
      </variablelist>
    </refparameter>
  </doc:template>
  <xsl:template name="str:generate-string">
    <xsl:param name="text"/>
    <xsl:param name="count"/>
    <xsl:choose>
      <xsl:when test="string-length($text) = 0 or $count &lt;= 0"/>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
        <xsl:call-template name="str:generate-string">
          <xsl:with-param name="text" select="$text"/>
          <xsl:with-param name="count" select="$count - 1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
