function [textpt3]=Sentence(wordNo,condition)
Array=cell(32,4); %2 blank + 30 sentences

Array(1,1) = {'lawyers handle cases'};
Array(1,2) = {'lawyers handle fought'};
Array(1,3) = {125};
Array(1,4) = {6};

Array(2,1) = {'friends watch movies'};
Array(2,2) = {'friends watch discuss'};
Array(2,3) = {125};
Array(2,4) = {1};

Array(3,1) = {'readers return books'};
Array(3,2) = {'readers return picked'};
Array(3,3) = {123};
Array(3,4) = {2};

Array(4,1) = {'parrots repeat words'};
Array(4,2) = {'parrots repeat recite'};
Array(4,3) = {122};
Array(4,4) = {2};

Array(5,1) = {'breaks release stress'};
Array(5,2) = {'breaks release holds'};
Array(5,3) = {121};
Array(5,4) = {5};

Array(6,1) = {'videos include music'};
Array(6,2) = {'videos include thinks'};
Array(6,3) = {120};
Array(6,4) = {2};

Array(7,1) = {'joiners screw hinges'};
Array(7,2) = {'joiners screw tighten'};
Array(7,3) = {120};
Array(7,4) = {3};

Array(8,1) = {'humans hide secrets'};
Array(8,2) = {'humans hide appear'};
Array(8,3) = {119};
Array(8,4) = {3};

Array(9,1) = {'guards locked safes'};
Array(9,2) = {'guards locked fasten'};
Array(9,3) = {118};
Array(9,4) = {6};

Array(10,1) = {'clowns blow ballons'};
Array(10,2) = {'clowns blow blasting'};
Array(10,3) = {117};
Array(10,4) = {4};

Array(11,1) = {'doers grab chances'};
Array(11,2) = {'doers grab depends'};
Array(11,3) = {115};
Array(11,4) = {2};

Array(12,1) = {'firemen drive trucks'};
Array(12,2) = {'firemen drive retire'};
Array(12,3) = {114};
Array(12,4) = {6};

Array(13,1) = {'agents hurry clerks'};
Array(13,2) = {'agents hurry rotate'};
Array(13,3) = {113};
Array(13,4) = {2};

Array(14,1) = {'hosts give presents'};
Array(14,2) = {'hosts give operate'};
Array(14,3) = {112};
Array(14,4) = {6};

Array(15,1) = {'shops accept cash'};
Array(15,2) = {'shops accept spent'};
Array(15,3) = {111};
Array(15,4) = {7};

Array(16,1) = {'choruses sing songs'};
Array(16,2) = {'choruses sing yell'};
Array(16,3) = {110};
Array(16,4) = {16};

Array(17,1) = {'judges explain law'};
Array(17,2) = {'judges explain infer'};
Array(17,3) = {109};
Array(17,4) = {9};

Array(18,1) = {'keepers feed pets'};
Array(18,2) = {'keepers feed waits'};
Array(18,3) = {108};
Array(18,4) = {5};

Array(19,1) = {'women lost weight'};
Array(19,2) = {'women lost cease'};
Array(19,3) = {107};
Array(19,4) = {6};

Array(20,1) = {'firms make profits'};
Array(20,2) = {'firms make rushed'};
Array(20,3) = {106};
Array(20,4) = {0};

Array(21,1) = {'cats heard sounds'};
Array(21,2) = {'cats heard listens'};
Array(21,3) = {105};
Array(21,4) = {4};

Array(22,1) = {'chickens lay eggs'};
Array(22,2) = {'chickens lay serve'};
Array(22,3) = {104};
Array(22,4) = {3};

Array(23,1) = {'Army cut budgets'};
Array(23,2) = {'Army cut dissect'};
Array(23,3) = {103};
Array(23,4) = {6};

Array(24,1) = {'vendors sold hats'};
Array(24,2) = {'vendors sold lend'};
Array(24,3) = {102};
Array(24,4) = {2};

Array(25,1) = {'players kick balls'};
Array(25,2) = {'players kick settle'};
Array(25,3) = {102};
Array(25,4) = {7};

Array(26,1) = {'tigers show pride'};
Array(26,2) = {'tigers show warn'};
Array(26,3) = {100};
Array(26,4) = {1};

Array(27,1) = {'bees suck nectar'};
Array(27,2) = {'bees suck digest'};
Array(27,3) = {99};
Array(27,4) = {2};

Array(28,1) = {'bakers roll dough'};
Array(28,2) = {'bakers roll turns'};
Array(28,3) = {97};
Array(28,4) = {4};

Array(29,1) = {'elders tell tales'};
Array(29,2) = {'elders tell reveal'};
Array(29,3) = {92};
Array(29,4) = {6};

Array(30,1) = {'pilots fly planes'};
Array(30,2) = {'pilots fly moved'};
Array(30,3) = {92};
Array(30,4) = {1};

Array(31,1) = {''};
Array(31,2) = {''};

Array(32,1) = {''};
Array(32,2) = {''};

textpt3= Array(wordNo,condition);