;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname simulador-cometas-lab) (read-case-sensitive #t) (teachpacks ((lib "draw.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "draw.rkt" "teachpack" "htdp")) #f)))
;; Projeto: Fundamentos de Algoritmos
;; Período: 2016-1
;; Tarefa: Laboratório 5
;;
;; Responsável: Luiz Gustavo Frozi de Castro e Souza / 96957
;;
;; Changelog: 
;;     * 2016-06-20
;;         - Definição de Estruturas
;;         - Funções para manipulação

;; Posição (nos eixos X e Y)
;; Para as posições será utilizada uma estrutura do tipo posn, que já prevê dois campos (X e Y)
;; para representar os deslocamentos em ambos eixos
(define pos1 (make-posn  50   0))
(define pos2 (make-posn 150   5))
(define pos3 (make-posn 250  30))
(define pos4 (make-posn  50 100))
(define pos5 (make-posn 150 150))
(define pos6 (make-posn 250 200))

;; Velocidades (deslocamento em X e Y)
;; Para as velocidades será utilizada uma estrutura do tipo posn, que já prevê dois campos (X e Y)
;; para representar os deslocamentos em ambos eixos
(define v1 (make-posn 10 10))
(define v2 (make-posn 5 5))
(define v3 (make-posn 1 1))

;; Dimensões do espaço
(define WIDTH 300)
(define HEIGHT 300)
(start WIDTH HEIGHT)

;; Tempo da simulação
(define DELAY .1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-struct cometa (tamanho posicao velocidade material))
;; Representa um cometa no espaço
;; Um elemento cometa do conjunto Cometa é uma estrutura do tipo:
;; (make-cometa t p v m)
;; onde:
;; t (número): Tamanho do cometa, raio, em pixels
;; p (posn): Posição do centro de massa do cometa no espaço
;; v (posn): Velocidade do cometa, ou seja, o deslocamento em cada um dos eixos de coordenadas,
;;           em pixels
;; m (string): Material do cometa
;; Exemplos
(define c1 (make-cometa 10 pos1 v1 "Ferro"))
(define c2 (make-cometa 20 pos2 v2 "Quartzo"))
(define c3 (make-cometa 30 pos3 v3 "Gelo"))

;; lista-de-cometas
;; Uma lista-de-cometas é uma lista definida como.
;; 1. Lista Vazia, ou empty
;; 2. ou (cons c ldc), onde
;;     c (cometa): É um elemento do tipo Cometa
;;     ldc (lista-de-cometas): Lista de Cometas
;;
;; Exemplo:
(define ldc (cons c1 (cons c2 (cons c3 empty))))

;; mover-cometa : cometa -> cometa
;; Objetivo: Criar uma nova estrutura do tipo Cometa, simulando o movimento de um cometa
;; usando as informações de posição do pŕoprio cometa passado como parâmetro.
;; Exemplos:
;; (mover-cometa c1) -> (make-cometa 10 (make-posn 60 10) v1 "Ferro")
;; (mover-cometa c2) -> (make-cometa 20 (make-posn 155 10) v2 "Quartzo")
;; (mover-cometa c3) -> (make-cometa 30 (make-posn 251 31) v3 "Gelo")
(define (mover-cometa um-cometa)
  (make-cometa
   (cometa-tamanho um-cometa)
   (make-posn
    (+ (posn-x (cometa-posicao um-cometa)) (posn-x (cometa-velocidade um-cometa)))
    (+ (posn-y (cometa-posicao um-cometa)) (posn-y (cometa-velocidade um-cometa))))
   (cometa-velocidade um-cometa)
   (cometa-material um-cometa)))
;; Testes:
(check-expect (mover-cometa c1) (make-cometa 10 (make-posn 60 10) v1 "Ferro"))
(check-expect (mover-cometa c2) (make-cometa 20 (make-posn 155 10) v2 "Quartzo"))
(check-expect (mover-cometa c3) (make-cometa 30 (make-posn 251 31) v3 "Gelo"))

;; no-espaco? : cometa  ->  boolean
;; Objetivo: Determinar se o cometa não saiu do espaço delimitado
;; Exemplos:
;; (no-espaco? c1) -> true
;; (no-espaco? (make-cometa 10 (make-posn 1000 10) v1 "Ferro")) -> false
(define (no-espaco? um-cometa)
  (and (<= 0 (posn-x (cometa-posicao um-cometa)) WIDTH)
       (<= 0 (posn-y (cometa-posicao um-cometa)) HEIGHT)))
;; Testes
(check-expect (no-espaco? c1) true)
(check-expect (no-espaco? (make-cometa 10 (make-posn 1000 10) v1 "Ferro")) false)

;; desenhar-e-limpar : cometa  ->  true
;; Objetivo: Desenhar um cometa no espaço, aguardar um tempo e apagá-lo.
;; Os cometas são desenhados em azul.
;; Exemplos:
;; (desenhar-e-limpar c1) -> true
;; (desenhar-e-limpar c2) -> true
;; (desenhar-e-limpar c3) -> true
(define (desenhar-e-limpar um-cometa)
  (and (draw-solid-disk (cometa-posicao um-cometa) (cometa-tamanho um-cometa) 'blue)
       (sleep-for-a-while DELAY)
       (clear-solid-disk (cometa-posicao um-cometa) (cometa-tamanho um-cometa) 'blue)))
;; Testes:
(check-expect (desenhar-e-limpar c1) true)
(check-expect (desenhar-e-limpar c2) true)
(check-expect (desenhar-e-limpar c3) true)
(desenhar-e-limpar c1)
(desenhar-e-limpar c2)
(desenhar-e-limpar c3)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-struct planeta (tamanho posicao campo-gravitacional))
;; Representa um planeta no espaço
;; Um elemento planeta do conjunto Planeta é uma estrutura do tipo:
;; (make-planeta t cg p)
;; onde:
;; t (número): Tamanho do planeta, raio, em pixels
;; p (posn): Posição do centro de massa do planeta no espaço
;; cg (número): Força do Campo Gravitacional do planeta, que atrai (valor positivo)
;;              ou repele (valor negativo) os cometas, é um fator que multiplica o
;;              deslocamento, em pixels, em ambas direções
;; Exemplos
(define p1 (make-planeta 50 pos4 -1))
(define p2 (make-planeta 100 pos5 5))
(define p3 (make-planeta 75 pos6 2))

;; lista-de-planetas
;; Uma lista-de-planetas é uma lista definida como.
;; 1. Lista Vazia, ou empty
;; 2. ou (cons p ldp), onde
;;     p (planeta): É um elemento do tipo Planeta
;;     ldp (lista-de-planetas): Lista de Planetas
;;
;; Exemplo:
(define ldp (cons p1 (cons p2 (cons p3 empty))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
