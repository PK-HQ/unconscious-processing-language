function [textpt3]=word(wordNo,condition)
Array=cell(79,2); %10 blank + 70 sentences

Array(1,1) = {'shops accept cash'};
Array(1,2) = {'shops accept spent'};


Array(2,1) = {'hosts welcome visitors'};
Array(2,2) = {'hosts welcome examine'};


Array(3,1) = {'clients asked staffs'};
Array(3,2) = {'clients asked happens'};

456

Array(7,1) = {'workers build houses'};
Array(7,2) = {'workers build assemble'};

Array(8,1) = {'bugs bite people'};
Array(8,2) = {'bugs bite seize'};


Array(9,1) = {'clowns blow ballons'};
Array(9,2) = {'clowns blow blasting'};

10

Array(11,1) = {'tutors teach courses'};
Array(11,2) = {'tutors teach educate'};

12
13

Array(14,1) = {'furnaces burn gas'};
Array(14,2) = {'furnaces burn fired'};

15

Array(16,1) = {'anthony closed boxes'};
Array(16,2) = {'anthony closed shut'};

Array(17,1) = {'moms cook dinner'};
Array(17,2) = {'moms cook boil'};

Array(18,1) = {'kids count numbers'};
Array(18,2) = {'kids count noticed'};

Array(19,1) = {'Army cut budgets'};
Array(19,2) = {'Army cut dissect'};

20
21

Array(22,1) = {'charts marked voters'};
Array(22,2) = {'charts marked messed'};

23

Array(24,1) = {'luxuries cost money'};
Array(24,2) = {'luxuries cost paid'};

Array(25,1) = {'funds cover expenses'};
Array(25,2) = {'funds cover include'};

26 
27 
28

Array(29,1) = {'firemen drive trucks'};
Array(29,2) = {'firemen drive retire'};

Array(30,1) = {'birds eat worms'};
Array(30,2) = {'birds eat drank'};

Array(31,1) = {'gourmets enjoy meals'};
Array(31,2) = {'gourmets enjoy tasted'};

Array(32,1) = {' '};
Array(32,2) = {' '};

Array(33,1) = {'keepers feed pets'};
Array(33,2) = {'keepers feed waits'};

34

Array(35,1) = {'judges explain law'};
Array(35,2) = {'judges explain infer'};

36

Array(37,1) = {'plans fit goals'};
Array(37,2) = {'plans fit meet'};

Array(38,1) = {'boys ride bikes'};
Array(38,2) = {'boys ride seeks'};

Array(39,1) = {'pilots fly planes'};
Array(39,2) = {'pilots fly moved'};

40

41

Array(42,1) = {'counties trim trees'};
Array(42,2) = {'counties trim ended'};

Array(43,1) = {'painters use tools'};
Array(43,2) = {'painters use spoil'};

Array(44,1) = {'hosts give presents'};
Array(44,2) = {'hosts give operate'};

Array(45,1) = {'doers grab chances'};
Array(45,2) = {'doers grab depends'};

46

Array(47,1) = {'cats heard sounds'};
Array(47,2) = {'cats heard listens'};

48

Array(49,1) = {'humans hide secrets'};
Array(49,2) = {'humans hide appear'};

Array(50,1) = {'lawyers handle cases'};
Array(50,2) = {'lawyers handle fought'};

Array(51,1) = {'artists hang pictures'};
Array(51,2) = {'artists hang putting'};

Array(52,1) = {'arrows hit targets'};
Array(52,2) = {'arrows hit crushed'};

Array(53,1) = {'agents hurry clerks'};
Array(53,2) = {'agents hurry rotate'};

54

55

Array(56,1) = {'machines wash clothes'};
Array(56,2) = {'machines wash cleaned'};

Array(57,1) = {'geniuses know facts'};
Array(57,2) = {'geniuses know finds'};

Array(58,1) = {'players kick balls'};
Array(58,2) = {'players kick settle'};

Array(59,1) = {'parents kiss babies'};
Array(59,2) = {'parents kiss remain'};

Array(60,1) = {'sons left home'};
Array(60,2) = {'sons left depart'};

Array(61,1) = {'henry likes math'};
Array(61,2) = {'henry likes devote'};

Array(62,1) = {'videos include music'};
Array(62,2) = {'videos include thinks'};

Array(63,1) = {'women lost weight'};
Array(63,2) = {'women lost cease'};

Array(64,1) = {'chickens lay eggs'};
Array(64,2) = {'chickens lay serve'};

Array(65,1) = {'victors lift trophies'};
Array(65,2) = {'victors lift arises'};

Array(66,1) = {'guards locked safes'};
Array(66,2) = {'guards locked fasten'};

Array(68,1) = {'firms make profits'};
Array(68,2) = {'firms make rushed'};

Array(69,1) = {'infants need care'};
Array(69,2) = {'infants need wants'};

Array(70,1) = {'owners named dogs'};
Array(70,2) = {'owners named coined'};

Array(71,1) = {'experts offer advice'};
Array(71,2) = {'experts offer provide'};

Array(72,1) = {'friends watch movies'};
Array(72,2) = {'friends watch discuss'};

Array(73,1) = {'waiters wear suits'};
Array(73,2) = {'waiters wear formed'};

Array(76,1) = {'sports push limits'};
Array(76,2) = {'sports push wakes'};

Array(77,1) = {'men protect spouses'};
Array(77,2) = {'men protect preserve'};

48

Array(5,1) = {'readers return books'};
Array(5,2) = {'readers return picked'};

Array(6,1) = {'dealers run companies'};
Array(6,2) = {'dealers run walking'};

Array(10,1) = {'buyers reach deals'};
Array(10,2) = {'buyers reach touched'};

Array(26,1) = {'breaks release stress'};
Array(26,2) = {'breaks release holds'};

Array(27,1) = {'parrots repeat words'};
Array(27,2) = {'parrots repeat recite'};

Array(54,1) = {'bakers roll dough'};
Array(54,2) = {'bakers roll turns'};

Array(55,1) = {'doctors save lives'};
Array(55,2) = {'doctors save rescued'};

Array(75,1) = {'vendors sold hats'};
Array(75,2) = {'vendors sold lend'};

Array(79,1) = {'actors won awards'};
Array(79,2) = {'actors won compete'};

74

Array(41,1) = {'choruses sing songs'};
Array(41,2) = {'choruses sing yell'};

Array(36,1) = {'priests say prayers'};
Array(36,2) = {'priests say talked'};

Array(28,1) = {'joiners screw hinges'};
Array(28,2) = {'joiners screw tighten'};

Array(12,1) = {'bearers sent messages'};
Array(12,2) = {'bearers sent deliver'};

Array(4,1) = {'tigers show pride'};
Array(4,2) = {'tigers show warn'};

Array(15,1) = {'bees suck nectar'};
Array(15,2) = {'bees suck digest'};

Array(21,1) = {'polls suggest results'};
Array(21,2) = {'polls suggest manage'};

Array(78,1) = {'elders tell tales'};
Array(78,2) = {'elders tell reveal'};

67

46

23

13

textpt3= Array(wordNo,condition);