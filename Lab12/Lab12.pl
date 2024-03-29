% readList(+N, -List)
readList(0, []) :- !.
readList(N, [Head | Tail]) :- read(Head), !, New_N is N - 1, readList(New_N, Tail).

writeList([]) :- !.
writeList([Head | Tail]) :- write(Head), nl, writeList(Tail).

nod(A, 0, A) :- !.
nod(A, B, X) :- C is A mod B, nod(B, C, X).

is_Simple(1) :- !, fail.
is_Simple(X) :- is_Simple(X, 2).
is_Simple(X, X) :- !.
is_Simple(X, I) :- 0 =:= (X mod I), !, fail;
                 I1 is I + 1, is_Simple(X, I1), !.

fact(N, X) :- fact(N, X, 0, 1).
fact(N, X, N, X) :- !.
fact(N, X, N1, Res) :- N2 is N1 + 1, X2 is N2 * Res, fact(N, X, N2, X2).

% 11 Найти сумму непростых делителей числа (рекурсия вверх)
notSimDelSum_Up(X, Res) :- nsds(X, X, Res).
nsds(_, 2, 1) :- !.
nsds(X, I, Res) :- I1 is I - 1, nsds(X, I1, Res1), (not(is_Simple(I)), 0 =:= (X mod I), Res is Res1 + I; Res is Res1), !.

% 11 Найти сумму непростых делителей числа (рекурсия вниз)
notSimDelSum_Down(X, Res) :- nsds_(X, X, 1, Res).
nsds_(_, 2, Res, Res) :- !.
nsds_(X, I, CurSum, Res) :- I1 is I - 1, (not(is_Simple(I)), 0 =:= (X mod I), !), NewSum is CurSum + I, nsds_(X, I1, NewSum, Res);
                         I2 is I - 1, nsds_(X, I2, CurSum, Res).

% 12 Найти количество чисел, не являющихся делителями исходного числа,
% не взамнопростых с ним и взаимно простых с суммой простых цифр этого числа.
ssd(0, 0) :- !. % сумма простых цифр числа
ssd(X, Res) :- X1 is X div 10, ssd(X1, Res1), Dig is X mod 10, (is_Simple(Dig), Res is Res1 + Dig; Res is Res1), !.

task12(X, Kol) :- task12(X, X, Kol).
task12(_, 2, 0) :- !.
task12(X, I, Kol) :- I1 is I - 1, task12(X, I1, Kol1), ssd(X, Sum), nod(X, I, Res1), nod(Sum, I, Res2), 
                  (0 =\= (X mod I), 1 =\= Res1, 1 =:= Res2, Kol is Kol1 + 1; Kol is Kol1), !.

% 13 Найдите сумму всех чисел, которые равны сумме факториалов их цифр. 
% Примечание: так как 1! = 1 и 2! = 2 не являются суммами, они не включены.
digitSum(X, Sum) :- digitSum(X, Sum, 0).
digitSum(0, Sum, Sum) :- !.
digitSum(X, Sum, CurSum) :- Dig is X mod 10, fact(Dig, Dig1), NewSum is CurSum + Dig1, X1 is X div 10, digitSum(X1, NewSum, Sum).

is_WowNumber(X) :- digitSum(X, FactSum), X = FactSum.

task13(Result) :- task13(10000, 0, Result).
task13(2, Result, Result) :- !.
task13(CurN, CurSum, Result) :- NewN is CurN - 1, (is_WowNumber(CurN), NewSum is CurSum + CurN; NewSum is CurSum), 
                             task13(NewN, NewSum, Result), !. 

% 14 Построить предикат, получающий длину списка
getLengthList([Head | Tail], Length) :- len([ Head | Tail ], 0, Length).
len([], Length, Length).
len([ _ | Tail ], CurLength, Length) :- NewLength is CurLength + 1, len(Tail, NewLength, Length).

% 15_5 Дан целочисленный массив и индекс. Необходимо определить является ли элемент по указанному индексу глобальным минимумом.
getMinList([Head | Tail], Min) :- getMinList([Head | Tail], Head, Min).
getMinList([], Min, Min) :- !.
getMinList([Head | Tail], CurMin, Min) :- (Head < CurMin, NewMin is Head; NewMin is CurMin), getMinList(Tail, NewMin, Min), !.

% Является ли элемент по указанному индексу глобальным минимумом
is_GlobalMin([], _, _) :- write('ERROR: Index > list`s length'), !, fail.
is_GlobalMin([Head | Tail], Index, Min) :- Index =\= 0, NewIndex is Index - 1, !, is_GlobalMin(Tail, NewIndex, Min); Head =:= Min.

task15 :- 
    write('Input list length: '), read(N), write('Input list: '), nl, readList(N, List), write('Input expected index: '), read(ExpIndex), 
    getMinList(List, Min), write('Is global min? '), (is_GlobalMin(List, ExpIndex, Min), write('YES!'); write('NO!')), !.

% 16_6 Осуществить циклический сдвиг элементов массива влево на три позиции.

%concatList(+A, +B, -C) :- присоединение списка B к списку A
concatList([], B, B) :- !.
concatList([Head | Tail], X, [Head | T]) :- concatList(Tail, X, T).

shift_left(Res, 0, Res) :- !.
shift_left([Head | Tail], N, Res) :- N1 is N - 1, concatList(Tail, [Head], Res1), shift_left(Res1, N1, Res), !.

task16 :- 
     write('Input list length: '), read(N), write('Input list: '), nl, readList(N, List), 
     shift_left(List, 3, ShList), write('Shifted list: '), nl, writeList(ShList), !.

% 17_18 Найти элементы, расположенные перед первым минимальным.

% Возвращает список до заданного числа X.
getList_beforeX([Head | Tail], X, Res) :- gl_bX([Head | Tail], X, [], Res).
gl_bX([], _, Res, Res) :- !.
gl_bX([Head | _], Head, Res, Res) :- !.
gl_bX([Head | Tail], X, CurRes, Res) :- concatList(CurRes, [Head], NewRes), gl_bX(Tail, X, NewRes, Res), !.

task17 :- 
    write('Input list length: '), read(N), write('Input list: '), nl, readList(N, List), 
    write('List before min: '), nl, getMinList(List, Min), getList_beforeX(List, Min, ResList), writeList(ResList), !.

% 18_20 Найти все пропущенные числа.
getMaxList([Head | Tail], Max) :- getMaxList([Head | Tail], Head, Max).
getMaxList([], Max, Max) :- !.
getMaxList([Head | Tail], CurMax, Max) :- (Head > CurMax, NewMax is Head; NewMax is CurMax), getMaxList(Tail, NewMax, Max), !.

% Есть ли элемент в списке.
inList([El|_],El) :- !.
inList([], _) :- !, fail.
inList([_|T],El) :- inList(T,El), !.

buildMissingList(List, Res) :- getMinList(List, Min), getMaxList(List, Max), bML(List, Min, Max, [], Res).
bML(_, Min, Min, Res, Res) :- !.
bML(List, Min, I, AccumList, Res) :- I1 is I - 1, (inList(List, I), concatList([], AccumList, NewList);
                                     concatList([I], AccumList, NewList)), bML(List, Min, I1, NewList, Res), !.

task18 :- 
        write('Input list length: '), read(N), write('Input list: '), nl, readList(N, List), 
        write('Missing list: '), nl, buildMissingList(List, ResList), writeList(ResList), !.

% 19_27 Осуществить циклический сдвиг элементов массива влево на одну позицию.
task19 :-
    write('Input list length: '), read(N), write('Input list: '), nl, readList(N, List), 
    shift_left(List, 1, ShList), write('Shifted list: '), nl, writeList(ShList), !.

%20_30 Определить является ли элемент по указанному индексу локальным максимумом.
is_LocalMax([Head | Tail], Index) :- is_LocalMax([Head | Tail], 1, Index).
is_LocalMax([Prev, Current, Next | _], Index, Index) :- Current > Prev, Current > Next.
is_LocalMax([_ | Tail], I, Index) :- I1 is I + 1, is_LocalMax(Tail, I1, Index), !.

task20 :-
    write('Input list length: '), read(N), write('Input list: '), nl, readList(N, List), 
    write('Input index: '), read(Index), write('Is local max: '), (is_LocalMax(List, Index), write('YES!'); write('NO!')), !.