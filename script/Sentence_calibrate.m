function [textpt3]=Sentence_calibrate(wordNo,condition);
Array=cell(32,2); %0 blank + 20 sentences

Array(1,1) = {'farmer picks fruits'};
Array(1,2) = {'farmer picks ate'};

Array(2,1) = {'matron buys ice'};
Array(2,2) = {'matron buys cash'};

Array(3,1) = {'chef reveals dish'};
Array(3,2) = {'chef reveals cook'};

Array(4,1) = {'breeder eats rain'};
Array(4,2) = {'breeder eats nope'};

Array(5,1) = {'teacher scolds kids'};
Array(5,2) = {'teacher scolds air'};

Array(6,1) = {'kids offend people'};
Array(6,2) = {'kids offend books'};

Array(7,1) = {'shop makes books'};
Array(7,2) = {'shop makes made'};

Array(8,1) = {'fan cools enemy'};
Array(8,2) = {'fan cools itself'};

Array(9,1) = {'manager keeps dogs'};
Array(9,2) = {'manager keeps sold'};

Array(10,1) = {'men move boxes'};
Array(10,2) = {'men move flew'};

Array(11,1) = {'police arrest people'};
Array(11,2) = {'police arrest men'};

Array(12,1) = {'reporter tells news'};
Array(12,2) = {'reporter tells never'};

Array(13,1) = {'driver steers boat'};
Array(13,2) = {'driver steers water'};

Array(14,1) = {'kids watch movie'};
Array(14,2) = {'kids watch array'};

Array(15,1) = {'ants build anthill'};
Array(15,2) = {'ants build monkeys'};

Array(16,1) = {'twin plays trumpet'};
Array(16,2) = {'twin plays walls'};

Array(17,1) = {'animals eat corn'};
Array(17,2) = {'animals eat ate'};

Array(18,1) = {'kids count numbers'};
Array(18,2) = {'kids count noticed'};

Array(19,1) = {'rice cooks nicely'};
Array(19,2) = {'rice cooks itself'};

Array(20,1) = {'logger cuts trees'};
Array(20,2) = {'logger cuts insects'};

Array(21,1) = {'students print notes'};
Array(21,2) = {'students print water'};

Array(22,1) = {'bank offers bonds'};
Array(22,2) = {'bank offers sold'};

Array(23,1) = {'soldiers fire guns'};
Array(23,2) = {'soldiers fire fired'};

Array(24,1) = {'boys break windows'};
Array(24,2) = {'boys break broken'};

Array(25,1) = {'girls carry dolls'};
Array(25,2) = {'girls carry guns'};

Array(26,1) = {'medics save lives'};
Array(26,2) = {'medics save money'};

Array(27,1) = {'nurses offer help'};
Array(27,2) = {'nurses offer hold'};

Array(28,1) = {'janitor mops floors'};
Array(28,2) = {'janitor mops wall'};

Array(29,1) = {'sailor steers boat'};
Array(29,2) = {'sailor steers bike'};

Array(30,1) = {'tutor teaches math'};
Array(30,2) = {'tutor teaches told'};

Array(31,1) = {'buses break down'};
Array(31,2) = {'buses break face'};

Array(32,1) = {'cats have fur'};
Array(32,2) = {'cats have wings'};

textpt3= Array(wordNo,condition);