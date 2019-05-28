KEVM Lemmas
===========

```k
requires "evm.k"

module KEVM-LEMMAS-SPEC
    imports EVM
```

```k
    rule <k> #next [ PUSH(N, M) ] => . ... </k>
         <schedule> SCHEDULE </schedule>
         <pc> PCOUNT => PCOUNT +Int #widthOp(PUSH(N, M)) </pc>
         <wordStack> WS => M : WS </wordStack>
         <gas> G => G -Int Gverylow < SCHEDULE > </gas>
       requires #range(0 <= M < pow256)
        andBool notBool ( #stackUnderflow(WS, PUSH(N, M)) orBool #stackOverflow(WS, PUSH(N, M)) )
        andBool G >=Int Gverylow < SCHEDULE >
      [trusted]
```

```k
    rule <k> #next [ POP ] => . ... </k>
         <schedule> SCHEDULE </schedule>
         <pc> PCOUNT => PCOUNT +Int #widthOp(POP) </pc>
         <wordStack> W : WS => WS </wordStack>
         <gas> G => G -Int Gbase < SCHEDULE > </gas>
       requires #range(0 <= W < pow256)
        andBool notBool ( #stackUnderflow(W : WS, POP) orBool #stackOverflow(W : WS, POP) )
        andBool G >=Int Gbase < SCHEDULE >
      [trusted]
```

```k
    rule <k> #next [ ADD ] => . ... </k>
         <schedule> SCHEDULE </schedule>
         <pc> PCOUNT => PCOUNT +Int 1 </pc>
         <wordStack> X : Y : WS => X +Word Y : WS </wordStack>
         <gas> G => G -Int Gverylow < SCHEDULE > </gas>
       requires #range(0 <= X < pow256)
        andBool #range(0 <= Y < pow256)
        andBool notBool ( #stackUnderflow(X : Y : WS, ADD) orBool #stackOverflow(X : Y : WS, ADD) )
        andBool G >=Int Gverylow < SCHEDULE >
      [trusted]
```

```k
    rule <k> #next [ SUB ] => . ... </k>
         <schedule> SCHEDULE </schedule>
         <pc> PCOUNT => PCOUNT +Int 1 </pc>
         <wordStack> X : Y : WS => X -Word Y : WS </wordStack>
         <gas> G => G -Int Gverylow < SCHEDULE > </gas>
       requires #range(0 <= X < pow256)
        andBool #range(0 <= Y < pow256)
        andBool notBool ( #stackUnderflow(X : Y : WS, ADD) orBool #stackOverflow(X : Y : WS, ADD) )
        andBool G >=Int Gverylow < SCHEDULE >
      [trusted]
```

```k
    rule <k> #next [ MUL ] => . ... </k>
         <schedule> SCHEDULE </schedule>
         <pc> PCOUNT => PCOUNT +Int 1 </pc>
         <wordStack> X : Y : WS => X *Word Y : WS </wordStack>
         <gas> G => G -Int Glow < SCHEDULE > </gas>
       requires #range(0 <= X < pow256)
        andBool #range(0 <= Y < pow256)
        andBool notBool ( #stackUnderflow(X : Y : WS, ADD) orBool #stackOverflow(X : Y : WS, ADD) )
        andBool G >=Int Glow < SCHEDULE >
      [trusted]
```

```k
    rule <k> #next [ DIV ] => . ... </k>
         <schedule> SCHEDULE </schedule>
         <pc> PCOUNT => PCOUNT +Int 1 </pc>
         <wordStack> X : Y : WS => X /Word Y : WS </wordStack>
         <gas> G => G -Int Glow < SCHEDULE > </gas>
       requires #range(0 <= X < pow256)
        andBool #range(0 <= Y < pow256)
        andBool notBool ( #stackUnderflow(X : Y : WS, ADD) orBool #stackOverflow(X : Y : WS, ADD) )
        andBool G >=Int Glow < SCHEDULE >
      [trusted]
```

```k
    rule <k> #next [ DUP(N) ] => . ... </k>
         <schedule> SCHEDULE </schedule>
         <pc> PCOUNT => PCOUNT +Int 1 </pc>
         <wordStack> WS => WS [ N -Int 1 ] : WS </wordStack>
         <gas> G => G -Int Gverylow < SCHEDULE > </gas>
       requires notBool ( #stackUnderflow(WS, DUP(N)) orBool #stackOverflow(WS, DUP(N)) )
        andBool G >=Int Gverylow < SCHEDULE >
      [trusted]
```

```k
    rule <k> #next [ SWAP(N) ] => . ... </k>
         <schedule> SCHEDULE </schedule>
         <pc> PCOUNT => PCOUNT +Int 1 </pc>
         <wordStack> W0 : WS => WS [ N -Int 1 ] : (WS [ N -Int 1 := W0 ]) </wordStack>
         <gas> G => G -Int Gverylow < SCHEDULE > </gas>
       requires notBool ( #stackUnderflow(W0 : WS, SWAP(N)) orBool #stackOverflow(W0 : WS, SWAP(N)) )
        andBool G >=Int Gverylow < SCHEDULE >
      [trusted]
```

```k
    rule <k> #next [ MLOAD ] => . ... </k>
         <schedule> SCHEDULE </schedule>
         <pc> PCOUNT => PCOUNT +Int 1 </pc>
         <wordStack> INDEX : WS => #asWord(#range(LM, INDEX, 32)) : WS </wordStack>
         <gas> G => G -Int (Cmem(SCHEDULE, #memory(MLOAD INDEX, MU)) -Int Cmem(SCHEDULE, MU)) -Int Gverylow < SCHEDULE > </gas>
         <localMem> LM </localMem>
         <memoryUsed> MU => #memory(MLOAD INDEX, MU) </memoryUsed>
       requires notBool ( #stackUnderflow(INDEX : WS, MLOAD) orBool #stackOverflow(INDEX : WS, MLOAD) )
        andBool G >=Int (Cmem(SCHEDULE, #memory(MLOAD INDEX, MU)) -Int Cmem(SCHEDULE, MU))
        andBool G -Int (Cmem(SCHEDULE, #memory(MLOAD INDEX, MU)) -Int Cmem(SCHEDULE, MU)) >=Int Gverylow < SCHEDULE >
      [trusted]
```

```k
    rule <k> #next [ MSTORE ] => . ... </k>
         <schedule> SCHEDULE </schedule>
         <pc> PCOUNT => PCOUNT +Int 1 </pc>
         <wordStack> INDEX : VALUE : WS => WS </wordStack>
         <gas> G => G -Int (Cmem(SCHEDULE, #memory(MSTORE INDEX VALUE, MU)) -Int Cmem(SCHEDULE, MU)) -Int Gverylow < SCHEDULE > </gas>
         <localMem> LM => LM [ INDEX := #padToWidth(32, #asByteStack(VALUE)) ] </localMem>
         <memoryUsed> MU => #memory(MSTORE INDEX VALUE, MU) </memoryUsed>
       requires notBool ( #stackUnderflow(INDEX : VALUE : WS, MSTORE) orBool #stackOverflow(INDEX : VALUE : WS, MSTORE) )
        andBool G >=Int (Cmem(SCHEDULE, #memory(MSTORE INDEX VALUE, MU)) -Int Cmem(SCHEDULE, MU))
        andBool G -Int (Cmem(SCHEDULE, #memory(MSTORE INDEX VALUE, MU)) -Int Cmem(SCHEDULE, MU)) >=Int Gverylow < SCHEDULE >
      [trusted]
```

```
    rule <k> PUSH(N, X) ; PUSH(M, Y) ; ADD ; .OpCodes => . ... </k>
         <schedule> SCHEDULE </schedule>
         <pc> PCOUNT => PCOUNT +Int #widthOps(PUSH(N, X) ; PUSH(M, Y) ; ADD ; .OpCodes) </pc>
         <wordStack> WS => X +Word Y : WS </wordStack>
         <gas> G => G -Int Gverylow < SCHEDULE > -Int Gverylow < SCHEDULE > -Int Gverylow < SCHEDULE > </gas>
       requires #range(0 <= X < pow256)
        andBool #range(0 <= Y < pow256)
        andBool notBool ( #stackUnderflow(       WS, PUSH(N, X)) orBool #stackOverflow(        WS, PUSH(N, X))
                   orBool #stackUnderflow(   X : WS, PUSH(N, Y)) orBool #stackOverflow(    Y : WS, PUSH(N, Y))
                   orBool #stackUnderflow(Y: X : WS, ADD)        orBool #stackOverflow(X : Y : WS, ADD)
                        )
        // andBool notBool ( #stackUnderflow(       WS, PUSH(N, X)) orBool #stackOverflow(        WS, PUSH(N, X)) )
        // andBool notBool ( #stackUnderflow(   X : WS, PUSH(N, Y)) orBool #stackOverflow(    Y : WS, PUSH(N, Y)) )
        // andBool notBool ( #stackUnderflow(Y: X : WS, ADD)        orBool #stackOverflow(X : Y : WS, ADD)        )
        // andBool notBool (sizeWordStackAux(WS, 0) <Int 0 orBool sizeWordStackAux(WS, 0) +Int  1 >Int 1024)
        // andBool notBool (sizeWordStackAux(WS, 1) <Int 0 orBool sizeWordStackAux(WS, 1) +Int  1 >Int 1024)
        // andBool notBool (sizeWordStackAux(WS, 2) <Int 2 orBool sizeWordStackAux(WS, 2) +Int -1 >Int 1024)
        andBool G >=Int Gverylow < SCHEDULE >
        andBool G >=Int Gverylow < SCHEDULE > +Int Gverylow < SCHEDULE >
        andBool G >=Int Gverylow < SCHEDULE > +Int Gverylow < SCHEDULE > +Int Gverylow < SCHEDULE >
```

```k
endmodule
```
