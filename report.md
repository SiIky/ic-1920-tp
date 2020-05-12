# TP 1: Interação e Concorrência

## Questão 1

Apresentamos de seguida o código em mCRL2 que define o modelo de um contador com o processo $Ct$ referido no enunciado.
De forma a ser viável a apresentação com as ferramentas utilizadas colocamos $N = 10$ como valor limite de $n$.

```mcrl2
act up, zr, dw;
map N: Int;
eqn N = 10;

proc
    Ct(n: Int) =
            (n > 0)
               -> (dw . Ct(pred(n))
                  + ((n < N) -> up . Ct(succ(n))))
               <> (up . Ct(1) + zr . Ct(0))
    ;

init
    Ct(0);
```

Utilizámos as ferramentas `lpsxsim`, `ltsgraph` e `ltsview` para observar o comportamento deste processo.

### ltsgraph

Usamos esta ferramenta de forma a verificar o  grafo de transição do processo.

![ltsgraph](ltsgraph_contador.png)

### lpsxsim

Usamos esta ferramenta para verificar de forma local, em cada estado, que ações são possíveis de realizar.

![O estado $Ct_0$ apenas permite as ações $zr$, que volta para o mesmo estado, e $up$, que passa para o estado $Ct_1$.](lpsxsim0.png)


![Qualquer estado $Ct_n$, com $1<n<9$, permite as ações $up$, que transita para $Ct_{n+1}$, e $dw$, que transita para $Ct_{n-1}$.](lpsxsim1.png)

![O estado $Ct_{10}$ apenas permite a ação $dw$ que transita para $Ct_9$.](lpsxsim10.png)

### ltsview

Esta ferramenta permite-nos verificar as ações possíveis de realizar em cada estado, como com lpsxsim, acrescentando uma parte gráfica em 3D ajudando na percepção da mesma.

![ltsview $Ct_0$](ltsview0.png)

![ltsview $Ct_3$](ltsview3.png)

![ltsview $Ct_{10}$](ltsview10.png)

## Questão 2

(trivial)

## Questão 3

fácil

## Questão 4

## Questão 5

e era
