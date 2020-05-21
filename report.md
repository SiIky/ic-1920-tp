# TP 1: Interacção e Concorrência

## Questão 1

Apresentamos de seguida o código em mCRL2 que define o modelo de um contador com o processo $Ct$ referido no enunciado.
De forma a ser viável a apresentação com as ferramentas utilizadas colocamos $N = 10$ como valor limite de $n$.

```mcrl2
act up, zr, dw;
proc Ct(n: Int) = (n > 0)
               -> (dw . Ct(pred(n)) + up . Ct(succ(n)))
               <> (up . Ct(1) + zr . Ct(0)) ;
init Ct(0);
```

Utilizámos as ferramentas `lpsxsim`, `ltsgraph` e `ltsview` para observar o comportamento deste processo.

### ltsgraph

Usamos esta ferramenta de forma a verificar o  grafo de transição do processo.

![ltsgraph](ltsgraph_contador.png)

### lpsxsim

Usamos esta ferramenta para verificar de forma local, em cada estado, que ações são possíveis de realizar.

![lpsxsim - O estado $Ct_0$ apenas permite as ações $zr$, que volta para o mesmo estado, e $up$, que passa para o estado $Ct_1$.](lpsxsim0.png)


![lpsxsim - Qualquer estado $Ct_n$, com $1 < n < 9$, permite as ações $up$, que transita para $Ct_{n+1}$, e $dw$, que transita para $Ct_{n-1}$.](lpsxsim1.png)

![lpsxsim - O estado $Ct_{10}$ apenas permite a ação $dw$ que transita para $Ct_9$.](lpsxsim10.png)

### ltsview

Esta ferramenta permite-nos verificar as ações possíveis de realizar em cada estado, como com lpsxsim, acrescentando uma parte gráfica em 3D ajudando na percepção da mesma.

![ltsview - $Ct_0$](ltsview0.png)

![ltsview - $Ct_3$](ltsview3.png)

![ltsview - $Ct_{10}$](ltsview10.png)

\pagebreak

## Questão 2

Os processos $C^n$ e $Ct_n$ ($n \in \mathbb{N}$) sao deterministas pois $\forall\ p \in S, a \in N : \exists! q \in S : (p, a, q) \in \rightarrow$[^lts_determinism], e como tal, $Tr(C^n) = Tr(Ct_n) \Leftrightarrow C^n \sim Ct_n \Rightarrow C^n = Ct_n$. Portanto a nossa prova é a de igualdade dos traços de $C^n$ e de $Ct_n$.

Caso $n = 0$:
 :  $$Tr(C^n) = Tr(Ct_n)$$
    $$\Leftrightarrow \{\ def\ Tr\ \}$$
    $$\{\epsilon\} \cup zr \cdot Tr(C^n) \cup up \cdot Tr(C^{n+1}) = \{\epsilon\} \cup zr \cdot Tr(Ct_n) \cup up \cdot Tr(Ct_{n+1})$$

Caso $n > 0$:
 :  $$Tr(C^n) = Tr(Ct_n)$$
    $$\Leftrightarrow \{\ def\ Tr\ \}$$
    $$\{\epsilon\} \cup dw \cdot Tr(C^{n-1}) \cup up \cdot Tr(C^{n+1}) = \{\epsilon\} \cup dw \cdot Tr(Ct_{n-1}) \cup up \cdot Tr(Ct_{n+1})$$

Tanto no caso $n = 0$, como no caso $n > 0$, existe uma dependência do caso seguinte, $n + 1$; no entanto, este caso $n + 1$ pode ser provado de forma similar, e portanto a prova é válida.

## Questão 3

A ferramenta mCRL2 não permite implementar a versão genérica, descrita no enunciado, dos processos $C$, $P$, e $Z$, portanto não será possível verificar a igualdade dos dois modelos com a ferramenta. No entanto, é possível implementar uma versão mais restrita e finita de $C$ e $Ct$, e verificar a igualdade entre estes dois modelos.

Para fim exemplificativo, decidimos implementar uma versão de cada processo limitada a 3, i.e., um contador até 3.

A implementação do processo $C$ é inspirada na implementação de buffers estudada nas aulas[^buffers], que consiste na composição paralela de várias células unárias, e é a seguinte:

```mcrl2
act dw, up, zr, zr0, zr1, zr2, m01', m12', m01, m12 ;
proc
    C = zr . C + up . dw . C ;
    C0 = rename({zr->zr0,           dw->m01'}, C);
    C1 = rename({zr->zr1, up->m01', dw->m12'}, C);
    C2 = rename({zr->zr2, up->m12'},           C);
init hide({m01, m12},
        allow({up, dw, zr, m01, m12},
            comm({zr0|zr1|zr2->zr,
                  m01'|m01'->m01,
                  m12'|m12'->m12 },
                 C0||C1||C2)));
```

E do processo $Ct$:

```mcrl2
act up, zr, dw;
map N : Int;
eqn N = 3;
proc Ct(n: Int) = (n > 0)
               -> (dw . Ct(pred(n))
                  + ((n < N) -> up . Ct(succ(n))))
               <> (up . Ct(1) + zr . Ct(0));
init Ct(0);
```

Correndo o comando que se segue, podemos testar a igualdade dos dois modelos para todos os critérios de equivalência suportados pela ferramenta:

```sh
for MET in \
    bisim \
    bisim-gv \
    bisim-gjkw \
    branching-bisim \
    branching-bisim-gv \
    branching-bisim-gjkw \
    dpbranching-bisim \
    dpbranching-bisim-gv \
    dpbranching-bisim-gjkw \
    weak-bisim \
    dpweak-bisim \
    sim \
    ready-sim \
    trace \
    weak-trace \
do
echo "$(ltscompare -q -e "$MET" Ctm_lim.lts Cm.lts)\t$MET"
done
```

E como resultado obtemos o seguinte:

```
false	bisim
false	bisim-gv
false	bisim-gjkw
true	branching-bisim
true	branching-bisim-gv
true	branching-bisim-gjkw
true	dpbranching-bisim
true	dpbranching-bisim-gv
true	dpbranching-bisim-gjkw
true	weak-bisim
true	dpweak-bisim
false	sim
false	ready-sim
false	trace
true	weak-trace
```

De notar que são equivalentes pelos critérios de Bissimulação Fraca (`weak-bisim`) e comparação fraca de traços (`weak-trace`).

## Questão 4

Iremos apresentar propriedades de segurança e animação sobre o processo $Ct_m$.

### Alínea _a_

#### Propriedades de Segurança

 1. `[true*.up.zr]false` -- Impossível fazer transição por $up$ seguida de $zr$.

$\forall n \in \mathbb{N},  Ct_n \in \{ Ct_n |  n>=0 \}$, logo $Ct_n \vDash$ `<up>true`

 2. `[true*]<true>true` -- Qualquer sequência de ações chega sempre a um estado que tem a possibilidade de fazer mais uma ação, i.e., ausência de deadlock.


 3. `[true*.zr.dw]false` -- Impossível haver uma transição por $zr$ seguida de $dw$.


#### Propriedades de Animação

 1. `[up]<dw>true` -- Depois de aumentar o contador com a ação $up$, podemos sempre decrementar com a ação $dw$.
 2. `[zr+]<zr+up>true` -- Após um ou mais $zr$ pode ser feito um $zr$ ou um $up$.
 3. `[up.up]<dw><dw>true` -- Após duas transições seguidas por $up$ é sempre possível duas transições seguidas por $dw$.

### Alínea _b_

![Após criar um ficheiro mcf com a respectiva propriedade temporal, a cada um aplicamos as ferramentas lps2pbes e pbes2bool para verificar a validade da propriedade. Como se pode verificar todas deram true pelo que se verifica que são válidas.](temporalProperties.png)

## Questão 5

### Alínea _a_

```mcrl2
act
    empty0, empty1, empty2, empty ;
    m01, m12, m01', m12', enqueue, dequeue : Bool ;

proc
    C = sum n: Bool . (empty . C + enqueue(n) . dequeue(n) . C) ;
    C0 = rename({empty->empty0, dequeue->m01'}, C);
    C1 = rename({empty->empty1, enqueue->m01', dequeue->m12'}, C);
    C2 = rename({empty->empty2, enqueue->m12'}, C);

init
    hide({m01, m12},
        allow({enqueue, dequeue, empty, m01, m12},
            comm({
                  empty0|empty1|empty2->empty,
                  m01'|m01'->m01,
                  m12'|m12'->m12
                 },
                 C0||C1||C2
            )
        )
    )
    ;
```

### Alínea _b_

## Referências

 * [_Labelled transition systems: Determinism_]
 * [_Process Algebra_]

[^buffers]: Ver slides [_Process Algebra_] (Ficheiro `IeC-PA1.pdf`)
[^lts_determinism]: Ver [_Labelled transition systems: Determinism_]

[_Labelled transition systems: Determinism_]: https://www.mcrl2.org/web/user_manual/articles/lts.html#determinism
[_Process Algebra_]: https://arca.di.uminho.pt/ic-1920/slides/IeC-PA2.pdf
