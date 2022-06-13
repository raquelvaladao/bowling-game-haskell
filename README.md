## Bowling game

A Haskell game developed for Functional Programming course.

## Haskell and Typescript

Firstly, this code was made in Typescript (bowling.ts) due to its syntatic sugar while making a full use of recursion and immutability, so then it could get a super-simple rewriting process to Haskell.

## How to run it

first you need ghc to compile the hs file https://www.haskell.org/downloads/

then compile

```
ghc bowling.hs
```
then run
```
./bowling 
```

## in // out 
 
#### 1-full set of strikes
```
IN:
10 10 10 10 10 10 10 10 10 10 10 10

OUT:
X_ | X_ | X_ | X_ | X_ | X_ | X_ | X_ | X_ | X X X TOTAL: 300
```


#### 2 - strike in the 10th frame with a spare after
```
IN:
4 5 6 4 3 2 5 4 5 5 10 10 9 1 2 4 10 3 7

OUT:
4 5 | 6 / | 3 2 | 5 4 | 5 / | X_ | X_ | 9 / | 2 4 | X 3 / TOTAL: 143
```

#### 3 - spare at the end
```
IN:
1 4 4 5 6 4 5 5 10 0 1 7 3 6 4 10 2 8 6

OUT:
1 4 | 4 5 | 6 / | 5 / | X_ | 0 1 | 7 / | 6 / | X_ | 2 / 6 TOTAL: 133
```

#### 4 - strike at the 10th frame then other numbers
```
IN:
2 3 2 3 4 3 6 4 3 2 3 3 2 3 2 4 3 2 10 10 8

OUT:
2 3 | 2 3 | 4 3 | 6 / | 3 2 | 3 3 | 2 3 | 2 4 | 3 2 | X X 8 TOTAL: 85
```